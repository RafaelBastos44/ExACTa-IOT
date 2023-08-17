-- Print some welcome message
print('Hello from init.lua file!')

-- Blue LED is connected to pin #2


led = 0



value = true

----[[

gpio.mode(led,gpio.OUTPUT)

tmr.create():alarm(500,1,function()
    gpio.write(led, value and gpio.HIGH or gpio.LOW)
    value = not value
end)
print("Piscando")
----]]



