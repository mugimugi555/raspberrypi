#!/usr/bin/bash

# wget https://raw.githubusercontent.com/mugimugi555/raspberrypi/main/update_hostname.sh && bash update_hostname.sh pi-1 ;

#=======================================================================================================================
#
#=======================================================================================================================
if [ $# -ne 1 ]; then
  echo "input value is $# num" 1>&2
  echo "need 1 input value ( = hostname )" 1>&2
  exit 1
fi

#=======================================================================================================================
# backup and rewrite
#=======================================================================================================================

# hosts
sudo cp /etc/hosts /etc/hosts.back ;
sed -e "s/raspberrypi/$1/" /etc/hosts | sudo tee /etc/hosts ;

# hostname
sudo cp /etc/hostname /etc/hostname.back ;
sed -e "s/raspberrypi/$1/" /etc/hostname | sudo tee /etc/hostname ;

#=======================================================================================================================
# finish
#=======================================================================================================================
sudo reboot now	;
