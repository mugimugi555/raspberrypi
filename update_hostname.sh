#!/usr/bin/bash

#

#=======================================================================================================================
#
#=======================================================================================================================
if [ $# -ne 1 ]; then
  echo "input value num is $# " 1>&2
  echo "need 1 input value ( = hostname )" 1>&2
  exit 1
fi

#=======================================================================================================================
# backup and rewrite
#=======================================================================================================================

sudo cp /etc/hosts /etc/hosts.back ;
sed -e "s/raspberrypi/$1/" /etc/hosts | sudo tee /etc/hosts ;

sudo cp /etc/hostname /etc/hostname.back ;
sed -e "s/raspberrypi/$1/" /etc/hostname | sudo tee /etc/hostname ;

sudo reboot now	;
