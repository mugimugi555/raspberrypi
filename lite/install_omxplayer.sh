#!/usr/bin/bash

#https://www.snowinnovember.info/archives/20220319-raspberry-pi-omxplayer.html

curl -O https://archive.raspberrypi.org/debian/pool/main/o/omxplayer/omxplayer_20190723+gitf543a0d-1+bullseye_armhf.deb ;
sudo apt install -y ./omxplayer_20190723+gitf543a0d-1+bullseye_armhf.deb ;

cd /usr/lib/arm-linux-gnueabihf ;
sudo curl -sSfLO 'https://raw.githubusercontent.com/raspberrypi/firmware/master/opt/vc/lib/libbrcmEGL.so'    ;
sudo curl -sSfLO 'https://raw.githubusercontent.com/raspberrypi/firmware/master/opt/vc/lib/libopenmaxil.so'  ;
sudo curl -sSfLO 'https://raw.githubusercontent.com/raspberrypi/firmware/master/opt/vc/lib/libbrcmGLESv2.so' ;

omxplayer -o local /usr/share/sounds/alsa/Front_Center.wav ;
