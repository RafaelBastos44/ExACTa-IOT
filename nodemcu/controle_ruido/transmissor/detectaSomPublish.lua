

function f_timerMicPub()
    
    valEnv = adc.read(0)

    if valEnv > THENV then
        countTHENVPub = countTHENVPub + 1
    end

    if countMicPub % 50 == 0 then
        message = "R"..countTHENVPub.." "..valEnv.."B"
        
        if countTHENVPub >= 50 * RTH then
            m:publish("MIC", message,2,0)
            --gpio.write(led, gpio.HIGH)
        else
            --gpio.write(led, gpio.LOW)
        end

        if m:publish("MIC_LOG", message,2,0) then
          print("Mensagem '"..message.."' enviada")
        else
          print("Erro ao enviar mensagem")
        end

        countTHENVPub = 0
    end

    countMicPub = countMicPub +1
end

timerMicPub = tmr.create()

timerMicPub:register(10, tmr.ALARM_AUTO, f_timerMicPub)

print('timerMicPub criado.')

function f_timerFalha()
    if wifi.sta.getip() ~= nil then
        conecta_cliente()
        --tmr.create():alarm(1,tmr.ALARM_SINGLE,conecta_cliente)
    else
        dofile('configWifi.lua')
    end
end


timerFalha = tmr.create()

timerFalha:register(1000, tmr.ALARM_SEMI, f_timerFalha)


function conecta_cliente()
    m = mqtt.Client("nodemcuMic", 120)
    m:on("offline",offline)
    m:connect(broker, 1883, 0, conexao_sucesso, conexao_falha)
end

function conexao_sucesso(client)
    print("Connected to MQTT broker")
    countTHENVPub = 0
    countMicPub = 0
    timerMicPub:start()
end

function conexao_falha(client, reason)
    print("Failed to connect to MQTT broker: " .. reason)
    timerFalha:start()
end

function offline(client)
    timerMicPub:stop()
    print("A conexão esta offline :(\n")
    timerFalha:start()
    --dofile('initX.lua')
end

conecta_cliente()
