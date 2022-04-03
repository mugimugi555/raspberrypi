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

#-----------------------------------------------------------------------------------------------------------------------
# https://zenn.dev/karaage0703/articles/3d3d443244da2c
#-----------------------------------------------------------------------------------------------------------------------
# sudo apt-get install -y libhdf5-dev libc-ares-dev libeigen3-dev gcc gfortran libgfortran5 \
#                           libatlas3-base libatlas-base-dev libopenblas-dev libopenblas-base libblas-dev \
#                           liblapack-dev cython3 libatlas-base-dev openmpi-bin libopenmpi-dev python3-dev ;
# sudo pip3 install pip --upgrade ;
# sudo pip3 install keras_applications==1.0.8 --no-deps ;
# sudo pip3 install keras_preprocessing==1.1.0 --no-deps ;
# sudo pip3 install numpy==1.22.1 ;
# sudo pip3 install h5py==3.1.0 ;
# sudo pip3 install pybind11 ;
# pip3 install -U --user six wheel mock ;
# wget "https://raw.githubusercontent.com/PINTO0309/Tensorflow-bin/main/tensorflow-2.8.0-cp39-none-linux_aarch64_numpy1221_download.sh" ;
# sudo chmod +x tensorflow-2.8.0-cp39-none-linux_aarch64_numpy1221_download.sh ;
# ./tensorflow-2.8.0-cp39-none-linux_aarch64_numpy1221_download.sh ;
# sudo pip3 uninstall tensorflow ;
# sudo -H pip3 install tensorflow-2.8.0-cp39-none-linux_aarch64.whl ;
