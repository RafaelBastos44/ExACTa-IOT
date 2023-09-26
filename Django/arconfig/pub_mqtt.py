import random
from paho.mqtt import client as mqtt_client

broker = '10.201.254.86'
port = 1883

client_id = f'publish-{random.randint(0, 1000)}'

def connect_mqtt():
    def on_connect(client, userdata, flags, rc):
        if rc == 0:
            pass
            print("Connected to MQTT Broker!")
        else:
            print("Failed to connect, return code %d\n", rc)

    client = mqtt_client.Client(client_id)
    # client.username_pw_set(username, password)
    client.on_connect = on_connect
    client.connect(broker, port)
    return client

def envia(topic,msg):
    client = connect_mqtt()
    client.loop_start()
    client.publish(topic, msg)
    client.loop_stop()