local function conecta_cliente(maquina, consts)
    print("Conectando cliente")

    if consts.m ~= nil then
        consts.m:on("offline",function() end)
        consts.m:close()
    end

    consts.m = mqtt.Client(consts.meuid, 120)

    local function conexao_sucesso(client)
        local estado = consts.estado
        local evento = "connected"
        local f = maquina[estado] and maquina[estado][evento]
        if f ~= nil then f(client,reason) end
      
    end
    
    local function conexao_falha(client, reason)
        local estado = consts.estado
        local evento = "confail"
        local f = maquina[estado] and maquina[estado][evento]
        if f ~= nil then f(client,reason) end
    end

        
    consts.m:on("message", function(client, topic, message)
        f = maquina[consts.estado] and maquina[consts.estado]["message"]
        if f ~= nil then
            f(client, topic, message)
        end
    end)

    consts.m:on("offline", function(client)
        node.restart()
    end)

    consts.m:connect(consts.broker, consts.port, 0, conexao_sucesso, conexao_falha)
end

local function inscreve_topico(client, topic, maquina, consts)
    client:subscribe(topic, 0, function(client)
        local estado = consts.estado
        local evento = "subscribe"
        local f = maquina[estado] and maquina[estado][evento]
        if f ~= nil then f(client, topic) end
    end)
end

    return {inscreve_topico=inscreve_topico, conecta_cliente=conecta_cliente}
