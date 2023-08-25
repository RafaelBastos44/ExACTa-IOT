m = mqtt.Client("nodemcuMic", 120)
timerMic = tmr.create()


countTHENV = 0
countMic = 0

--broker = "10.201.254.135"
--broker = "10.201.254.86"

m:connect(broker, 1883, 0,
    function(client)
    
        print("Connected to MQTT broker")

        timerMic:register(10, tmr.ALARM_AUTO,

            function()
                valEnv = adc.read(0)
            
                if valEnv > THENV then
                    countTHENV = countTHENV + 1
                end
            
                if countMic % 50 == 0 then
                    s = countTHENV.."   "..valEnv
                    client:publish("MIC",s,0,0)
                    countTHENV = 0
                    if countTHENV> 25 then
                        gpio.write(led, gpio.HIGH)
                    else
                        gpio.write(led, gpio.LOW)
                    end
                end
                
                countMic = countMic +1
            end
)

    end,
    
    function(client, reason)
        print("Failed to connect to MQTT broker: " .. reason)
    end
)
