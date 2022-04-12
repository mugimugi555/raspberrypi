#!/usr/bin/bash

# wget https://raw.githubusercontent.com/mugimugi555/raspberrypi/main/lite/install_camera_rtsp.sh && bash install_camera_rtsp.sh ;

#-----------------------------------------------------------------------------------------------------------------------
# enable spi legacy camera
#-----------------------------------------------------------------------------------------------------------------------
cat /boot/config.txt | grep -i gpu ;
sudo raspi-config nonint do_legacy 0 ;
sudo raspi-config nonint do_camera 0 ;
cat /boot/config.txt | grep -i gpu ;
sudo echo "bcm2835-v4l2" | sudo tee -a /etc/modules ;

#-----------------------------------------------------------------------------------------------------------------------
# install h264_v4l2 rtsp server
#-----------------------------------------------------------------------------------------------------------------------
cd ;
v4l2-ctl --list-devices ;
sudo apt install -y cmake subversion liblivemedia-dev libssl-dev ;
git clone https://github.com/mpromonet/h264_v4l2_rtspserver.git ;
cd h264_v4l2_rtspserver ;
sudo cmake . ;
sudo make -j$(nproc) install ;

#-----------------------------------------------------------------------------------------------------------------------
# add service
#-----------------------------------------------------------------------------------------------------------------------
V4L2SERVICE=$(cat<<TEXT
[Unit]
Description=v4l2rtspserver rtsp streaming server
After=network.target
[Service]
#ExecStartPre=/usr/bin/v4l2-ctl --set-ctrl horizontal_flip=0,vertical_flip=0,video_bitrate=10000000,brightness=50,white_balance_auto_preset=7,saturation=30
ExecStart=/usr/local/bin/v4l2rtspserver -W 1280 -H 960 -F 7
Type=simple
User=root
Group=video
Restart=always
[Install]
WantedBy=multi-user.target
TEXT
)
echo "$V4L2SERVICE" | sudo tee /etc/systemd/system/v4l2rtspserver.service ;
sudo systemctl enable v4l2rtspserver.service ;
sudo systemctl daemon-reload ;
sudo systemctl start v4l2rtspserver.service ;
#sudo systemctl stop v4l2rtspserver.service ;
#sudo systemctl disable v4l2rtspserver.service ;

#-----------------------------------------------------------------------------------------------------------------------
# finish
#-----------------------------------------------------------------------------------------------------------------------
LOCAL_IPADDRESS=`hostname -I | awk -F" " '{print $1}'` ;
echo "======================================" ;
echo "open vlc player => rtsp://$LOCAL_IPADDRESS:8554/unicast" ;
echo "======================================" ;
