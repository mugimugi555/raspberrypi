#!/bin/bash

# fswebcam のインストール（USBカメラ用）
echo "Installing fswebcam..."
sudo apt update
sudo apt install -y fswebcam libcamera-apps

# 撮影スクリプトを作成（USBカメラ or MIPIカメラ対応）
echo "Creating timelapse capture script..."
cat <<EOF | sudo tee /home/dietpi/timelapse.sh
#!/bin/bash
SAVE_DIR=/home/dietpi/timelapse
mkdir -p \$SAVE_DIR
INTERVAL=10

# カメラの種類を判定（USBカメラかMIPI CSIカメラか）
if ls /dev/video* 1> /dev/null 2>&1; then
    CAMERA_TYPE="USB"
    CAPTURE_CMD="fswebcam -r 1280x720 --no-banner"
else
    CAMERA_TYPE="MIPI CSI"
    CAPTURE_CMD="libcamera-jpeg -o"
fi

echo "Using $CAMERA_TYPE camera for timelapse."

while true; do
    TIMESTAMP=\$(date +"%Y%m%d_%H%M%S")
    IMAGE_PATH="\$SAVE_DIR/\$TIMESTAMP.jpg"
    
    # 画像キャプチャを実行
    if ! \$CAPTURE_CMD \$IMAGE_PATH; then
        echo "Error: Failed to capture image with $CAMERA_TYPE camera" >> /var/log/timelapse.log
    else
        echo "Captured: \$IMAGE_PATH"
    fi

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
ExecStart=/bin/bash /home/dietpi/timelapse.sh
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
