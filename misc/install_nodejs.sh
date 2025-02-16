#!/usr/bin/bash

# wget https://raw.githubusercontent.com/mugimugi555/raspberrypi/main/install_nodejs.sh && bash install_nodejs.sh ;

#-----------------------------------------------------------------------------------------------------------------------
#
#-----------------------------------------------------------------------------------------------------------------------
sudo apt install -y nodejs npm ;
sudo npm install n -g ;
sudo n stable ;
sudo apt purge -y nodejs npm ;

sudo npm install -g yarn ;
sudo apt autoremove -y ;

node -v ;
npm  -v ;
yarn -v ;
