

local function geraComandoIRAR(config)
    local temperatura = config.temperatura or 24
    local modo = config.modo or "COOL"
    local fanSpeed = config.fanSpeed or "AUTO"
    local ligado = config.ligado or "ON"

    if ligado=="OFF" then
        return "0xf80721deb24d"
    end

    local codeStr = "101100100100110100000001000000000000000000000011"
    local data_bin = {}
    for i=1,#codeStr do
        data_bin[i] = (codeStr:sub(i,i)=="1")
    end

    local tabelaTemp = {[17]={0,0,0,0}, [18]={0,0,0,1}, [19]={0,0,1,1}, [20]={0,0,1,0},
                [21]={0,1,1,0}, [22]={0,1,1,1}, [23]={0,1,0,1}, [24]={0,1,0,0},
                [25]={1,1,0,0}, [26]={1,1,0,1}, [27]={1,0,0,1}, [28]={1,0,0,0},
                [29]={1,0,1,0}, [30]={1,0,1,1}}
    local indTemp = {33,34,35,36}
    local indTempInv = {41,42,43,44}
    local bitsTemp
    if modo == "FAN" then
        bitsTemp = {1,1,1,0}
    else
        bitsTemp = tabelaTemp[temperatura]
    end
    for i = 1,#indTemp do
        local j
        j = indTemp[i]
        data_bin[j] = (bitsTemp[i]==1)
        j = indTempInv[i]
        data_bin[j] = (bitsTemp[i]==0)
    end

    local tabelaModo = {["COOL"]={0,0}, ["DRY"]={0,1}, ["FAN"]={0,1}, ["HEAT"]={1,1}}
    local indModo={37,38}
    local indModoInv={45,46}
    local bitsModo = tabelaModo[modo]
    for i = 1,#indModo do
        local j
        j = indModo[i]
        data_bin[j] = (bitsModo[i]==1)
        j = indModoInv[i]
        data_bin[j] = (bitsModo[i]==0)
    end
    
    local indTimerOff = {20,21,22,23}
    local indTimerOffInv={28,29,30,31}
    local bitsTimerOff={1,1,1,1}
    for i = 1,#indTimerOff do
        local j
        j = indTimerOff[i]
        data_bin[j] = (bitsTimerOff[i]==1)
        j = indTimerOffInv[i]
        data_bin[j] = (bitsTimerOff[i]==0)
    end

    local tabelaFan = {["AUTO"]={1,0,1}}
    local indFan = {17,18,19}
    local indFanInv={25,26,27}
    local bitsFan = tabelaFan[fanSpeed]
    for i = 1,#indFan do
        local j
        j = indFan[i]
        data_bin[j] = (bitsFan[i]==1)
        j = indFanInv[i]
        data_bin[j] = (bitsFan[i]==0)
    end

    local codeStr = ""
    for i=#data_bin,1,-1 do
        codeStr = codeStr..(data_bin[i] and 1 or 0)
    end
    local codeInt1 = tonumber(codeStr:sub(1,32),2)
    local codeInt2 = tonumber(codeStr:sub(33),2)
    local codeStrHex = "0x"..string.format("%08x",codeInt1)..string.format("%04x",codeInt2)
    
    return codeStrHex
end

return {geraComandoIRAR=geraComandoIRAR}
