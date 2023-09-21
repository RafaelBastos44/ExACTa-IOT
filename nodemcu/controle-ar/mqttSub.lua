
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
    
    -- delaysTime={timeOn,timeOff,pulseBurst, low, high, pulseBurst}
    ac.delaysTime={  4000,  4500,       410, 670 ,1770, 5330}
    ac.bitsLen=48
    ac.data={}
    ac.data[2]=tonumber("0x"..codeStr:sub(3,6))
    ac.data[1]=tonumber("0x"..codeStr:sub(7))
    
    gpio.irsend(ac.data,ac.bitsLen, ac.delaysTime,2)

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

timerLed = tmr.create()                          
timerLed:register(5000, tmr.ALARM_SEMI, f_timerLed)

timerFalha = tmr.create()
timerFalha:register(1000, tmr.ALARM_SEMI, f_timerFalha)

function rec_message(client,topic,message)
    print(topic.." "..message)
    gpio.write(pin_led,gpio.HIGH)
    
    if topic == "NEC" then
        cmd = tonumber(message)
        nec1(cmd)
    elseif topic == "NEC2" then
        cmd = tonumber(message)
        nec2(cmd)
    elseif topic == "IRARA" then
        gpio.write(pin_sendA,gpio.HIGH)
        irAr(message)
        gpio.write(pin_sendA,gpio.LOW)
    elseif topic == "IRARB" then
        gpio.write(pin_sendB,gpio.HIGH)
        irAr(message)
        gpio.write(pin_sendB,gpio.LOW)
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
    client:subscribe("NEC", 0, function (client) print("Inscrito") end)
    client:subscribe("NEC2", 0, function (client) print("Inscrito") end)
    client:subscribe("IRARA", 0, function (client) print("Inscrito") end)
    client:subscribe("IRARB", 0, function (client) print("Inscrito") end)
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
