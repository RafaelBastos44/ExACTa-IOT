
local function criaMaquina(consts)
    local topic = consts.topic
    local meuid = consts.meuid
    local maquina
    local qtd_inscritos = 0

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

    local geraComandoIRAR = dofile("geraCodigoIR.lua")

    local send_ir = {
        NEC = function(opcoes)
            local codeStr = opcoes.code
            if codeStr == nil then return end
            local code = tonumber(codeStr)

            local ac={}
            -- delaysTime={timeOn,timeOff,pulseBurst, low, high, pulseBurst}
            ac.delaysTime={  9000,  4500,       560, 560 ,1600, 16000}
            ac.bitsLen=32
            ac.data={}
            ac.data[1]=code
            
            gpio.irsend(ac.data,ac.bitsLen, ac.delaysTime,1)
        end,
        NEC2 = function(opcoes)
            local codeStr = opcoes.code
            if codeStr == nil then return end
            local code = tonumber(codeStr)

            local ac={}
            -- delaysTime={timeOn,timeOff,pulseBurst, low, high, pulseBurst}
            ac.delaysTime={  4000,  4500,       560, 560 ,1600, 16000}
            ac.bitsLen=32
            ac.data={}
            ac.data[1]=code
            
            gpio.irsend(ac.data,ac.bitsLen, ac.delaysTime,1)
        end,
        IRAR = function(opcoes)
            local codeStr = opcoes.code 

            if codeStr == nil then
                local config = {
                    temperatura = tonumber(opcoes.temp),
                    modo = opcoes.modo,
                    fanSpeed = opcoes.fan,
                    ligado = opcoes.ligado
                }
                codeStr = geraComandoIRAR(config)
            end

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
        end
    }

    

    maquina = {
        desconectado = {
            conecta = function()
                conecta_cliente(maquina, consts)
                consts.estado = "conectando"
            end
        },
        conectando = {
            subscribe = function(client,topic)
                print("Inscrito no topico '"..topic.."'")
                qtd_inscritos = qtd_inscritos + 1
                if qtd_inscritos == #consts.topics then
                    consts.estado = "conectado"
                end
            end,
            confail = function(client,reason)
                print("Failed to connect to MQTT broker: " .. reason)
                tmr.create():register(1000, tmr.ALARM_SINGLE, function()
                    qtd_inscritos = 0
                    conecta_cliente(maquina, consts)
                end)
                consts.estado = "inicio"
            end
        },
        conectado = {
            message = function(client, topic, message)
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
                elseif tmsg[2] == meuid then
                    local cmd = mysplit(tmsg[3], ";")
                    local tipo = cmd[1]
                    local n_ir = cmd[2]
                    local opcoes = {}
                    for i=3,#cmd do
                        local opcao = mysplit(cmd[i], "=")
                        opcoes[opcao[1]] = opcao[2]
                    end
                    local f = send_ir[tipo]
                    if f ~= nil then

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
                end
            end
        }
    }
    return maquina
end

return { criaMaquina = criaMaquina }
