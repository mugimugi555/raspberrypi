#!/usr/bin/bash

# wget https://raw.githubusercontent.com/mugimugi555/raspberrypi/main/lite/install_opencv.sh && bash install_opencv.sh ;

#-----------------------------------------------------------------------------------------------------------------------
# install opencv by pip3
#-----------------------------------------------------------------------------------------------------------------------
sudo apt update ;
sudo apt upgrade -y ;
sudo apt install -y python3-pip ;
sudo apt install -y libatlas-base-dev ;
sudo apt install -y libopenjp2-7 ;
sudo apt install -y libavcodec-extra58 ;
sudo apt install -y libavformat58 ;
sudo apt install -y libswscale5 ;

# sudo apt install -y libhdf5-103 ;
# sudo apt install -y libharfbuzz0b ;
# sudo apt install -y liblapack3 ;
# sudo apt install -y libwebp6 ;
# sudo apt install -y libtiff5 ;
# sudo apt install -y libjasper1 ;
# sudo apt install -y libilmbase23 ;
# sudo apt install -y libopenexr23 ;

pip3 install opencv-python-headless ;
pip3 install opencv-contrib-python-headless ;
pip3 install numpy matplotlib ;

#-----------------------------------------------------------------------------------------------------------------------
# finish
#-----------------------------------------------------------------------------------------------------------------------
python3 -c 'import cv2; print(cv2.__version__)' ;
