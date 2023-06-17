#!/bin/bash

# wget https://raw.githubusercontent.com/mugimugi555/raspberrypi/main/install_gnome.sh && bash install_gnome.sh ;

#-----------------------------------------------------------------------------------------------------------------------
# download script
#-----------------------------------------------------------------------------------------------------------------------

wget https://github.com/TerraGitHuB/gnomeforpi/archive/refs/heads/stable.zip ;
unzip stable.zip ;
cd gnomeforpi-stable ;

#-----------------------------------------------------------------------------------------------------------------------
# install gnome
#-----------------------------------------------------------------------------------------------------------------------
sudo ./gnomeforpi-install ;
# - or - 
#sudo gnomeforpi-install --lite

#-----------------------------------------------------------------------------------------------------------------------
# then rebooted , update session manager
#-----------------------------------------------------------------------------------------------------------------------
# select number 1 ( gnome )
sudo update-alternatives --config x-session-manager ;
