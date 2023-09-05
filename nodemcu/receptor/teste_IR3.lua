lista_time = {}
lista_level = {}

ON = 0
OFF = (ON+1)%2

pin_rec=4

function f_timerTrig()
    local msg = ""
    local l
    local d
    local last = lista_time[1]
    local last_l = lista_level[1]
    local ti=0
    local tf=0
    local somad=0

    --tmr.delay(5*1000*1000)
    
    for i = 1,c do
        l = lista_level[i]
        d = lista_time[i] - last
        somad=somad+d

        
        if l == ON then
            if d > 4000 and d < 5000 then
                msg=msg.."Y"
                --ti = lista_time[i]
            elseif d > 500 and d < 700 then
                msg=msg.."0"
                tf = lista_time[i]
            elseif d > 1500 and d < 2000 then
                msg=msg.."1"
                tf = lista_time[i]
            else
                msg=msg.."E"
            end
        else
            if d > 8000 and d < 10000 then
                msg=msg.."X"
                ti = lista_time[i]
            elseif not(d > 500 and d < 700) then
                msg=msg.."E"
            end

        end

        
        --print(l.."     "..d)

        --tmr.delay(100*1000)
        
        last = lista_time[i]
        last_l = lista_level[i]
    end
    print(somad)
    print(msg)
    c=0
    
end



timerTrig = tmr.create()
timerTrig:register(500,tmr.ALARM_SEMI,f_timerTrig)


c=0

function trgPulse(level)
  now = tmr.now()
  c=c+1
  lista_time[c]=now
  lista_level[c]=level
  timerTrig:start()
  --print(tmr.now()-now)
  --print(tmr.now()-now)
end


gpio.mode(pin_rec, gpio.INPUT)

gpio.trig(pin_rec, 'both', trgPulse)


