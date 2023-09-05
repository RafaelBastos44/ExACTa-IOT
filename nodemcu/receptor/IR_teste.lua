
ac = {}
data = {}
-- delaysTime={timeOn,timeOff,pulseBurst, low, high, pulseBurst}
ac.delaysTime={  4000,  4500,       560, 560 ,1600, 16000}
IR_TV_POWER = 0xE0E06798
data[1]=IR_TV_POWER
bitsLen=32
gpio.irsend(data,bitsLen, ac.delaysTime,3)
