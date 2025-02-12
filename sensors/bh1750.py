import smbus2
import json
import time
import threading
from flask import Flask, jsonify

# pip3 install flask smbus2

# Raspberry Pi GPIO ピン配置（BH1750 接続）
#
#  Raspberry Pi  (GPIO)         BH1750 センサー（I2C）
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
# 【BH1750 接続方法（I2C）】
# - BH1750 の VCC → 3.3V
# - BH1750 の GND → GND
# - BH1750 の SDA → GPIO2（I2C SDA）
# - BH1750 の SCL → GPIO3（I2C SCL）

app = Flask(__name__)

# BH1750 の I2C 設定
I2C_PORT = 1
I2C_ADDRESS = 0x23  # BH1750 のデフォルト I2C アドレス
bus = smbus2.SMBus(I2C_PORT)

JSON_FILE = "/home/pi/sensors/bh1750_data.json"

# BH1750 の測定モード
CONTINUOUS_HIGH_RES_MODE = 0x10

def read_bh1750():
    """BH1750 センサーから照度を取得し、辞書で返す"""
    try:
        bus.write_byte(I2C_ADDRESS, CONTINUOUS_HIGH_RES_MODE)
        time.sleep(0.2)  # 測定待機
        data = bus.read_i2c_block_data(I2C_ADDRESS, 0x00, 2)
        
        lux = (data[0] << 8) | data[1]
        lux = lux / 1.2  # BH1750 のスケール変換

        return {
            "lux": round(lux, 2),
            "unit": "lx",
            "timestamp": time.strftime("%Y-%m-%d %H:%M:%S")
        }
    except Exception as e:
        return {"error": f"Failed to read BH1750: {e}"}

def save_to_json():
    """定期的に JSON ファイルにセンサーデータを書き込む"""
    while True:
        data = read_bh1750()
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
    data = read_bh1750()
    return jsonify(data)

if __name__ == "__main__":
    # JSON 書き込み用のスレッドを開始
    threading.Thread(target=save_to_json, daemon=True).start()
    # Flask サーバーを実行
    app.run(host="0.0.0.0", port=5006, debug=False)
