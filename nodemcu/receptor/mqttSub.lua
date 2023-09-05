--nec = dofile("irsend.lua").nec
--nec2 = dofile("irsend.lua").nec2

nec1={}
nec1.delaysTime={  9000,  4500,       560, 560 ,1600, 16000}
nec1.bitsLen=32
nec1.data={}

function nec(code)
    nec1.data[1]=code
    gpio.irsend(nec1.data,nec1.bitsLen, nec1.delaysTime,1)
end


function f_timerLed()
    print("LED apagado")
    nec(IR_OFF)
    tmr.delay(30000)
    nec(IR_OFF)
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
    if topic == "MIC" then
        if message:sub(1,1) == "R" and message:sub(-1,-1) == "B" then
            local tempSeg = (tmr.now() - old)/1000000
            if not flagLed then
                old = tmr.now()
                flagLed = true
                print("LIGADO")
                nec(IR_ON)
                tmr.delay(30000)
                nec(IR_B7)
            elseif tempSeg > 5 then
                if tempSeg < 10 then
                    nec(IR_ON)
                    tmr.delay(30000)
                    nec(IR_R)
                    print("Vermelhoooooooooooooooooo")
                else
                    if countRGB % 16 == 0 then
                        nec(IR_ON)
                        tmr.delay(30000)
                        nec(IR_SMOOTH)
                        print("SMOOOOOOOOOOOOOOOTH")
                    end
                    countRGB = countRGB + 1
                end
            else
                nec(IR_ON)
                tmr.delay(30000)
                nec(IR_B7)
            end
            
            gpio.write(pin_led, gpio.HIGH)
            timerLed:stop()
            timerLed:start(true)
            --print("LED aceso")
            
        end
    elseif topic == "NEC" then
        cmd = tonumber(message)
        nec(cmd)
    elseif topic == "NEC2" then
        cmd = tonumber(message)
        nec2(pin_send, cmd)
    elseif topic == "IRAR" then
        code1 = 0xb24d
        code2 = 0x7b84e01f
        print("IRAR")
    end
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
