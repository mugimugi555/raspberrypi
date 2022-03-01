#!/usr/bin/bash

# wget https://raw.githubusercontent.com/mugimugi555/raspberrypi/main/install_macchanger.sh && bash install_macchanger.sh ;

sudo echo ;

# set config start automaticary
echo "macchanger macchanger/automatically_run boolean true" | sudo debconf-set-selections ;

# install
sudo apt install -y macchanger;

# add mac address to config file
# ip -a ;
# macchanger -r eth0 ;
echo "macchanger -m 00:11:22:33:44:55 eth0" | sudo tee -a /etc/network/if-pre-up.d/macchanger ;
