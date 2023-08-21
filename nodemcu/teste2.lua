function f_timer2()
    print(adc.read(0))
end

timer2 = tmr.create()

timer2:register(500, tmr.ALARM_AUTO, f_timer2)

print('timer2 criado.')


for i=1,10 do
    tt1 = tmr.now()
    x=adc.read(0)
    print(tmr.now()-tt1)
end
