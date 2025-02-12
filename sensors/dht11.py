import Adafruit_DHT
import json
import time
from flask import Flask, jsonify

# Raspberry Pi GPIO ピン配置（I2C 対応）
#
#  Raspberry Pi  (GPIO)         I2C センサー（例: BME280）
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
# 【I2C 接続方法】
# - Raspberry Pi の GPIO2 (SDA) を I2C センサーの SDA に接続
# - Raspberry Pi の GPIO3 (SCL) を I2C センサーの SCL に接続
# - Raspberry Pi の GND を I2C センサーの GND に接続
# - Raspberry Pi の 3.3V または 5V を I2C センサーの VCC に接続（センサーの仕様に合わせる）

app = Flask(__name__)

# センサーと GPIO ピンの設定
SENSOR = Adafruit_DHT.DHT11
PIN = 4

def read_dht11():
    """DHT11 センサーから温度と湿度を取得し、辞書で返す"""
    humidity, temperature = Adafruit_DHT.read_retry(SENSOR, PIN)
    return {
        "temperature": temperature,
        "humidity": humidity,
        "unit": "Celsius",
        "timestamp": time.strftime("%Y-%m-%d %H:%M:%S")
    }

@app.route("/")
def index():
    """センサーのデータを JSON 形式で返す"""
    data = read_dht11()
    return jsonify(data)

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000, debug=False)
