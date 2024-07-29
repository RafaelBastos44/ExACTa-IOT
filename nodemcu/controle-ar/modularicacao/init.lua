
tmr.delay(3000000)

local config = dofile("credentials.lua")

local pin_sendA = 6
local pin_sendB = 7
local pin_led = 0

local consts = {
    led1 = pin_led,
    pin_send1 = pin_sendA,
    pin_send2 = pin_sendB,
    estado = "offline",
    meuid = config.meuid,
    topics = config.topics,
    broker = config.broker,
    port = config.port,
    station_cfg = {
        ssid=config.ssid,
        pwd=config.password
    }
}

local maquina = dofile("maquina.lua").criaMaquina(consts)

local estado = consts.estado
local evento = "iniciaConexaoWifi"
local f = maquina[estado] and maquina[estado][evento]


if f ~= nil then
    f()
end



-- msg1="publish-583,IRAR_01,IRAR;2;mode=COOL;temp=24;ligado=ON"
-- maquina.conectado.message(nil,nil,msg1)
