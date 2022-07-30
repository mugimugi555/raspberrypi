#!/usr/bin/bash

# wget https://raw.githubusercontent.com/mugimugi555/raspberrypi/main/dietpi/install_camera_web.sh && bash install_camera_web.sh ;

#-----------------------------------------------------------------------------------------------------------------------
# enable legacy camera ( 0 is on )
#-----------------------------------------------------------------------------------------------------------------------

sudo dietpi-config ;
# enable camera DietPi-Config/Display Options/

dietpi-software install 137 ; # mjpg-stream

#echo 'camera_auto_detect=1' | sudo tee -a /boot/config.txt ;
#sudo apt install -y libcamera-apps-lite libraspberrypi-dev ;

# http://IPADDRESS:8082/?action=stream
