
local geraComandoIRAR = dofile("geraCodigoIR.lua").geraComandoIRAR

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
        
        -- delaysTime={timeOn,timeOff,pulseBurst, low, high, pulseBurst}
        ac.delaysTime={  4000,  4500,       410, 670 ,1770, 5330}
        ac.bitsLen=48
        ac.data={}
        ac.data[2]=tonumber("0x"..codeStr:sub(3,6))
        ac.data[1]=tonumber("0x"..codeStr:sub(7))
        
        gpio.irsend(ac.data,ac.bitsLen, ac.delaysTime,2)
        print(codeStr)
    end
}

return send_ir
