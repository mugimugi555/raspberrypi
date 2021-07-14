#!/usr/bin/bash

#

sudo apt update ;
sudo apt install -y snapd ;
sudo snap install core ;
sudo snap install remmina ;

# sudo snap connect remmina:audio-record :audio-record ;
# sudo snap connect remmina:avahi-observe :avahi-observe ;
# sudo snap connect remmina:cups-control :cups-control ;
# sudo snap connect remmina:mount-observe :mount-observe ;
# sudo snap connect remmina:password-manager-service :password-manager-service ;

sudo reboot now ;
