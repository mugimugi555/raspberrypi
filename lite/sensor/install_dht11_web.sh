#!/usr/bin/bash

# wget https://raw.githubusercontent.com/mugimugi555/raspberrypi/main/lite/sensor/install_dht11_web.sh && bash install_dht11_web.sh ;

#-----------------------------------------------------------------------------------------------------------------------
# install python3 pip
#-----------------------------------------------------------------------------------------------------------------------
sudo apt update ;
sudo apt install -y git python3-dev python3-pip ;

#-----------------------------------------------------------------------------------------------------------------------
# install DHT
#-----------------------------------------------------------------------------------------------------------------------
cd ;
git clone --recursive https://github.com/adafruit/Adafruit_Python_DHT.git ;
cd Adafruit_Python_DHT ;
sudo python3 setup.py install ;

#-----------------------------------------------------------------------------------------------------------------------
# install python library
#-----------------------------------------------------------------------------------------------------------------------
pip3 install bottle ;
sudo pip3 install bottle ;

#-----------------------------------------------------------------------------------------------------------------------
# create python file
#-----------------------------------------------------------------------------------------------------------------------
cd ;
wget https://raw.githubusercontent.com/mugimugi555/raspberrypi/main/lite/sensor/dht11_web.py ;

#-----------------------------------------------------------------------------------------------------------------------
# add service
#-----------------------------------------------------------------------------------------------------------------------
DHT11_SERVICE=$(cat<<TEXT
[Unit]
Description=sensor dht11 web server
After=network.target
[Service]
ExecStartPre=
ExecStart=/usr/bin/python /home/$USER/dht11_web.py
Type=simple
User=root
Group=root
Restart=always
[Install]
WantedBy=multi-user.target
TEXT
)
echo "$DHT11_SERVICE" | sudo tee /etc/systemd/system/dht11.service ;
sudo systemctl enable dht11.service ;
sudo systemctl daemon-reload ;
sudo systemctl start dht11.service ;
#sudo systemctl stop dht11.service ;
#sudo systemctl disable dht11.service ;

#-----------------------------------------------------------------------------------------------------------------------
# finish
#-----------------------------------------------------------------------------------------------------------------------
LOCAL_IPADDRESS=`hostname -I | awk -F" " '{print $1}'` ;
echo "======================================" ;
echo "visit =>" ;
echo "http://$LOCAL_IPADDRESS:8081" ;
echo "======================================" ;

#-----------------------------------------------------------------------------------------------------------------------
# do sensor
#-----------------------------------------------------------------------------------------------------------------------
# sudo python3 dht11_web.py ;
