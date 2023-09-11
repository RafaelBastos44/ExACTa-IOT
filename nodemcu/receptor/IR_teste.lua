
ac = {}
data = {}
-- delaysTime={timeOn,timeOff,pulseBurst, low, high, pulseBurst}
ac.delaysTime={  4000,  4500,       410, 670 ,1780, 5300}
IR_TV_POWER = 0xE0E06798
--0x00F7C03F
--data[1]=0xFC03EF00
--0xf80721deb24d
data[1]=0xf80721de
data[2]=0xb24d
bitsLen=48
gpio.irsend(data,bitsLen, ac.delaysTime,2)
