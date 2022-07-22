#!/usr/bin/bash

# wget https://raw.githubusercontent.com/mugimugi555/raspberrypi/main/lite/install_camera_web.sh && bash install_camera_web.sh ;

#-----------------------------------------------------------------------------------------------------------------------
# enable legacy camera ( 0 is on )
#-----------------------------------------------------------------------------------------------------------------------
sudo raspi-config nonint do_camera 0 ;
sudo raspi-config nonint do_legacy 0 ;

# for diet pi
#
# sudo dietpi-config ;
# enable camera DietPi-Config/Display Options/
# echo 'camera_auto_detect=1' | sudo tee -a /boot/config.txt ;
# sudo apt install -y libcamera-apps-lite libraspberrypi-dev ;

#-----------------------------------------------------------------------------------------------------------------------
# install library
#-----------------------------------------------------------------------------------------------------------------------
sudo apt install -y gcc g++ cmake make libjpeg-dev git ;

#-----------------------------------------------------------------------------------------------------------------------
# install mjpg-streamer
#-----------------------------------------------------------------------------------------------------------------------
cd ;
git clone https://github.com/jacksonliam/mjpg-streamer.git ;
cd mjpg-streamer ;
cd mjpg-streamer-experimental ;
make -j$(nproc) ;
sudo make install ;

#-----------------------------------------------------------------------------------------------------------------------
# test start app
#-----------------------------------------------------------------------------------------------------------------------
#export LD_LIBRARY_PATH=. ;
#./mjpg_streamer -o "output_http.so -w ./www" -i "input_raspicam.so" ;

#-----------------------------------------------------------------------------------------------------------------------
# add service
#-----------------------------------------------------------------------------------------------------------------------
MJPG_STREAMER=$(cat<<TEXT
[Unit]
Description=mjpgstreamer web streaming server
After=network.target
[Service]
ExecStartPre=
ExecStart=/usr/local/bin/mjpg_streamer -o "output_http.so -w /usr/local/share/mjpg-streamer/www" -i "input_raspicam.so"
Type=simple
User=root
Group=video
Restart=always
[Install]
WantedBy=multi-user.target
TEXT
)
echo "$MJPG_STREAMER" | sudo tee /etc/systemd/system/mjpgstreamer.service ;
sudo systemctl enable mjpgstreamer.service ;
sudo systemctl daemon-reload ;
sudo systemctl start mjpgstreamer.service ;
#sudo systemctl stop mjpgstreamer.service ;
#sudo systemctl disable mjpgstreamer.service ;

#-----------------------------------------------------------------------------------------------------------------------
# finish
#-----------------------------------------------------------------------------------------------------------------------
LOCAL_IPADDRESS=`hostname -I | awk -F" " '{print $1}'` ;
echo "======================================" ;
echo "visit =>" ;
echo "http://$LOCAL_IPADDRESS:8080" ;
echo "======================================" ;

#-----------------------------------------------------------------------------------------------------------------------
# option
# http://make.bcde.jp/raspberry-pi/usb%E3%82%AB%E3%83%A1%E3%83%A9%E3%81%A7%E7%9B%A3%E8%A6%96%E3%82%AB%E3%83%A1%E3%83%A9/#MJPG-streamer
# https://github.com/jacksonliam/mjpg-streamer
#-----------------------------------------------------------------------------------------------------------------------
#PORT="8080" #ポート番号
#ID="user" #ID
#PW="passward" #パスワード
#SIZE="320x240" #画面サイズ
#FRAMERATE="2" #フレームレート
#export LD_LIBRARY_PATH=/usr/local/lib
#./mjpg_streamer \
#    -i "input_uvc.so -f $FRAMERATE -r $SIZE -d /dev/video0 -y -n" \
#    -o "output_http.so -w /usr/local/www -p $PORT -c $ID:$PW"
