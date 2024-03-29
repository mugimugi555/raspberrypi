#!/usr/bin/bash

# wget https://raw.githubusercontent.com/mugimugi555/raspberrypi/main/lite/install_tensorflow_lite.sh && bash install_tensorflow_lite.sh ;

#-----------------------------------------------------------------------------------------------------------------------
#
#-----------------------------------------------------------------------------------------------------------------------
sudo apt update ;
sudo apt upgrade -y ;
sudo apt install -y python3-pip ;

#-----------------------------------------------------------------------------------------------------------------------
# for armv6 and python3.9 raspberry pi zero and 1
#-----------------------------------------------------------------------------------------------------------------------
uname -m ;
python3 --version ;
pip3 install https://github.com/mugimugi555/raspberrypi/raw/main/lite/tensorflow/tflite_runtime-2.8.0-cp39-cp39-linux_armv6l.whl ;

#-----------------------------------------------------------------------------------------------------------------------
#
#-----------------------------------------------------------------------------------------------------------------------
python3 -c 'import tflite_runtime as tf; print(tf.__version__)' ;
