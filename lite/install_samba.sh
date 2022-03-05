#!/usr/bin/bash

# wget https://raw.githubusercontent.com/mugimugi555/raspberrypi/main/lite/install_samba.sh && bash install_samba.sh ;

#-----------------------------------------------------------------------------------------------------------------------
# update
#-----------------------------------------------------------------------------------------------------------------------
sudo apt update ;
sudo apt upgrade -y ;

#-----------------------------------------------------------------------------------------------------------------------
# install samba
#-----------------------------------------------------------------------------------------------------------------------
echo "samba-common samba-common/workgroup string  WORKGROUP" | sudo debconf-set-selections ;
echo "samba-common samba-common/dhcp boolean true"           | sudo debconf-set-selections ;
echo "samba-common samba-common/do_debconf boolean true"     | sudo debconf-set-selections ;
sudo apt install -y samba;

#-----------------------------------------------------------------------------------------------------------------------
# config share folder
#-----------------------------------------------------------------------------------------------------------------------
mkdir ~/share/ ;

SAMBACONF=$(cat<<TEXT
[pi]
   comment = pi user file space
   path = /home/pi/share
   force user = pi
   guest ok = no
   create mask = 0666
   directory mask = 0777
   read only = no
TEXT
)
echo "$SAMBACONF" | sudo tee -a /etc/samba/smb.conf ;

#-----------------------------------------------------------------------------------------------------------------------
# add user and password
#-----------------------------------------------------------------------------------------------------------------------
sudo smbpasswd -a pi ;
sudo systemctl restart smbd ;

#-----------------------------------------------------------------------------------------------------------------------
# finish
#-----------------------------------------------------------------------------------------------------------------------
LOCAL_IPADDRESS=`hostname -I | awk -F" " '{print $1}'` ;
echo "======================================" ;
echo "visit => \\$LOCAL_IPADDRESS" ;
echo "======================================" ;

