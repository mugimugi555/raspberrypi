#!/usr/bin/bash

# wget https://raw.githubusercontent.com/mugimugi555/raspberrypi/main/install_gpio.sh && bash install_gpio.sh ;

#-----------------------------------------------------------------------------------------------------------------------
# install gpio command
#-----------------------------------------------------------------------------------------------------------------------
cd ;
wget https://lion.drogon.net/wiringpi-2.50-1.deb ;
sudo dpkg -i wiringpi-2.50-1.deb ;

#-----------------------------------------------------------------------------------------------------------------------
# check all gpio
#-----------------------------------------------------------------------------------------------------------------------
gpio readall ;

#-----------------------------------------------------------------------------------------------------------------------
# clear all setting
#-----------------------------------------------------------------------------------------------------------------------
gpio unexportall ;
gpio reset ;

#i2cdeetect -y 1
