-- Load MQTT module
m = mqtt.Client("nodemcuMic", 120)

-- Connect to broker
m:connect(broker, 1883, false,
    function(client)
    
        print("Connected to MQTT broker")
        
        client:publish("MIC","funfou",0,0)
        
    end,
    
    function(client, reason)
        print("Failed to connect to MQTT broker: " .. reason)
    end
)



print("linha apos o connect")



-- Publish message
--m:publish("MIC", "funfou",0,0)

-- Disconnect from broker
--m:disconnect()
