#!/usr/bin/bash

# wget https://raw.githubusercontent.com/mugimugi555/raspberrypi/main/install_wifi_rtl8188.sh && bash install_wifi_rtl8188.sh ;

#-----------------------------------------------------------------------------------------------------------------------
# install rtl8188 driver
#-----------------------------------------------------------------------------------------------------------------------

cd  ;
sudo apt install -y raspberrypi-kernel-headers ;
sudo apt install -y build-essential git dkms ; # linux-headers-$(uname -r) ;
git clone https://github.com/kelebek333/rtl8188fu ;
sudo dkms install ./rtl8188fu ;
sudo cp ./rtl8188fu/firmware/rtl8188fufw.bin /lib/firmware/rtlwifi/ ;

#sudo iwlist wlan0 scan | grep ESSID ;
#sudo nano /etc/wpa_supplicant/wpa_supplicant.conf ;
#network={
#    ssid="SSID"
#    psk="pass"
#}
