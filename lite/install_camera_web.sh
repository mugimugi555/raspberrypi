#!/usr/bin/bash

#

#-----------------------------------------------------------------------------------------------------------------------
# enable legacy camera ( 0 = on )
#-----------------------------------------------------------------------------------------------------------------------
sudo raspi-config nonint do_legacy 0 ;
sudo raspi-config nonint do_camera 0 ;

#-----------------------------------------------------------------------------------------------------------------------
# install library
#-----------------------------------------------------------------------------------------------------------------------
sudo apt install -y gcc g++ cmake libjpeg-dev git ;

#-----------------------------------------------------------------------------------------------------------------------
# install mjpg-streamer
#-----------------------------------------------------------------------------------------------------------------------
cd ;
git clone https://github.com/jacksonliam/mjpg-streamer.git ;
cd mjpg-streamer-experimental ;
make ;
sudo make install ;

#-----------------------------------------------------------------------------------------------------------------------
# notice
#-----------------------------------------------------------------------------------------------------------------------
LOCAL_IPADDRESS=`hostname -I | awk -F" " '{print $1}'` ;
echo "======================================" ;
echo "visit =>" ;
echo "http://$LOCAL_IPADDRESS:8080" ;
echo "======================================" ;

#-----------------------------------------------------------------------------------------------------------------------
# start app
#-----------------------------------------------------------------------------------------------------------------------
export LD_LIBRARY_PATH=. ;
./mjpg_streamer -o "output_http.so -w ./www" -i "input_raspicam.so" ;