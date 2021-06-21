#!/usr/bin/bash

# wget https://raw.githubusercontent.com/mugimugi555/raspberrypi/main/install_camera_rtsp.sh && bash install_camera_rtsp.sh ;

# echo "play vlc player";
# echo "rtsp://192.168.0.xxx:8554/unicast" ;
# echo "rtsp://raspberry.local:8554/unicast" ;

# enable spi camera
cat /boot/config.txt | grep -i gpu ;
sudo raspi-config nonint do_camera 0 ;
cat /boot/config.txt | grep -i gpu ;
sudo echo "bcm2835-v4l2" | sudo tee -a /etc/modules ;

# insatll h264_v4l2_rtspserver
v4l2-ctl --list-devices ;
cd ;
sudo apt install -y cmake subversion liblivemedia-dev ;
git clone https://github.com/mpromonet/h264_v4l2_rtspserver.git ;
cd h264_v4l2_rtspserver ;
sudo cmake . ;
sudo make install ;
ls -la /usr/local/bin/v4l2rtspserver ;
# sudo v4l2rtspserver ;

# auto start
sudo cp /etc/rc.local /etc/rc.local.back ; 
sudo sed -i 's/exit 0//' /etc/rc.local ;

V4L2RTS=$(cat<<TEXT
v4l2rtspserver &

exit 0

TEXT
)
sudo echo "$V4L2RTS" | sudo tee -a /etc/rc.local

sudo reboot now ;
