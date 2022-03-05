#!/usr/bin/bash

# wget https://raw.githubusercontent.com/mugimugi555/raspberrypi/main/install_tensorflow.sh && bash install_tensorflow.sh ;

#-----------------------------------------------------------------------------------------------------------------------
# update install library
#-----------------------------------------------------------------------------------------------------------------------
sudo apt update ;
sudo apt upgrade -y ;
sudo apt install python3-pip ;

#-----------------------------------------------------------------------------------------------------------------------
# install tensorflow for 64bit python 3.9
#-----------------------------------------------------------------------------------------------------------------------
cd ;
wget https://github.com/PINTO0309/Tensorflow-bin/releases/download/v2.8.0/tensorflow-2.8.0-cp39-none-linux_aarch64.whl ;
pip cache purge ;
python3 -m pip install tensorflow-hub tensorflow-datasets tensorflow-2.8.0-cp39-none-linux_aarch64.whl ;

#-----------------------------------------------------------------------------------------------------------------------
# pip upgrade
#-----------------------------------------------------------------------------------------------------------------------
pip install numpy --upgrade ;

#-----------------------------------------------------------------------------------------------------------------------
# finished check
#-----------------------------------------------------------------------------------------------------------------------
python3 -c 'import tensorflow as tf; print(tf.__version__)' ;
