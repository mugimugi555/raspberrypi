#!/bin/bash

if [ -z "$1" ]; then
    echo "Usage: $0 <sensor_script.py>"
    exit 1
fi

SCRIPT_PATH=$(realpath "$1")
SCRIPT_NAME=$(basename "$SCRIPT_PATH")
SCRIPT_DIR=$(dirname "$SCRIPT_PATH")
SERVICE_NAME="sensor_${SCRIPT_NAME%.*}_server"
SERVICE_FILE="/etc/systemd/system/$SERVICE_NAME.service"

echo "Setting up $SCRIPT_NAME Flask Web Server as a systemd service..."

# systemd サービスファイルの作成
echo "Creating systemd service file..."
sudo bash -c "cat > $SERVICE_FILE" <<EOF
[Unit]
Description=$SCRIPT_NAME Flask Web Server
After=network.target

[Service]
ExecStart=/usr/bin/python3 $SCRIPT_PATH
WorkingDirectory=$SCRIPT_DIR
Restart=always
User=pi

[Install]
WantedBy=multi-user.target
EOF

# systemd でサービスを登録
echo "Enabling and starting the service..."
sudo systemctl daemon-reload
sudo systemctl enable $SERVICE_NAME
sudo systemctl start $SERVICE_NAME

# サービスのステータス確認
echo "Checking service status..."
sudo systemctl status $SERVICE_NAME --no-pager

echo "$SCRIPT_NAME Flask Web Server setup completed successfully!"
