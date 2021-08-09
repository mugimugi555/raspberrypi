#!/usr/bin/bash

sudo rpi-update dc6dc9bc6692d808fcce5ace9d6209d33d5afbac ;

wget https://raw.githubusercontent.com/UedaTakeyuki/gc_setups/master/rtl8188.setup.sh && rtl8188.setup.sh ;

sudo iwlist wlan0 scan | grep ESSID ;

#sudo nano /etc/wpa_supplicant/wpa_supplicant.conf ;

#network={
#    ssid="SSID"
#    psk="pass"
#}
