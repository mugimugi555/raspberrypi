#!/bin/bash

# MJPEG-Streamer のインストール
echo "Installing MJPEG-Streamer..."
dietpi-software install 171

# 必要なディレクトリ作成
mkdir -p /usr/local/share/mjpg-streamer/www

# カメラの種類を判定
if ls /dev/video* 1> /dev/null 2>&1; then
    CAMERA_TYPE="USB"
    EXEC_CMD="/usr/local/bin/mjpg_streamer -i 'input_uvc.so -f 30 -r 640x480' -o 'output_http.so -w /usr/local/share/mjpg-streamer/www'"
else
    CAMERA_TYPE="MIPI CSI"
    EXEC_CMD="/usr/local/bin/mjpg_streamer -i 'input_raspicam.so -x 640 -y 480 -fps 30' -o 'output_http.so -w /usr/local/share/mjpg-streamer/www'"
fi

# systemd サービスの作成（カメラの種類に応じて設定）
echo "Creating MJPEG-Streamer systemd service for $CAMERA_TYPE camera..."
cat <<EOF | sudo tee /etc/systemd/system/mjpg-streamer.service
[Unit]
Description=MJPG-Streamer Service ($CAMERA_TYPE Camera)
After=network.target

[Service]
ExecStart=$EXEC_CMD
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
