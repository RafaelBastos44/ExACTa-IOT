nec = dofile("irsend.lua").nec
nec2 = dofile("irsend.lua").nec2

function f_timerLed()
    print("LED apagado")
    nec(pin_send, IR_OFF)
    tmr.delay(30000)
    nec(pin_send, IR_OFF)
    gpio.write(pin_led, gpio.LOW)
    countRGB = 0
    flagLed = false
end


function f_timerFalha()
    if wifi.sta.getip() ~= nil then
        conecta_cliente()
    else
        dofile('configWifi.lua')
    end
end

flagLed = false
countRGB = 0
old = 0

timerLed = tmr.create()                          
timerLed:register(5000, tmr.ALARM_SEMI, f_timerLed)

timerFalha = tmr.create()
timerFalha:register(1000, tmr.ALARM_SEMI, f_timerFalha)


function rec_message(client,topic,message)
    print(topic.." "..message)
    if topic == "MIC" then
        if message:sub(1,1) == "R" and message:sub(-1,-1) == "B" then
            local tempSeg = (tmr.now() - old)/1000000
            if not flagLed then
                old = tmr.now()
                flagLed = true
                --print("LIGADO")
                nec(pin_send, IR_ON)
                tmr.delay(30000)
                nec(pin_send, IR_B7)
            elseif tempSeg > 5 then
                if tempSeg < 10 then
                    nec(pin_send, IR_ON)
                    tmr.delay(30000)
                    nec(pin_send, IR_R)
                    --print("Vermelhoooooooooooooooooo")
                else
                    if countRGB % 16 == 0 then
                        nec(pin_send, IR_ON)
                        tmr.delay(30000)
                        nec(pin_send, IR_SMOOTH)
                        --print("SMOOOOOOOOOOOOOOOTH")
                    end
                    countRGB = countRGB + 1
                end
            else
                nec(pin_send, IR_ON)
                tmr.delay(30000)
                nec(pin_send, IR_B7)
            end
            
            gpio.write(pin_led, gpio.HIGH)
            timerLed:start(true)
            print("LED aceso")
            
        end
    elseif topic == "NEC" then
        cmd = tonumber(message)
        nec(pin_send, cmd)
    elseif topic == "NEC2" then
        cmd = tonumber(message)
        nec2(pin_send, cmd)
    end
end

function conecta_cliente()
    if m ~= nil then
        m:on("offline",function() end)
        m:close()
    end
    m = mqtt.Client("nodemcuRec", 120)
    m:on("offline",offline)
    m:on("message",rec_message)
    m:connect(broker, 1883, 0, conexao_sucesso, conexao_falha)
end

function conexao_sucesso(client)
    print("Connected to MQTT broker")
    client:subscribe("MIC", 0, function (client) print("Inscrito") end)
    client:subscribe("NEC", 0, function (client) print("Inscrito") end)
    client:subscribe("NEC2", 0, function (client) print("Inscrito") end)
end

function conexao_falha(client, reason)
    print("Failed to connect to MQTT broker: " .. reason)
    timerFalha:start()
end

function offline(client)
    print("A conexão esta offline :(\n")
    timerFalha:start()
end

conecta_cliente()
