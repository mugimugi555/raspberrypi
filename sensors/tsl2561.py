import smbus2
import json
import time
import threading
from flask import Flask, jsonify

# pip3 install flask smbus2

# Raspberry Pi GPIO ピン配置（TSL2561 接続）
#
#  Raspberry Pi  (GPIO)         TSL2561 センサー（I2C）
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
# 【TSL2561 接続方法（I2C）】
# - TSL2561 の VCC → 3.3V
# - TSL2561 の GND → GND
# - TSL2561 の SDA → GPIO2（I2C SDA）
# - TSL2561 の SCL → GPIO3（I2C SCL）

app = Flask(__name__)

# TSL2561 の I2C 設定
I2C_PORT = 1
I2C_ADDRESS = 0x39  # TSL2561 の一般的な I2C アドレス
bus = smbus2.SMBus(I2C_PORT)

JSON_FILE = "/home/pi/sensors/tsl2561_data.json"

# TSL2561 の制御レジスタ
COMMAND_BIT = 0x80
CONTROL_REGISTER = 0x00
TIMING_REGISTER = 0x01
DATA0_LOW = 0x0C
DATA0_HIGH = 0x0D
DATA1_LOW = 0x0E
DATA1_HIGH = 0x0F

def enable_tsl2561():
    """TSL2561 センサーを有効化"""
    bus.write_byte_data(I2C_ADDRESS, COMMAND_BIT | CONTROL_REGISTER, 0x03)  # Power ON
    bus.write_byte_data(I2C_ADDRESS, COMMAND_BIT | TIMING_REGISTER, 0x02)   # 402ms Integration Time

def read_tsl2561():
    """TSL2561 センサーから照度を取得し、辞書で返す"""
    try:
        enable_tsl2561()
        time.sleep(0.5)  # 測定待機

        # 可視光＋赤外線データの取得
        data0_low = bus.read_byte_data(I2C_ADDRESS, COMMAND_BIT | DATA0_LOW)
        data0_high = bus.read_byte_data(I2C_ADDRESS, COMMAND_BIT | DATA0_HIGH)
        data1_low = bus.read_byte_data(I2C_ADDRESS, COMMAND_BIT | DATA1_LOW)
        data1_high = bus.read_byte_data(I2C_ADDRESS, COMMAND_BIT | DATA1_HIGH)

        full_spectrum = (data0_high << 8) | data0_low
        infrared = (data1_high << 8) | data1_low
        visible = full_spectrum - infrared  # 可視光成分

        return {
            "full_spectrum": full_spectrum,
            "infrared": infrared,
            "visible": visible,
            "unit": "counts",
            "timestamp": time.strftime("%Y-%m-%d %H:%M:%S")
        }
    except Exception as e:
        return {"error": f"Failed to read TSL2561: {e}"}

def save_to_json():
    """定期的に JSON ファイルにセンサーデータを書き込む"""
    while True:
        data = read_tsl2561()
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
    data = read_tsl2561()
    return jsonify(data)

if __name__ == "__main__":
    # JSON 書き込み用のスレッドを開始
    threading.Thread(target=save_to_json, daemon=True).start()
    # Flask サーバーを実行
    app.run(host="0.0.0.0", port=5007, debug=False)
