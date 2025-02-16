#!/usr/bin/bash

# wget https://raw.githubusercontent.com/mugimugi555/raspberrypi/main/install_docker.sh && bash install_docker.sh ;

#-----------------------------------------------------------------------------------------------------------------------
# update
#-----------------------------------------------------------------------------------------------------------------------
sudo apt update ;
sudo apt upgrade ;

#-----------------------------------------------------------------------------------------------------------------------
# install docker
#-----------------------------------------------------------------------------------------------------------------------
curl -fsSL get.docker.com -o get-docker.sh ;
sh get-docker.sh ;
sudo usermod -aG docker $(whoami) ;
docker version ;

#-----------------------------------------------------------------------------------------------------------------------
# install docker compose
#-----------------------------------------------------------------------------------------------------------------------
sudo apt update ;
sudo apt install -y python3 python3-pip ;
pip3 install docker-compose ;
sudo systemctl restart docker ;
source .profile ;
docker-compose version ;
