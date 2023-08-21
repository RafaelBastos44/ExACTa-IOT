-- Load MQTT module
m = mqtt.Client("nodemcuMic", 120)

-- Connect to broker
m:connect("10.201.254.135", 1883, 0,
    function(client)
    
        print("Connected to MQTT broker")
        -- Subscribe to topic
        client:subscribe("MIC", 0,
            function(client)
                print("Subscribed to topic MIC")
            end
        )
    end,
    
    function(client, reason)
        print("Failed to connect to MQTT broker: " .. reason)
    end
)

-- Publish message
--m:publish("MIC", "Bastos Cardoso Mendonca de Rafael",0,0)

-- Disconnect from broker
--m:disconnect()
