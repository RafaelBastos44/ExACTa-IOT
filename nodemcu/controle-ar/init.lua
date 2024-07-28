pin_sendA = 6
pin_sendB = 7
pin_led = 0

gpio.mode(pin_led, gpio.OUTPUT)
gpio.mode(pin_sendA, gpio.OUTPUT)
gpio.mode(pin_sendB, gpio.OUTPUT)

MySSID = "PUC@AMERICANAS"
MyPASSWORD="puc#@meric@n@s"

--broker = "10.201.254.135"
-- broker = "10.201.254.86"


gpio.write(pin_led,gpio.HIGH)
gpio.write(pin_sendA,gpio.LOW)
gpio.write(pin_sendB,gpio.LOW)

--dofile('mqttSub.lua')
dofile('configWifi.lua')
