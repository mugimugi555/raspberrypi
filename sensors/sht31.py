import smbus2
import json
import time
import threading
from flask import Flask, jsonify

# pip3 install flask smbus2

# Raspberry Pi GPIO ピン配置（SHT31 接続）
#
#  Raspberry Pi  (GPIO)         SHT31 センサー（I2C）
#  +----------------------+      +-----------+
#  | 3.3V   | 5V          |      | [VCC]     |
#  | GPIO2  | 5V          |      | [SDA]     |
#  | GPIO3  | GND         |      | [SCL]     |
#  | GPIO4  | TX (UART)   |      | [GND]     |
#  | GND    | RX (UART)   |      +-----------+
#  | GPIO17 | GPIO18      |      
#  | GPIO27 | GND         |      
#  | GPIO22 | GPIO23      |      
#  | 3.3V   | GPIO24      |      
#  | GPIO10 | GND         |      
#  | GPIO9  | GPIO25      |      
#  | GPIO11 | GPIO8       |      
#  | GND    | GPIO7       |      
#  | ID_SD  | ID_SC       |      
#  | GPIO5  | GND         |      
#  | GPIO6  | GPIO12      |      
#  | GPIO13 | GND         |      
#  | GPIO19 | GPIO16      |      
#  | GPIO26 | GPIO20      |      
#  | GND    | GPIO21      |      
#  +----------------------+
#
# 【SHT31 接続方法（I2C）】
# - SHT31 の VCC → 3.3V
# - SHT31 の GND → GND
# - SHT31 の SDA → GPIO2（I2C SDA）
# - SHT31 の SCL → GPIO3（I2C SCL）

app = Flask(__name__)

# SHT31 の I2C 設定
I2C_PORT = 1
I2C_ADDRESS = 0x44  # SHT31 の一般的な I2C アドレス（0x45 になる場合もあり）
bus = smbus2.SMBus(I2C_PORT)

JSON_FILE = "/home/pi/sensors/sht31_data.json"

def read_sht31():
    """SHT31 センサーから温度・湿度を取得し、辞書で返す"""
    try:
        bus.write_i2c_block_data(I2C_ADDRESS, 0x2C, [0x06])  # 高精度測定開始
        time.sleep(0.5)  # 測定待機

        data = bus.read_i2c_block_data(I2C_ADDRESS, 0x00, 6)

        temp_raw = (data[0] << 8) | data[1]
        humidity_raw = (data[3] << 8) | data[4]

        temperature = -45 + (175 * (temp_raw / 65535.0))
        humidity = 100 * (humidity_raw / 65535.0)

        return {
            "temperature": round(temperature, 2),
            "humidity": round(humidity, 2),
            "unit_temperature": "Celsius",
            "unit_humidity": "%",
            "timestamp": time.strftime("%Y-%m-%d %H:%M:%S")
        }
    except Exception as e:
        return {"error": f"Failed to read SHT31: {e}"}

def save_to_json():
    """定期的に JSON ファイルにセンサーデータを書き込む"""
    while True:
        data = read_sht31()
        try:
            with open(JSON_FILE, "w") as f:
                json.dump(data, f, ensure_ascii=False, indent=4)
            print(f"Data saved: {data}")
        except Exception as e:
            print(f"Failed to write JSON: {e}")
        time.sleep(10)  # 10秒ごとに更新

@app.route("/")
def index():
    """センサーのデータを JSON 形式で返す"""
    data = read_sht31()
    return jsonify(data)

if __name__ == "__main__":
    # JSON 書き込み用のスレッドを開始
    threading.Thread(target=save_to_json, daemon=True).start()
    # Flask サーバーを実行
    app.run(host="0.0.0.0", port=5003, debug=False)
