#!/bin/bash

echo "Setting up DHT11 Flask Web Server as a systemd service..."

# サービス名とスクリプトパスの設定
SCRIPT_PATH="/home/pi/sensors/dht11_server.py"
SERVICE_FILE="/etc/systemd/system/sensor_dht11_server.service"

# sensors フォルダの作成（存在しない場合）
if [ ! -d "/home/pi/sensors" ]; then
    echo "Creating /home/pi/sensors directory..."
    mkdir -p /home/pi/sensors
fi

# Flask と必要なライブラリのインストール
echo "Installing required Python libraries..."
pip3 install flask Adafruit_DHT

# systemd サービスファイルの作成
echo "Creating systemd service file..."
sudo bash -c "cat > $SERVICE_FILE" <<EOF
[Unit]
Description=DHT11 Flask Web Server
After=network.target

[Service]
ExecStart=/usr/bin/python3 $SCRIPT_PATH
WorkingDirectory=/home/pi/sensors
Restart=always
User=pi

[Install]
WantedBy=multi-user.target
EOF

# systemd でサービスを登録
echo "Enabling and starting the service..."
sudo systemctl daemon-reload
sudo systemctl enable sensor_dht11_server
sudo systemctl start sensor_dht11_server

# サービスのステータス確認
echo "Checking service status..."
sudo systemctl status sensor_dht11_server --no-pager

echo "DHT11 Flask Web Server setup completed successfully!"
