import paho.mqtt.client as mqtt

# Define callback functions for events
def on_connect(client, userdata, flags, rc):
    print("Connected to MQTT broker")

def on_message(client, userdata, msg):
    print(msg.topic + " " + str(msg.payload))

# Create client instance and connect to broker
client = mqtt.Client()
client.on_connect = on_connect
client.on_message = on_message
client.connect("123.0.0.1", 1883, 60)

# Subscribe to topic
client.subscribe("MIC")

# Publish message
client.publish("MIC", "oi")

# Loop forever and listen for incoming messages
client.loop_forever()