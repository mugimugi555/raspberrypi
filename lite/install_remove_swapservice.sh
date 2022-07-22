#!/usr/ban/bash

# wget https://raw.githubusercontent.com/mugimugi555/raspberrypi/main/lite/install_remove_swapservice.sh && bash install_remove_swapservice.sh ;

#
sudo sync ;
sudo swapoff -a ;
sudo apt-get purge -y dphys-swapfile ;
sudo rm /var/swap ;
sudo sync ;

#
#sudo update-rc.d dphys-swapfile disable ;
#sudo rm /etc/init.d/dphys-swapfile ;
#sudo dphys-swapfile disable ;
#sudo dphys-swapfile swapoff ;
#sudo dphys-swapfile uninstall ;
#sudo echo "CONF_SWAPSIZE=0" > /etc/dphys-swapfile ;
#sudo rm /etc/dphys-swapfile ;
#sudo chmod -x /etc/init.d/dphys-swapfile ;

#
sudo reboot now ;
