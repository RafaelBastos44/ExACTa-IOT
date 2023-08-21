print('Hello from teste1.lua file!')

value_t1 = true

function f_timer1()
    tmr.delay(1000*4000)
    print("Delay ocorrido")
    gpio.write(led, value_t1 and gpio.HIGH or gpio.LOW)
    value_t1 = not value_t1
end

timer1 = tmr.create()

timer1:register(1000,tmr.ALARM_AUTO,f_timer1)
--timer1:start()

print('timer1 iniciado.')
print('led piscando')
