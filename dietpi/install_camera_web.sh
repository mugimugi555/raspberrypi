#!/usr/bin/bash

# wget https://raw.githubusercontent.com/mugimugi555/raspberrypi/main/dietpi/install_camera_web.sh && bash install_camera_web.sh ;

#-----------------------------------------------------------------------------------------------------------------------
# install mjpg-streamer 
#-----------------------------------------------------------------------------------------------------------------------

sudo dietpi-config
# enable camera DietPi-Config/Display Options/

# install mjpg-stream by number
# https://raw.githubusercontent.com/MichaIng/DietPi/dev/dietpi/dietpi-software
dietpi-software install 137 ; # mjpg-stream

#-----------------------------------------------------------------------------------------------------------------------
# setting for camera v1.3
#-----------------------------------------------------------------------------------------------------------------------
# nano /etc/systemd/system/mjpg-streamer.service
# replace input_raspicam.so -> input_uvc.so

#-----------------------------------------------------------------------------------------------------------------------
# finish
#-----------------------------------------------------------------------------------------------------------------------
LOCAL_IPADDRESS=`hostname -I | awk -F" " '{print $1}'` ;
echo "======================================" ;
echo "visit =>" ;
echo "http://$LOCAL_IPADDRESS:8082/?action=stream" ;
echo "======================================" ;
