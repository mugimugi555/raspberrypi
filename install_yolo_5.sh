#!/usr/bin/bash

#
sudo apt update ;
sudo apt install -y git python3-pip ;

#
cd ;
git clone https://github.com/ultralytics/yolov5.git ;
cd yolov5 ;
pip install -U -r requirements.txt ;
