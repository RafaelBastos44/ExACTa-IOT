local function conectaWifi(maquina, consts)
    local station_cfg = consts.station_cfg
            
    wifi.setmode(wifi.STATION)
    local status = wifi.sta.config(station_cfg)

    print(status)

    local timerWiFi = tmr.create()

    timerWiFi:alarm(1000, tmr.ALARM_AUTO, function()
        if wifi.sta.getip() == nil then
            print("Connecting to Wi-Fi...")
        else
            print("Connected to Wi-Fi!")
            timerWiFi:stop()

            local estado = consts.estado
            local evento = "wifiConectado"
            local f = maquina[estado] and maquina[estado][evento]

            if f ~= nil then f() end
        end
    end)
end

return {conectaWifi=conectaWifi}
