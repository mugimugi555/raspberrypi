# Raspberry Pi 向けセンサー一覧とサンプルコード

このプロジェクトでは、Raspberry Pi に接続可能なセンサーの一覧と、それぞれのサンプルプログラムを提供します。対象のセンサーは、GPIO（デジタル）または I2C に対応したものです。

## **対応センサーとプログラムファイル**

| **センサー種別** | **センサー名** | **インターフェース** | **サンプルコードファイル** |
|--------------|-------------|----------------|--------------------|
| 温湿度センサー | DHT11 | GPIO | `dht11.py` |
| 温湿度センサー | DHT22 (AM2302) | GPIO | `dht22.py` |
| 温湿度センサー | SHT31 | I2C | `sht31.py` |
| 温湿度＋気圧センサー | BME280 | I2C | `bme280.py` |
| 気圧センサー | BMP280 | I2C | `bmp280.py` |
| CO2・空気品質センサー | CCS811 | I2C | `ccs811.py` |
| 照度センサー | BH1750 | I2C | `bh1750.py` |
| 照度＋赤外線センサー | TSL2561 | I2C | `tsl2561.py` |

## **環境構築**

### **必要なパッケージのインストール**
以下のコマンドで、Python の必要なライブラリをインストールしてください。

```bash
sudo apt update && sudo apt install -y python3 python3-pip
pip3 install RPi.GPIO smbus2 Adafruit_DHT adafruit-circuitpython-bme280 adafruit-circuitpython-ccs811 adafruit-circuitpython-bh1750 adafruit-circuitpython-tsl2561
```

### **I2C の有効化**
I2C センサーを使用する場合、Raspberry Pi の I2C を有効にする必要があります。

```bash
sudo raspi-config
```
**Interfacing Options → I2C → 有効化**

## **サンプルプログラムの実行方法**
各センサーのプログラムは、以下のように実行できます。

```bash
python3 センサーファイル名.py
```

例：BME280 のサンプルを実行
```bash
python3 bme280.py
```

## **ライセンス**
MIT License
