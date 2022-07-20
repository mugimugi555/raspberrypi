# https://qiita.com/saba1024/items/a0db0fcf279243f35387

from bottle import route, run
from bottle import response

import json
import datetime
import Adafruit_DHT

t_delta = datetime.timedelta(hours=9)
JST = datetime.timezone(t_delta, 'JST')
now = datetime.datetime.now(JST)
datetime = now.strftime('%Y-%m-%d %H:%M:%S')

sensor = Adafruit_DHT.DHT11
pin = 14

@route("/")
def books_list():

    humidity, temperature = Adafruit_DHT.read_retry(sensor, pin)
    books =  {'humidity': humidity, 'temperature': temperature, 'datetime': datetime}

    response.headers['Content-Type']  = 'application/json'
    response.headers['Cache-Control'] = 'no-cache'
    return json.dumps(books)

run (host='0.0.0.0', port=8081, debug=True, reloader=True)
