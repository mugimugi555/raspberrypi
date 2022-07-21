# https://qiita.com/saba1024/items/a0db0fcf279243f35387

from bottle import route, run
from bottle import response

import json
import datetime
import Adafruit_DHT

#
t_delta  = datetime.timedelta(hours=9)
JST      = datetime.timezone(t_delta, 'JST')
now      = datetime.datetime.now(JST)
datetime = now.strftime('%Y-%m-%d %H:%M:%S')

#
sensor = Adafruit_DHT.DHT11
pin    = 14

#
@route("/")
def sensor_result():

    humidity, temperature = Adafruit_DHT.read_retry(sensor, pin)
    #0.81×気温+0.01×相対湿度（0.99×気温-14.3）+46.3
    comfort = 100 - 0.81 * temperature + 0.01 * humidity * ( 0.99 * temperature - 14.3 ) + 46.3
    myjson = { 'humidity' : humidity , 'temperature' : temperature , 'datetime' : datetime , 'comfort' : comfort }

    response.headers['Content-Type']  = 'application/json'
    response.headers['Cache-Control'] = 'no-cache'
    return json.dumps( myjson )

run (host='0.0.0.0', port=8081, debug=True, reloader=True)
