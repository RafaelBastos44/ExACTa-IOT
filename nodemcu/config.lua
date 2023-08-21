--[[


STATION = wifi.STATION

MQTT_CLIENTID = "ESP_001"
MQTT_HOST = "numeros"
MQTT_PORT = 8888

print("Config vars loaded")
--]]

MySSID = "PUC@AMERICANAS"
MyPASSWD = "puc#@meric@n@s"

station_cfg={}
station_cfg.ssid="PUC@AMERICANAS"
station_cfg.pwd="puc#@meric@n@s"

wifi.setmode(wifi.STATION)
status=wifi.sta.config(station_cfg)

print(status)

timerWiFi = tmr.create()

timerWiFi:alarm(1000, tmr.ALARM_AUTO, function()
        if wifi.sta.getip() == nil then
            print("Connecting to Wi-Fi...")
        else
            print("Connected to Wi-Fi!")
            timerWiFi:stop(1)
        end
    end
)
