import smbus2
import time

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

# I2C アドレス（例: BME280）
I2C_ADDR = 0x76  # 一般的な BME280 の I2C アドレス

# I2C バスの初期化
bus = smbus2.SMBus(1)

def read_sensor():
    """I2C センサー（例: BME280）からデータを取得"""
    try:
        data = bus.read_i2c_block_data(I2C_ADDR, 0xD0, 1)  # デバイス ID 読み取り
        print(f"Sensor ID: {data[0]}")
    except Exception as e:
        print(f"Failed to read sensor: {e}")

if __name__ == "__main__":
    try:
        while True:
            read_sensor()
            time.sleep(2)  # 2秒ごとに測定
    except KeyboardInterrupt:
        print("\nScript terminated by user")
