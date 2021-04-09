#!/usr/bin/bash

#

# =================================================
#
# =================================================
sudo apt update ;
sudo apt upgrade ;

# =================================================
#
# =================================================
curl -fsSL get.docker.com -o get-docker.sh && sh get-docker.sh ;
sudo usermod -aG docker $(whoami) ;
su - pi ;
docker version ;

# =================================================
#
# =================================================
sudo apt update ;
sudo apt install python3 python3-pip ;
pip3 install docker-compose ;
docker-compose version ;

# =================================================
#
# =================================================
cd ;
git clone https://github.com/armindocachada/raspberrypi-docker-tensorflow-opencv ;
cd raspberrypi-docker-tensorflow-opencv

# =================================================
#
# =================================================
xhost +si:localuser:$USER
xhost +local:docker
export DISPLAY=$DISPLAY
docker-compose up

# =================================================
#
# =================================================
#docker exec -it camera bash
#cd /app/ 
#python3 example3.py
docker exec -it camera bash -c "python3 /app/example3.py"
