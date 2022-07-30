#!/usr/bin/bash

# wget https://raw.githubusercontent.com/mugimugi555/raspberrypi/main/dietpi/install_camera_web.sh && bash install_camera_web.sh ;

#-----------------------------------------------------------------------------------------------------------------------
# enable legacy camera ( 0 is on )
#-----------------------------------------------------------------------------------------------------------------------

sudo dietpi-config
# enable camera DietPi-Config/Display Options/

# https://raw.githubusercontent.com/MichaIng/DietPi/dev/dietpi/dietpi-software
dietpi-software install 137 ; # mjpg-stream

#echo 'camera_auto_detect=1' | sudo tee -a /boot/config.txt ;
#sudo apt install -y libcamera-apps-lite libraspberrypi-dev ;

#-----------------------------------------------------------------------------------------------------------------------
# finish
#-----------------------------------------------------------------------------------------------------------------------
LOCAL_IPADDRESS=`hostname -I | awk -F" " '{print $1}'` ;
echo "======================================" ;
echo "visit =>" ;
echo "http://$LOCAL_IPADDRESS:8022/?action=stream" ;
echo "======================================" ;
