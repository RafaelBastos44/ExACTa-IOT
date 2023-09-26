def bit1_48(codeInt, i):
    _1 = 1<<47
    return codeInt | (_1 >> i)

def bit0_48(codeInt, i):
    _1 = 1<<47
    return codeInt & ~(_1 >> i)

def invertHexaBits(sHex,nBits=32):
    x = int(sHex,16)
    sBin = bin(x)[2:].zfill(nBits)
    xInvert = int(sBin[::-1],2)
    sHexInvert = hex(xInvert)
    return sHexInvert

def geraComandoIRAR(temp=24, fanSpeed="AUTO", mode = "COOL",ligado="ON"):
    if ligado == "OFF":
        return "0xf80721deb24d"
    _constStr1 = "101100100100110100000001000000000000000000000011"
    _constInt1 = int(_constStr1,2)
    
    dictFan = {"AUTO":[1,0,1]}
    indFan=[16,17,18]
    indFanInv=[24,25,26]
    bitsFan = dictFan[fanSpeed]
    
    dictTemp = {17:[0,0,0,0], 18:[0,0,0,1], 19:[0,0,1,1], 20:[0,0,1,0],
                21:[0,1,1,0], 22:[0,1,1,1], 23:[0,1,0,1], 24:[0,1,0,0],
                25:[1,1,0,0], 26:[1,1,0,1], 27:[1,0,0,1], 28:[1,0,0,0],
                29:[1,0,1,0], 30:[1,0,1,1]}
    indTemp=[32,33,34,35]
    indTempInv=[40,41,42,43]
    if mode == "FAN":
        bitsTemp = [1,1,1,0,]
    else:
        bitsTemp = dictTemp[temp]
    
    dictMode = {"COOL":[0,0], "DRY":[0,1], "FAN":[0,1], "HEAT":[1,1]}
    indMode=[36,37]
    indModeInv=[44,45]
    bitsMode = dictMode[mode]
    
    indTimerOff=[19,20,21,22]
    indTimerOffInv=[27,28,29,30]
    bitsTimerOff=[1,1,1,1]
    
    code = _constInt1
    
    # print(bin(code))
    for i in range(3):
        if bitsFan[i] == 1:
            code = bit1_48(code, indFan[i])
            code = bit0_48(code, indFanInv[i])
        else:
            code = bit0_48(code, indFan[i])
            code = bit1_48(code, indFanInv[i])
        # print(bin(code))
    
    for i in range(2):
        if bitsMode[i] == 1:
            code = bit1_48(code, indMode[i])
            code = bit0_48(code, indModeInv[i])
        else:
            code = bit0_48(code, indMode[i])
            code = bit1_48(code, indModeInv[i])
        # print(bin(code))
    
    for i in range(4):
        if bitsTemp[i] == 1:
            code = bit1_48(code, indTemp[i])
            code = bit0_48(code, indTempInv[i])
        else:
            code = bit0_48(code, indTemp[i])
            code = bit1_48(code, indTempInv[i])
        # print(bin(code))
    
    for i in range(4):
        if bitsTimerOff[i] == 1:
            code = bit1_48(code, indTimerOff[i])
            code = bit0_48(code, indTimerOffInv[i])
        else:
            code = bit0_48(code, indTimerOff[i])
            code = bit1_48(code, indTimerOffInv[i])
        # print(bin(code))
    
    # print(bin(code))
    
    sHexCode = hex(code)
    sHexCodeInv = invertHexaBits(sHexCode,nBits=48)
    return sHexCodeInv

