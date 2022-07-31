#!/usr/bin/bash

# wget https://raw.githubusercontent.com/mugimugi555/raspberrypi/main/dietpi/install_camera_web.sh && bash install_camera_web.sh ;

#-----------------------------------------------------------------------------------------------------------------------
# install mjpg-streamer 
#-----------------------------------------------------------------------------------------------------------------------

sudo dietpi-config
# enable camera DietPi-Config/Display Options/

dietpi-software install 137 ; # mjpg-stream

#-----------------------------------------------------------------------------------------------------------------------
# setting for camera v1.3
#-----------------------------------------------------------------------------------------------------------------------
# nano /etc/systemd/system/mjpg-streamer.service
# replace lib_raspicam.so -> lib_uvc.so

#-----------------------------------------------------------------------------------------------------------------------
# finish
#-----------------------------------------------------------------------------------------------------------------------
LOCAL_IPADDRESS=`hostname -I | awk -F" " '{print $1}'` ;
echo "======================================" ;
echo "visit =>" ;
echo "http://$LOCAL_IPADDRESS:8022/?action=stream" ;
echo "======================================" ;
