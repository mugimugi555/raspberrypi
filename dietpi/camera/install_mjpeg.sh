#!/bin/bash

# MJPEG-Streamer のインストール
echo "Installing MJPEG-Streamer..."
dietpi-software install 171

# 必要なディレクトリ作成
mkdir -p /usr/local/share/mjpg-streamer/www

# systemd サービスの作成
echo "Creating MJPEG-Streamer systemd service..."
cat <<EOF | sudo tee /etc/systemd/system/mjpg-streamer.service
[Unit]
Description=MJPG-Streamer Service
After=network.target

[Service]
ExecStart=/usr/local/bin/mjpg_streamer -i "input_uvc.so -f 30 -r 640x480" -o "output_http.so -w /usr/local/share/mjpg-streamer/www"
Restart=always
User=root

[Install]
WantedBy=multi-user.target
EOF

# サービスの有効化 & スタート
echo "Enabling and starting MJPEG-Streamer service..."
sudo systemctl enable mjpg-streamer
sudo systemctl start mjpg-streamer

echo "MJPEG-Streamer setup completed!"
echo "Access the stream at: http://$(hostname -I | awk '{print $1}'):8080/?action=stream"
