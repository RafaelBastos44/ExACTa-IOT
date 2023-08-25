i2c0 = {
  id  = 0,
  sda = 2,
  scl = 1,
  speed = i2c.SLOW
}

r = 0xff
g = 0xff
b = 0xff

threshold = 20

i2c0.speed = i2c.setup(i2c0.id, i2c0.sda, i2c0.scl, i2c0.speed)
print("i2c bus 0 speed: ", i2c0.speed)

i2c.start(i2c0.id)

tAdress = i2c.address(i2c0.id,0x09,i2c.TRANSMITTER)
print(tAdress)


tWrite = i2c.write(i2c0.id,0x6e,r,g,b)

tWrite = i2c.write(i2c0.id,0x6f) --para tudo
print(tWrite)

i2c.stop(i2c0.id)
