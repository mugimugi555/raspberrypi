#!/bin/bash

# wget https://raw.githubusercontent.com/mugimugi555/raspberrypi/main/install_vnc.sh && bash install_vnc.sh ;

sudo echo ;

#-----------------------------------------------------------------------------------------------------------------------
# install vnc server for ubuntu remmina
#-----------------------------------------------------------------------------------------------------------------------

sudo raspi-config nonint do_vnc 0 ;
sudo vncpasswd -service ;
echo 'Authentication=VncAuth' | sudo tee -a /root/.vnc/config.d/vncserver-x11 ;
sudo systemctl restart vncserver-x11-serviced ;
