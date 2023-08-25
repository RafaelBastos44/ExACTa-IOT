station_cfg={}
station_cfg.ssid=MySSID
station_cfg.pwd=MyPASSWORD

wifi.setmode(wifi.STATION)
status = wifi.sta.config(station_cfg)

print(status)

timerWiFi = tmr.create()

timerWiFi:alarm(1000, tmr.ALARM_AUTO, function()
        if wifi.sta.getip() == nil then
            print("Connecting to Wi-Fi...")
        else
            print("Connected to Wi-Fi!")
            timerWiFi:stop()
            dofile('detectaSomPublish.lua')
        end
    end
)
