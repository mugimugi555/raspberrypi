import Adafruit_DHT
import json
import time
import threading
from flask import Flask, jsonify

# pip3 install flask Adafruit_DHT

# Raspberry Pi GPIO ピン配置（DHT11 接続）
#
#  Raspberry Pi  (GPIO)           DHT11 センサー
#  +----------------------+      +---------+
#  | 3.3V   | 5V          |      | [VCC]   |
#  | GPIO2  | 5V          |      |         |
#  | GPIO3  | GND         |      | [GND]   |
#  | GPIO4  | TX (UART)   |      | [DATA]  |
#  | GND    | RX (UART)   |      +---------+
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
# 【DHT11 接続方法】
# - DHT11 の VCC → 5V
# - DHT11 の GND → GND
# - DHT11 の DATA → GPIO4

app = Flask(__name__)

# センサーと GPIO ピンの設定
SENSOR = Adafruit_DHT.DHT11
PIN = 4
JSON_FILE = "/home/pi/sensors/dht11_data.json"

def read_dht11():
    """DHT11 センサーから温度と湿度を取得し、辞書で返す"""
    humidity, temperature = Adafruit_DHT.read_retry(SENSOR, PIN)
    return {
        "temperature": temperature,
        "humidity": humidity,
        "unit": "Celsius",
        "timestamp": time.strftime("%Y-%m-%d %H:%M:%S")
    }

def save_to_json():
    """定期的に JSON ファイルにセンサーデータを書き込む"""
    while True:
        data = read_dht11()
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
    data = read_dht11()
    return jsonify(data)

if __name__ == "__main__":
    # JSON 書き込み用のスレッドを開始
    threading.Thread(target=save_to_json, daemon=True).start()
    # Flask サーバーを実行
    app.run(host="0.0.0.0", port=5000, debug=False)
