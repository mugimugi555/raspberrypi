#!/usr/bin/bash

# wget https://raw.githubusercontent.com/mugimugi555/raspberrypi/main/install_vnc_client.sh && bash install_vnc_client.sh ;

#-----------------------------------------------------------------------------------------------------------------------
# update
#-----------------------------------------------------------------------------------------------------------------------
sudo apt update ;

#-----------------------------------------------------------------------------------------------------------------------
# install vnc by snap
#-----------------------------------------------------------------------------------------------------------------------
sudo apt install -y snapd ;
sudo snap install core ;
sudo snap install remmina ;

#-----------------------------------------------------------------------------------------------------------------------
# audio config
#-----------------------------------------------------------------------------------------------------------------------
# sudo snap connect remmina:audio-record :audio-record ;
# sudo snap connect remmina:avahi-observe :avahi-observe ;
# sudo snap connect remmina:cups-control :cups-control ;
# sudo snap connect remmina:mount-observe :mount-observe ;
# sudo snap connect remmina:password-manager-service :password-manager-service ;

#-----------------------------------------------------------------------------------------------------------------------
# finish
#-----------------------------------------------------------------------------------------------------------------------
sudo reboot now ;
