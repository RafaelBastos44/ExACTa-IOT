
ac = {}
data = {}

-- delaysTime={timeOn,timeOff,pulseBurst, low, high, pulseBurst}
--IR_TV_POWER = 0x19e60707
--ac.delaysTime={  4000,  4500,       560, 560 ,1600, 46200}
--data[1]=IR_TV_POWER
--bitsLen=32





ac.delaysTime={  4000,  4500,       410, 670 ,1770, 5330}
--0xf80721deb24d
data[1]=0x21deb24d
data[2]=0xf807
bitsLen=48

--0xf20d06f9b24d
--data[2]=0xf20d
--data[1]=0x06f9b24d

now1=tmr.now()
gpio.irsend(data,bitsLen, ac.delaysTime,2)
print(tmr.now()-now1)

