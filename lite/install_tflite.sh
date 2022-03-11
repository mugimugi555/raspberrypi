#!/usr/bin/bash

exit;

# wget

#-----------------------------------------------------------------------------------------------------------------------
#
#-----------------------------------------------------------------------------------------------------------------------
sudo apt update ;
sudo apt upgrade -y ;
sudo apt install -y cmake ;

#-----------------------------------------------------------------------------------------------------------------------
#
#-----------------------------------------------------------------------------------------------------------------------
cd ~ ;
git clone https://github.com/tensorflow/tensorflow.git tensorflow_src ;
mkdir tflite_build ;
cd tflite_build ;
sudo cmake ../tensorflow_src/tensorflow/lite \
    -DCMAKE_C_FLAGS="-I/usr/include/python3.9m -I/home/pi/.local/lib/python3.9/site-packages/pybind11/include" \
    -DCMAKE_CXX_FLAGS="-I/usr/include/python3.9m -I/home/pi/.local/lib/python3.9/site-packages/pybind11/include" \
    -DCMAKE_SHARED_LINKER_FLAGS='-latomic' \
    -DCMAKE_SYSTEM_NAME=Linux \
    -DCMAKE_SYSTEM_PROCESSOR=armv6 \
    -DTFLITE_ENABLE_XNNPACK=OFF ;
