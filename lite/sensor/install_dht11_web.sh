#!/usr/bin/bash

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
# install python library
#-----------------------------------------------------------------------------------------------------------------------
pip3 install bottle ;

#-----------------------------------------------------------------------------------------------------------------------
# create python file
#-----------------------------------------------------------------------------------------------------------------------
cd ;
MY_DHT11_WEB=$(cat<<TEXT
rom bottle import route, run
from bottle import response

import json

import Adafruit_DHT
sensor = Adafruit_DHT.DHT11

pin = 14

@route("/")
def books_list():

    humidity, temperature = Adafruit_DHT.read_retry(sensor, pin)
    books =  {'humidity': humidity, 'temperature': temperature}

    response.headers['Content-Type']  = 'application/json'
    response.headers['Cache-Control'] = 'no-cache'
    return json.dumps(books)

run (host='0.0.0.0', port=8081, debug=True, reloader=True)

TEXT
)
echo "$MY_DHT11_WEB" > ~/dht11_web.py ;

#-----------------------------------------------------------------------------------------------------------------------
# do sensor
#-----------------------------------------------------------------------------------------------------------------------
sudo python3 dht11_web.py ;
