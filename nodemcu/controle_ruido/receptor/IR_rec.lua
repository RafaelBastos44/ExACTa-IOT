
-- delaysTime={timeOn,timeOff,pulseBurst, low, high, pulseBurst}
delaysTime = {  4000,  4500,       410, 670 ,1770}
--delaysTime={  4000,  4500,       560, 560 ,1600}
tolerancias = {  1000,  500,       100, 100 ,300}


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
    local dt=delaysTime
    local tol=tolerancias

    tmr.delay(1*1000*1000)
    
    for i = 1,c do
        l = lista_level[i]
        d = lista_time[i] - last
        somad=somad+d

        
        if l == ON then
            if d > dt[2]-tol[2] and d < dt[2]+tol[2] then
                msg=msg.."Y"
                --print(l.."     "..d)
                --ti = lista_time[i]
            elseif d > dt[4]-tol[4] and d < dt[4]+tol[4] then
                msg=msg.."0"
                tf = lista_time[i]
            elseif d > dt[5]-tol[5] and d < dt[5]+tol[5] then
                msg=msg.."1"
                tf = lista_time[i]
            else
                msg=msg.."E"
                --print(l.."     "..d)
            end
        else
            if d > dt[1]-tol[1] and d < dt[1]+tol[1] then
                msg=msg.."X"
                --print(l.."     "..d)
                ti = lista_time[i]
            elseif not(d > dt[3]-tol[3] and d < dt[3]+tol[3]) then
                msg=msg.."E"
                --print(l.."     "..d)
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
timerTrig:register(1000,tmr.ALARM_SEMI,f_timerTrig)


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


