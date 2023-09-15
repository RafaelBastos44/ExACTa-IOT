
ac = {}
data = {}

-- delaysTime={timeOn,timeOff,pulseBurst, low, high, pulseBurst}
--IR_TV_POWER = 0x19e60707
--ac.delaysTime={  4000,  4500,       560, 560 ,1600, 46200}
--data[1]=IR_TV_POWER
--bitsLen=32





ac.delaysTime={  4000,  4500,       410, 670 ,1770, 5330}
--0xf80721deb24d
--data[1]=0x21deb24d
codeStr="0xf80721deb24d"

--0xf20d06f9b24d
data[2]=0xf20d
data[1]=0x06f9b24d

--data[2]=tonumber("0x"..codeStr:sub(3,6))
--data[1]=tonumber("0x"..codeStr:sub(7))
--print(data[1])
--print(data[2])

valDelay=17000
codeStr='0xce3102fdb24d'


codeStr1="0xff007f8022dd"

bitsLen=48

--ac={}
ac1={}
ac2={}

ac.data={}
ac.data[2]=tonumber("0x"..codeStr:sub(3,6))
ac.data[1]=tonumber("0x"..codeStr:sub(7))

ac1.data={}
ac1.data[2]=tonumber("0x"..codeStr1:sub(3,6))
ac1.data[1]=tonumber("0x"..codeStr1:sub(7))

ac2.data={}
ac2.data[2]=0
ac2.data[1]=0

now1=tmr.now()
gpio.irsend(ac.data,bitsLen, ac.delaysTime,2)
tmr.delay(valDelay)
gpio.irsend(ac1.data,bitsLen, ac.delaysTime,1)
tmr.delay(valDelay)
gpio.irsend(ac2.data,bitsLen, ac.delaysTime,1)
now2=tmr.now()-now1

print(now2)


--[[
now1=tmr.now()
gpio.irsend(data,bitsLen, ac.delaysTime,2)
now2=tmr.now()-now1
tmr.delay(valDelay)
gpio.irsend(data,bitsLen, ac.delaysTime,1)
now3=(tmr.now()-now1)-now2
tmr.delay(valDelay)
gpio.irsend(data,bitsLen, ac.delaysTime,1)
now=tmr.now()
now4=(now-now1)-now3-now2
nowT=now-now1
print(now2)
print(now3)
print(now4)
print(nowT)
--]]