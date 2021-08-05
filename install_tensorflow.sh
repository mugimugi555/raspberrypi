#!/usr/bin/bash

# wget https://raw.githubusercontent.com/mugimugi555/raspberrypi/main/install_tensorflow.sh && bash install_tensorflow.sh ;

# for raspberry pi 64 bit and python 3.7

echo "=========================================";
echo "setup tensorflow 2.5 for python 3.7 cpu arm 64bit";
echo "if you want other arch , please visit here";
echo "https://github.com/PINTO0309/Tensorflow-bin";
echo "=========================================";

# todo check arch

# todo check python3 version

cd ;
pip cache purge ;
sudo apt install -y libhdf5-dev ;
wget https://raw.githubusercontent.com/PINTO0309/Tensorflow-bin/main/tensorflow-2.5.0-cp37-none-linux_aarch64_numpy1195_download.sh ;
bash tensorflow-2.5.0-cp37-none-linux_aarch64_numpy1195_download.sh ;

echo "=========================================";
echo " install tensorflow 2.5 about 30 minutes";
echo "=========================================";
python3 -m pip install tensorflow-hub tensorflow-datasets tensorflow-2.5.0-cp37-none-linux_aarch64.whl ;

echo "=========================================";
echo " check install tensorflow";
echo "=========================================";
python3 -c 'import tensorflow as tf; print(tf.__version__)'  # for Python 3

echo "=========================================";
echo " if has error please input next command";
echo "=========================================";
echo "pip uninstall numpy";
echo "pip install numpy";
