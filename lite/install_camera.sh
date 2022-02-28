#!/usr/bin/bash

# wget https://raw.githubusercontent.com/mugimugi555/raspberrypi/main/lite/install_camera.sh && install_camera.sh ;

#=======================================================================================================================
# how to play stream
#=======================================================================================================================
LOCAL_IPADDRESS=`hostname -I | awk -F" " '{print $1}'` ;
echo "======================================" ;
echo "open vlc player => rtsp://$LOCAL_IPADDRESS:8554/unicast" ;
echo "======================================" ;

#=======================================================================================================================
# enable spi legacy camera
#=======================================================================================================================
cat /boot/config.txt | grep -i gpu ;
sudo raspi-config nonint do_legacy 0 ;
sudo raspi-config nonint do_camera 0 ;
cat /boot/config.txt | grep -i gpu ;
sudo echo "bcm2835-v4l2" | sudo tee -a /etc/modules ;

#=======================================================================================================================
# install h264_v4l2 rtsp server
#=======================================================================================================================
cd ;
v4l2-ctl --list-devices ;
sudo apt install -y cmake subversion liblivemedia-dev libssl-dev vlc ;
git clone https://github.com/mpromonet/h264_v4l2_rtspserver.git ;
cd h264_v4l2_rtspserver ;
sudo cmake . ;
sudo make -j$(nproc) install ;

#=======================================================================================================================
# auto start
#=======================================================================================================================

# backup
sudo cp /etc/rc.local /etc/rc.local.back ;

# write
sudo sed -i 's/exit 0//' /etc/rc.local ;
V4L2RTS=$(cat<<TEXT
v4l2rtspserver &

exit 0

TEXT
)
echo "$V4L2RTS" | sudo tee -a /etc/rc.local ;

#=======================================================================================================================
# finish
#=======================================================================================================================
sudo reboot now ;
