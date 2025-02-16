#!/usr/bin/bash

# wget https://raw.githubusercontent.com/mugimugi555/raspberrypi/main/install_docker_tensorflow_opencv.sh && bash install_docker_tensorflow_opencv.sh ;

#-----------------------------------------------------------------------------------------------------------------------
# install docker
#-----------------------------------------------------------------------------------------------------------------------
if ! [ -x "$(command -v docker-compose)" ]; then
  wget https://raw.githubusercontent.com/mugimugi555/raspberrypi/main/install_docker.sh ;
  bash install_docker.sh ;
fi

#-----------------------------------------------------------------------------------------------------------------------
# git clone
#-----------------------------------------------------------------------------------------------------------------------
cd ;
git clone https://github.com/armindocachada/raspberrypi-docker-tensorflow-opencv ;
cd raspberrypi-docker-tensorflow-opencv ;

#-----------------------------------------------------------------------------------------------------------------------
# setting display
#-----------------------------------------------------------------------------------------------------------------------
xhost +si:localuser:$USER ;
xhost +local:docker ;
export DISPLAY=$DISPLAY ;
docker-compose up ;

#-----------------------------------------------------------------------------------------------------------------------
# test program
#-----------------------------------------------------------------------------------------------------------------------
docker exec -it camera bash -c "python3 /app/object_detection_camera.py" ;
