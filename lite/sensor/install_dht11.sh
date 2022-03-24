#!/usr/bin/bash

# wget https://raw.githubusercontent.com/mugimugi555/raspberrypi/main/lite/sensor/install_dht11.sh && bash install_dht11.sh ;

#-----------------------------------------------------------------------------------------------------------------------
# install python3 pip
#-----------------------------------------------------------------------------------------------------------------------
sudo apt update ;
sudo apt install -y python3-pip ;

#-----------------------------------------------------------------------------------------------------------------------
# install DHT
#-----------------------------------------------------------------------------------------------------------------------
cd ;
git clone --recursive https://github.com/adafruit/Adafruit_Python_DHT.git ;
cd Adafruit_Python_DHT ;
sudo python3 setup.py install ;

#-----------------------------------------------------------------------------------------------------------------------
# create python file
#-----------------------------------------------------------------------------------------------------------------------
cd ;
MY_DHT11=$(cat<<TEXT
#!/usr/bin/env python3                                                          

import Adafruit_DHT

sensor = Adafruit_DHT.DHT11

pin = 14

while 1 :

        humidity, temperature = Adafruit_DHT.read_retry(sensor, pin)

        if humidity is not None and temperature is not None:
                print('temperature:{0:0.1f}'.format(temperature))
                print('humidity:{0:0.1f}'.format(humidity))
        else:
                print('Failed to get reading. Try again!')

TEXT
)
echo "$MY_DHT11" > ~/dht11.py ;

#-----------------------------------------------------------------------------------------------------------------------
# do sensor
#-----------------------------------------------------------------------------------------------------------------------
sudo python3 dht11.py ;
