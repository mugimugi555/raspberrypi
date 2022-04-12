#!/usr/bin/bash

# wget https://raw.githubusercontent.com/mugimugi555/raspberrypi/main/install_yolo_5.sh && bash install_yolo_5.sh ;

#
sudo apt update ;
sudo apt install -y git python3-pip ;

#
cd ;
git clone https://github.com/ultralytics/yolov5.git ;
cd yolov5 ;
pip install -U -r requirements.txt ;

#
python detect.py ;

#
# python detect.py --source 0 # webcam
#                           file.jpg
#                           file.avi
#                           dir/
#                           dir/*.jpg
#                           /dev/video0 # csi camera module not work
#                           rtsp://127.0.0.1:8554/unicast
#                           http://127.0.0.1/movie.m3u8

# streaming camera
# wget https://raw.githubusercontent.com/mugimugi555/raspberrypi/main/install_camera_rtsp.sh && bash install_camera_rtsp.sh ;
# python detect.py --source rtsp://127.0.0.1:8554/unicast ;
