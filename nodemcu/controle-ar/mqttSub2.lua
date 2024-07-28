
config = dofile("credentials.lua")

local pin_sendA = 6
local pin_sendB = 7
local pin_led = 0

local consts = {
    led1 = led1,
    led2 = led2,
    pin_send1 = pin_sendA,
    pin_send2 = pin_sendB,
    estado = "inicio",
    meuid = config.meuid,
    topics = config.topics,
    broker = config.broker,
    port = config.port

}


local function conecta_cliente(maquina, consts)
    print("Conectando cliente")

    if consts.m ~= nil then
        consts.m:on("offline",function() end)
        consts.m:close()
    end

    consts.m = mqtt.Client(consts.meuid, 120)

    local function conexao_sucesso(client)
        print("Connected to MQTT broker")

        for i, topic in ipairs(consts.topics) do
            client:subscribe(topic, 0, function(client)
                local f = maquina[consts.estado] and maquina[consts.estado]["subscribe"]
                if f ~= nil then
                    f(client, topic)
                end
            end)
        end
    end
    
    local function conexao_falha(client, reason)
        local f = maquina[consts.estado] and maquina[consts.estado]["confail"]
        if f ~= nil then
            f(client,reason)
        end
    end

        
    consts.m:on("message", function(client, topic, message)
        local f = maquina[consts.estado] and maquina[consts.estado]["message"]
        if f ~= nil then
            f(client, topic, message)
        end
    end)

    consts.m:on("offline", function(client)
        node.restart()
    end)

    consts.m:connect(config.broker, config.port, 0, conexao_sucesso, conexao_falha)
end

local maquina = dofile("maquina.lua").criaMaquina(consts)
return maquina