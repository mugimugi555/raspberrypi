#!/usr/bin/bash

# wget https://raw.githubusercontent.com/mugimugi555/raspberrypi/main/install_opencv.sh && bash install_opencv.sh ;

#-----------------------------------------------------------------------------------------------------------------------
# install opencv by pip3
#-----------------------------------------------------------------------------------------------------------------------
sudo apt update ;
sudo apt upgrade -y ;
sudo apt install -y python3-pip ;
pip3 install opencv-python ;
pip3 install opencv-contrib-python ;
pip3 install numpy matplotlib ;

#-----------------------------------------------------------------------------------------------------------------------
# finish
#-----------------------------------------------------------------------------------------------------------------------
python3 -c 'import cv2; print(cv2.__version__)' ;

# install manal
# https://qengineering.eu/install-opencv-4.5-on-raspberry-64-os.html
