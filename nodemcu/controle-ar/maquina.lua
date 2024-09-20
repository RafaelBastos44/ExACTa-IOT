
local function mysplit(inputstr, sep)
    if sep == nil then
        sep = "%s"
    end
    local t = {}
    for str in string.gmatch(inputstr, "([^" .. sep .. "]+)") do
        table.insert(t, str)
    end
    return t
end

local function criaMaquina(consts)
    local topic = consts.topic
    local meuid = consts.meuid
    local qtd_inscritos = 0
    local maquina

    local send_ir = dofile("send_ir.lua")
    local conectaWifi
    local conecta_cliente
    local inscreve_topico

    do 
        local _mqtt = dofile("mqtt.lua")
        local _wifi = dofile("wifi.lua")
        local _geraCode = dofile("geraCodigoIR.lua")
        conecta_cliente = _mqtt.conecta_cliente
        inscreve_topico = _mqtt.inscreve_topico
        conectaWifi = _wifi.conectaWifi
    end


    maquina = {
        offline = {
            iniciaConexaoWifi = function()
                conectaWifi(maquina, consts)
            end,
            wifiConectado = function()
                consts.estado = "conectando"
                conecta_cliente(maquina, consts)
            end
        },
        
        conectando = {
            connected = function(client)
                print("Conectado ao broker do MQTT")
                for i, topic in ipairs(consts.topics) do
                    inscreve_topico(client,topic,maquina,consts)
                end
            end,
            subscribe = function(client,topic)
                print("Inscrito no topico '"..topic.."'")
                qtd_inscritos = qtd_inscritos + 1
                if qtd_inscritos == #consts.topics then
                    consts.estado = "conectado"
                end
            end,
            confail = function(client,reason)
                print("Falha ao conectar ao broker do MQTT: " .. reason)
                tmr.create():register(1000, tmr.ALARM_SINGLE, function()
                    qtd_inscritos = 0
                    conecta_cliente(maquina, consts)
                end)
            end
        },
        conectado = {
            message = function(client, topic, message)
                print(topic)
                print(message)
                --[[
                MSG <- id_origem,id_destino,CMD
                CMD <- TIPO;N_IR;OPCOES
                OPCOES <- code=CODE;OPCOES
                OPCOES <- mode=MODE;OPCOES
                OPCOES <- temp=TEMP;OPCOES
                OPCOES <- fan=FAN;OPCOES
                OPCOES <- ligado=LIGADO;OPCOES
                OPCOES <- ""
                TIPO <- IRAR | NEC | NEC2
                N_IR <- "1" | "2" | "3"
                CODE <- "0x------------"
                TEMP <- [17,30]
                MODE <- "COOL" | "FAN" | "DRY" | "HEAT"
                LIGADO <- "ON" | "OFF"

                exemplos:
                msg = "SERVIDOR,IRAR_01,IRAR;1;mode=COOL;temp=24;ligado=ON"
                msg = "SERVIDOR,IRAR_01,NEC;2;code=0xfc03ef00"
                msg = "SERVIDOR,BROADCAST,IRAR;3;code=0xf80721deb24d"
                msg = "SERVIDOR,BROADCAST,IRAR;3;ligado=OFF"

                --]]
                local tmsg = mysplit(message, ",")
                if tmsg[1] == meuid then
                    return
                elseif tmsg[2] ~= meuid then return end

                local cmd = mysplit(tmsg[3], ";")
                local tipo = cmd[1]
                local n_ir = cmd[2]
                local opcoes = {}
                for i=3,#cmd do
                    local opcao = mysplit(cmd[i], "=")
                    opcoes[opcao[1]] = opcao[2]
                end

                local f = send_ir[tipo]
                if f == nil then return end

                if n_ir == "1" or n_ir == "3"then
                    gpio.write(consts.pin_send1,gpio.HIGH)
                    f(opcoes)
                    gpio.write(consts.pin_send1,gpio.LOW)
                end

                if n_ir == "2" or n_ir == "3"then
                    gpio.write(consts.pin_send2,gpio.HIGH)
                    f(opcoes)
                    gpio.write(consts.pin_send2,gpio.LOW)
                end
                   
            end
        }
    }
    return maquina
end

return {criaMaquina=criaMaquina}
