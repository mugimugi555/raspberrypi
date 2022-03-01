#!/usr/bin/bash

#

#=======================================================================================================================
# install OpenVINO 2021.4 for python3.9
#=======================================================================================================================
sudo apt install -y git-lfs cython3 ;
sudo apt install -y \
  build-essential \
  curl \
  wget \
  libssl-dev \
  ca-certificates \
  git \
  libboost-regex-dev \
  libgtk2.0-dev \
  pkg-config \
  unzip \
  automake \
  libtool \
  autoconf \
  libcairo2-dev \
  libpango1.0-dev \
  libglib2.0-dev \
  libgtk2.0-dev \
  libswscale-dev \
  libavcodec-dev \
  libavformat-dev \
  libgstreamer1.0-0 \
  gstreamer1.0-plugins-base \
  libusb-1.0-0-dev \
  libopenblas-dev ;
git clone -b 2021.4 https://github.com/openvinotoolkit/openvino.git openvino-2021.4 ;
cd openvino-2021.4 ;
git submodule update --init --recursive ;
mkdir build ;
cd build ;
cmake \
    -DCMAKE_INSTALL_PREFIX=/opt/intel/openvino \
    -DCMAKE_BUILD_TYPE=Release \
    -DENABLE_SSE42=OFF \
    -DTHREADING=SEQ \
    -DENABLE_GNA=OFF \
    -DENABLE_PYTHON=ON \
    -DPYTHON_EXECUTABLE=/usr/bin/python3.9 \
    -DPYTHON_LIBRARY=/usr/lib/aarch64-linux-gnu/libpython3.9.so \
    -DPYTHON_INCLUDE_DIR=/usr/include/python3.9 \
     .. ;
make -j$(nproc) ;
sudo make install ;
source /opt/intel/openvino/bin/setupvars.sh ;
~/openvino-2021.4/scripts/install_dependencies/install_NCS_udev_rules.sh ;

#=======================================================================================================================
# install OpenVINO-OpenCV for python3.9
#=======================================================================================================================
source /opt/intel/openvino/bin/setupvars.sh ;
git clone --depth 1 -b 4.5.3-openvino https://github.com/opencv/opencv.git opencv-4.5.3-openvino ;
sudo apt install -y libtbb-dev libjpeg-dev libtiff-dev libwebp-dev ;
cd opencv-4.5.3-openvino ;
mkdir build ;
cd build ;
cmake \
    -DCMAKE_INSTALL_PREFIX=/opt/intel/openvino/opencv \
    -DCMAKE_BUILD_TYPE=Release \
    -DWITH_INF_ENGINE=ON \
    -DENABLE_CXX11=ON \
    -DWITH_TBB=ON \
    -DPYTHON_EXECUTABLE=/usr/bin/python3.9 \
    -DPYTHON_LIBRARY=/usr/lib/aarch64-linux-gnu/libpython3.9.so \
    -DPYTHON_INCLUDE_DIR=/usr/include/python3.9 \
    .. ;
make -j$(nproc) ;
sudo make install ;
