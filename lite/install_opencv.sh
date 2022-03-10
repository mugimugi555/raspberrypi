#!/usr/bin/bash

# wget https://raw.githubusercontent.com/mugimugi555/raspberrypi/main/lite/install_opencv.sh && bash install_opencv.sh ;

#-----------------------------------------------------------------------------------------------------------------------
# install opencv by pip3
#-----------------------------------------------------------------------------------------------------------------------
sudo apt update ;
sudo apt upgrade -y ;
sudo apt install -y python3-pip ;
sudo apt install -y libatlas-base-dev ;
pip3 install opencv-python-headless ;
#pip3 install opencv-contrib-python-headless ;
pip3 install numpy matplotlib ;

#-----------------------------------------------------------------------------------------------------------------------
# finish
#-----------------------------------------------------------------------------------------------------------------------
python3 -c 'import cv2; print(cv2.__version__)' ;
