pin_rec = 4
pin_send = 2
pin_led = 0

gpio.mode(pin_led, gpio.OUTPUT)
gpio.mode(pin_send, gpio.OUTPUT)
gpio.mode(pin_rec, gpio.INPUT)

MySSID = "PUC@AMERICANAS"
MyPASSWORD="puc#@meric@n@s"

--broker = "10.201.254.135"
broker = "10.201.254.86"

dofile("IR_codes.lua")

--dofile('mqttSub.lua')
