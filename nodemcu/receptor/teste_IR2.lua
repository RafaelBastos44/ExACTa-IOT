pin = 4


function imprimeS()
    --print(s)
    s = "\n"
    --print(last-inic)
    --print(interval_inic)
    --print(count)
    --print(msg)
    b_inic = true
    gpio.trig(pin, 'down', trgPulse)
    msg = ""
    for i = 1,#lista do
      d = lista[i]
      --print(d)
      if d < 2000 then
        msg = msg.."1"
      else
        msg = msg.."0"
      end
    end
    print(msg)
    lista = {}
    
end


timerS = tmr.create()
timerS:register(500,tmr.ALARM_SEMI,imprimeS)

last = tmr.now()
s = ""
msg = ""
c = 0
count = 0
b_inic = true
interval_inic = 0
lista = {}



function trgPulse(level)
  now = tmr.now()
  d = (now - last)
  last = now
  table.insert(lista, d)
  timerS:start()
  print(tmr.now()-now)
  --print(tmr.now()-now)
end


function lixo()
  s = s..d.."  "..level.."\n"
  
    --print(d.."  "..level)

  if b_inic then
    timerS:start()
    inic = now
    b_inic = false
    gpio.trig(pin, 'up', trgPulse)
    count = 0
    msg = ""
  end

  if level == 1 then
    interval_inic = now - inic
    gpio.trig(pin, 'down', trgPulse)
  end

  count = count + 1

  if d < 3600 then
    msg = msg.."1"
  else
    msg = msg.."0"
  end

  
end



















lista_time = {}
lista_level = {}



function f_timerTrig()

    --print("OK "..#lista_time)
    msg = ""
    last = lista_time[1]
    for i = 1,c do
      l = lista_level[i]
      d = lista_time[i] - last
      last = lista_time[i]
      --print(d)
      msg=msg..l
      --print(l.."     "..d)
      --[[
      if d < 2000 then
        msg = msg.."1"
      else
        msg = msg.."0"
      end
      --]]
    end
    print(msg)
    c=0
    --lista_time = {}
    --lista_level = {}
    
end



timerTrig = tmr.create()
timerTrig:register(500,tmr.ALARM_SEMI,f_timerTrig)


c=0

function trgPulse2(level)
  now = tmr.now()
  --x = {now;level}
  --d = (now - last)
  --last = now
  --table.insert(lista_time, now)
  c=c+1
  lista_time[c]=now
  lista_level[c]=level
  --table.insert(lista_level, level)
  --i = #lista_time+1
  --lista_time[i]=now
  --lista_level[i]=level
  timerTrig:start()
  --print(tmr.now()-now)
  --print(tmr.now()-now)
end



--gpio.mode(pin, gpio.INT)
gpio.mode(pin, gpio.INPUT)

gpio.trig(pin, 'both', trgPulse2)
--gpio.trig(pin, 'down', trgPulse)
--gpio.trig(pin, 'down', trgPulse)
--gpio.trig(pin, 'up', trgPulse)




