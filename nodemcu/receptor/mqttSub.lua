
function f_timerLed()
    print("LED apagado")
    dofile("irsend.lua").nec(pin_send, IR_OFF)
    gpio.write(pin_led, gpio.LOW)
end


function f_timerFalha()
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
    if topic == "MIC" then
        if message:sub(1,1) == "R" and message:sub(-1,-1) == "B" then
            gpio.write(pin_led, gpio.HIGH)
            timerLed:start(true)
            dofile("irsend.lua").nec(pin_send, IR_ON)
            print("LED aceso")
        end
    end
end

function conecta_cliente()
    m = mqtt.Client("nodemcuRec", 120)
    m:on("offline",offline)
    m:on("message",rec_message)
    m:connect(broker, 1883, 0, conexao_sucesso, conexao_falha)
end

function conexao_sucesso(client)
    print("Connected to MQTT broker")
    --client:subscribe("MIC", 0, function () print("Subescrito") end)
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
