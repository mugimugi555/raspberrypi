# Raspberry Pi 向けセンサー一覧とサンプルコード

このプロジェクトでは、Raspberry Pi に接続可能なセンサーの一覧と、それぞれのサンプルプログラムを提供します。対象のセンサーは、GPIO（デジタル）または I2C に対応したものです。

## **対応センサーとプログラムファイル**

| **センサー** | **型番** | **接続方法** | **I2C アドレス** | **ファイル** |
|--------------|-------------|----------------|--------------|--------------------|
| 温湿度センサー | DHT11 | GPIO | - | `dht11.py` |
| 温湿度センサー | DHT22 (AM2302) | GPIO | - | `dht22.py` |
| 温湿度センサー | SHT31 | I2C | `0x44` または `0x45` | `sht31.py` |
| 温湿度＋気圧センサー | BME280 | I2C | `0x76` または `0x77` | `bme280.py` |
| 気圧センサー | BMP280 | I2C | `0x76` または `0x77` | `bmp280.py` |
| CO2・空気品質センサー | CCS811 | I2C | `0x5A` または `0x5B` | `ccs811.py` |
| 照度センサー | BH1750 | I2C | `0x23` または `0x5C` | `bh1750.py` |
| 照度＋赤外線センサー | TSL2561 | I2C | `0x29`, `0x39`, または `0x49` | `tsl2561.py` |

## **環境構築**

### **共通で必要なパッケージのインストール**
以下のコマンドで、共通で必要なライブラリをインストールしてください。

```bash
pip3 install flask smbus2
```

### **センサーごとの追加ライブラリ**

| **センサー** | **必要な pip ライブラリ** |
|--------------|-----------------------------------------------|
| DHT11, DHT22 | `pip3 install RPi.GPIO Adafruit_DHT` |
| SHT31 | `pip3 install adafruit-circuitpython-sht31d` |
| BME280 | `pip3 install adafruit-circuitpython-bme280` |
| BMP280 | `pip3 install adafruit-circuitpython-bmp280` |
| CCS811 | `pip3 install adafruit-circuitpython-ccs811` |
| BH1750 | `pip3 install adafruit-circuitpython-bh1750` |
| TSL2561 | `pip3 install adafruit-circuitpython-tsl2561` |

### **I2C の有効化**
I2C センサーを使用する場合、Raspberry Pi の I2C を有効にする必要があります。

```bash
sudo raspi-config
```
**Interfacing Options → I2C → 有効化**

### **I2C デバイスのスキャン**
接続されている I2C デバイスのアドレスを確認するには、以下のコマンドを実行してください。

```bash
sudo apt install -y i2c-tools
sudo i2cdetect -y 1
```

**出力例:**
```
     0  1  2  3  4  5  6  7  8  9  A  B  C  D  E  F
00:          -- -- -- -- -- -- -- -- -- -- -- -- -- 
10: -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
20: -- -- -- -- -- -- -- -- -- -- 23 -- -- -- -- --
30: -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
40: -- -- 44 -- -- -- -- -- -- -- -- -- -- -- -- --
50: -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
60: -- -- -- -- -- -- -- -- -- -- -- 76 -- -- -- --
70: -- -- -- -- -- -- -- --
```

この例では:
- `0x23` → **BH1750（照度センサー）**
- `0x44` → **SHT31（温湿度センサー）**
- `0x76` → **BME280 または BMP280（温湿度＋気圧センサー）**
- 
## **サンプルプログラムの実行方法**
各センサーのプログラムは、以下のように実行できます。

```bash
python3 センサーファイル名.py
```

例：BME280 のサンプルを実行
```bash
python3 bme280.py
```

## **センサーのシステムサービス化**

各センサーの Flask Web サーバーを `systemd` によりサービスとして登録し、自動起動させることができます。

### **サービスの登録方法**
以下のスクリプトを実行すると、指定したセンサースクリプトを `systemd` サービスとして登録し、自動起動するようになります。

```bash
bash install_sensor_service.sh <センサースクリプト名>
```

例：
```bash
bash install_sensor_service.sh /home/pi/sensors/dht11.py
```
または
```bash
bash install_sensor_service.sh ~/custom_path/bme280.py
```

### **登録されたサービスの管理**

| **コマンド** | **説明** |
|-------------|---------------------------------|
| `sudo systemctl status sensor_<センサー名>_server` | サービスの状態を確認 |
| `sudo systemctl stop sensor_<センサー名>_server` | サービスを停止 |
| `sudo systemctl start sensor_<センサー名>_server` | サービスを開始 |
| `sudo systemctl restart sensor_<センサー名>_server` | サービスを再起動 |
| `sudo systemctl disable sensor_<センサー名>_server` | 自動起動を無効化 |
| `sudo systemctl enable sensor_<センサー名>_server` | 自動起動を有効化 |

## **ライセンス**
MIT License

