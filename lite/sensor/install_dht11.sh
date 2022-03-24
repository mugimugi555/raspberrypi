

cd ;
git clone --recursive https://github.com/adafruit/Adafruit_Python_DHT.git ;
cd Adafruit_Python_DHT ;
sudo python3 setup.py install ;

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
echo "$MJPG_STREAMER" > ~/dht11.py ;
sudo python3 dht11.py ;
