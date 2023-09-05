
ac = {}
data = {}
-- delaysTime={timeOn,timeOff,pulseBurst, low, high, pulseBurst}
ac.delaysTime={  9000,  4500,       560, 560 ,1600, 16000}
IR_TV_POWER = 0xE0E06798
--0x00F7C03F
data[1]=0xFC03EF00
bitsLen=32
gpio.irsend(data,bitsLen, ac.delaysTime,1)
