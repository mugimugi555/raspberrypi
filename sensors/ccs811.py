import smbus2
import time
import json
import threading
from flask import Flask, jsonify
import Adafruit_CCS811

# pip3 install flask smbus2 Adafruit-CCS811

# Raspberry Pi GPIO ピン配置（CCS811 接続）
#
#  Raspberry Pi  (GPIO)         CCS811 センサー（I2C）
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
# 【CCS811 接続方法（I2C）】
# - CCS811 の VCC → 3.3V
# - CCS811 の GND → GND
# - CCS811 の SDA → GPIO2（I2C SDA）
# - CCS811 の SCL → GPIO3（I2C SCL）

app = Flask(__name__)

# CCS811 の I2C 設定
ccs = Adafruit_CCS811.CCS811()

JSON_FILE = "/home/pi/sensors/ccs811_data.json"

def read_ccs811():
    """CCS811 センサーから CO2, TVOC を取得し、辞書で返す"""
    try:
        if ccs.available():
            temp = ccs.calculateTemperature()
            if not ccs.readData():
                return {
                    "CO2": ccs.geteCO2(),
                    "TVOC": ccs.getTVOC(),
                    "temperature": round(temp, 2),
                    "unit_temperature": "Celsius",
                    "unit_CO2": "ppm",
                    "unit_TVOC": "ppb",
                    "timestamp": time.strftime("%Y-%m-%d %H:%M:%S")
                }
            else:
                return {"error": "Failed to read CCS811 sensor data"}
    except Exception as e:
        return {"error": f"CCS811 read failed: {e}"}

def save_to_json():
    """定期的に JSON ファイルにセンサーデータを書き込む"""
    while True:
        data = read_ccs811()
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
    data = read_ccs811()
    return jsonify(data)

if __name__ == "__main__":
    # JSON 書き込み用のスレッドを開始
    threading.Thread(target=save_to_json, daemon=True).start()
    # Flask サーバーを実行
    app.run(host="0.0.0.0", port=5005, debug=False)
