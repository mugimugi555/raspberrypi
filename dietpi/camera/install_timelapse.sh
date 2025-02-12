#!/bin/bash

# fswebcam のインストール
echo "Installing fswebcam..."
sudo apt update
sudo apt install -y fswebcam

# 撮影スクリプトを作成
echo "Creating timelapse capture script..."
cat <<EOF | sudo tee /home/dietpi/timelapse.sh
#!/bin/bash
SAVE_DIR=/home/dietpi/timelapse
mkdir -p \$SAVE_DIR
INTERVAL=10

while true; do
    TIMESTAMP=\$(date +"%Y%m%d_%H%M%S")
    fswebcam -r 1280x720 --no-banner \$SAVE_DIR/\$TIMESTAMP.jpg
    echo "Captured: \$TIMESTAMP.jpg"
    sleep \$INTERVAL
done
EOF

# スクリプトに実行権限を付与
sudo chmod +x /home/dietpi/timelapse.sh

# systemd サービスの作成
echo "Creating Timelapse systemd service..."
cat <<EOF | sudo tee /etc/systemd/system/timelapse.service
[Unit]
Description=Timelapse Capture Service
After=network.target

[Service]
ExecStart=/home/dietpi/timelapse.sh
Restart=always
User=dietpi

[Install]
WantedBy=multi-user.target
EOF

# サービスの有効化 & スタート
echo "Enabling and starting Timelapse service..."
sudo systemctl enable timelapse
sudo systemctl start timelapse

echo "Timelapse setup completed!"
echo "Captured images will be saved in: /home/dietpi/timelapse/"
