import smbus2
import bme280
import json
import time
import threading
from flask import Flask, jsonify

# pip3 install flask smbus2 RPi.bme280

# Raspberry Pi GPIO ピン配置（BMP280 接続）
#
#  Raspberry Pi  (GPIO)         BMP280 センサー（I2C）
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
# 【BMP280 接続方法（I2C）】
# - BMP280 の VCC → 3.3V
# - BMP280 の GND → GND
# - BMP280 の SDA → GPIO2（I2C SDA）
# - BMP280 の SCL → GPIO3（I2C SCL）

app = Flask(__name__)

# BMP280 の I2C 設定
I2C_PORT = 1
I2C_ADDRESS = 0x76  # BMP280 の一般的な I2C アドレス（0x77 になる場合もあり）
bus = smbus2.SMBus(I2C_PORT)

JSON_FILE = "/home/pi/sensors/bmp280_data.json"

def read_bmp280():
    """BMP280 センサーから温度・気圧を取得し、辞書で返す"""
    try:
        calibration_params = bme280.load_calibration_params(bus, I2C_ADDRESS)
        data = bme280.sample(bus, I2C_ADDRESS, calibration_params)
        
        return {
            "temperature": round(data.temperature, 2),
            "pressure": round(data.pressure, 2),
            "unit_temperature": "Celsius",
            "unit_pressure": "hPa",
            "timestamp": time.strftime("%Y-%m-%d %H:%M:%S")
        }
    except Exception as e:
        return {"error": f"Failed to read BMP280: {e}"}

def save_to_json():
    """定期的に JSON ファイルにセンサーデータを書き込む"""
    while True:
        data = read_bmp280()
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
    data = read_bmp280()
    return jsonify(data)

if __name__ == "__main__":
    # JSON 書き込み用のスレッドを開始
    threading.Thread(target=save_to_json, daemon=True).start()
    # Flask サーバーを実行
    app.run(host="0.0.0.0", port=5004, debug=False)
