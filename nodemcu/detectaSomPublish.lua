m = mqtt.Client("nodemcuMic", 120)

--timerMic = tmr.create()


--countTHENV = 0
--countMic = 0

--start = tmr.now()


--countTHENV = 0

--valEnv = 0
countTHENVPub = 0
countMicPub = 0
count = 0

function f_timerMicPub()

    --[[
    if count > 1 then
        timerMicPub:stop()
        print("Erro no timer")
        m = mqtt.Client("nodemcuMic", 120)
        m:connect(broker, 1883, 0, conexao_sucesso, conexao_falha)
    end
    ]]--
    
    valEnv = adc.read(0)

    if valEnv > THENV then
        countTHENVPub = countTHENVPub + 1
    end

    if countMicPub % 50 == 0 then
        print(countTHENVPub.."   "..valEnv)
        
        if countTHENVPub> 25 then
            gpio.write(led, gpio.HIGH)
        else
            gpio.write(led, gpio.LOW)
        end

        count = count + 1
        if m:publish("MIC", countTHENVPub.."   "..valEnv,0,0) then
          print("Mensagem enviada")
          
          count = count - 1
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









function conexao_sucesso(client)
    print("Connected to MQTT broker")
    timerMicPub:start()
end

function conexao_falha(client, reason)
    print("Failed to connect to MQTT broker: " .. reason)
    client:connect(broker, 1883, 0, conexao_sucesso, conexao_falha)
end

function offline(client)
    timerMicPub:stop()
    print("A conexão esta offline :(\n")
end



m:on("offline",offline)


m:connect(broker, 1883, 0, conexao_sucesso, conexao_falha)

