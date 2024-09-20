
function nec1(code)
    local ac={}
    -- delaysTime={timeOn,timeOff,pulseBurst, low, high, pulseBurst}
    ac.delaysTime={  9000,  4500,       560, 560 ,1600, 16000}
    ac.bitsLen=32
    ac.data={}
    ac.data[1]=code
    
    gpio.irsend(ac.data,ac.bitsLen, ac.delaysTime,1)
end


function nec2(code)
    local ac={}
    -- delaysTime={timeOn,timeOff,pulseBurst, low, high, pulseBurst}
    ac.delaysTime={  4000,  4500,       560, 560 ,1600, 16000}
    ac.bitsLen=32
    ac.data={}
    ac.data[1]=code
    
    gpio.irsend(ac.data,ac.bitsLen, ac.delaysTime,1)
end

function irAr(codeStr)
    local ac={}
    local ac1={}
    local ac2={}
    local valDelay=17000
    local codeStr1="0xff007f8022dd"
    -- delaysTime={timeOn,timeOff,pulseBurst, low, high, pulseBurst}
    ac.delaysTime={  4000,  4500,       410, 670 ,1770, 5330}
    ac.bitsLen=48
    ac.data={}
    ac.data[2]=tonumber("0x"..codeStr:sub(3,6))
    ac.data[1]=tonumber("0x"..codeStr:sub(7))

    ac1.data={}
    ac1.data[2]=tonumber("0x"..codeStr1:sub(3,6))
    ac1.data[1]=tonumber("0x"..codeStr1:sub(7))

    ac2.data={}
    ac2.data[2]=0
    ac2.data[1]=0
    
    --now1=tmr.now()
    gpio.irsend(ac.data,ac.bitsLen, ac.delaysTime,2)
    --tmr.delay(valDelay)
    --gpio.irsend(ac1.data,ac.bitsLen, ac.delaysTime,1)
    --tmr.delay(valDelay)
    --gpio.irsend(ac2.data,ac.bitsLen, ac.delaysTime,1)
    --now2=tmr.now()-now1

    print(now2)
    
end

function f_timerLed()
    print("LED apagado")
    nec1(IR_OFF)
    tmr.delay(30000)
    nec1(IR_OFF)
    gpio.write(pin_led, gpio.LOW)
    countRGB = 0
    flagLed = false
end


function f_timerFalha()
    print("Falha")
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
    gpio.write(pin_led,gpio.HIGH)
    if topic == "MIC" then
        if message:sub(1,1) == "R" and message:sub(-1,-1) == "B" then
            local tempSeg = (tmr.now() - old)/1000000
            if not flagLed then
                old = tmr.now()
                flagLed = true
                print("LIGADO")
                nec1(IR_ON)
                tmr.delay(30000)
                nec1(IR_B7)
            elseif tempSeg > 5 then
                if tempSeg < 10 then
                    nec1(IR_ON)
                    tmr.delay(30000)
                    nec1(IR_R)
                    print("Vermelhoooooooooooooooooo")
                else
                    if countRGB % 16 == 0 then
                        nec1(IR_ON)
                        tmr.delay(30000)
                        nec1(IR_SMOOTH)
                        print("SMOOOOOOOOOOOOOOOTH")
                    end
                    countRGB = countRGB + 1
                end
            else
                nec1(IR_ON)
                tmr.delay(30000)
                nec1(IR_B7)
            end
            
            gpio.write(pin_led, gpio.HIGH)
            timerLed:stop()
            timerLed:start(true)
            --print("LED aceso")
            
        end
    elseif topic == "NEC" then
        cmd = tonumber(message)
        nec1(cmd)
    elseif topic == "NEC2" then
        cmd = tonumber(message)
        nec2(cmd)
    elseif topic == "IRAR" then
        irAr(message)
        --dofile("IR_teste.lua")
        --code1 = 0xb24d
        --code2 = 0x7b84e01f
        print("IRAR")
    end
    gpio.write(pin_led,gpio.LOW)
end

function conecta_cliente()
    print("Conectando cliente")
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
    client:subscribe("IRAR", 0, function (client) print("Inscrito") end)
    gpio.write(pin_led,gpio.LOW)
end

function conexao_falha(client, reason)
    gpio.write(pin_led,gpio.HIGH)
    print("Failed to connect to MQTT broker: " .. reason)
    timerFalha:start()
end

function offline(client)
    gpio.write(pin_led,gpio.HIGH)
    print("A conexão esta offline :(\n")
    timerFalha:start()
end

conecta_cliente()
