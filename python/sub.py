import random
from datetime import datetime

from paho.mqtt import client as mqtt_client
from credentials import credentials

global file, count

file_path = "dados.csv"
file = open(file_path,"a")

# broker = 'localhost'
# port = 1883
# topic = "MIC_LOG"

broker = credentials["broker"]
port = credentials["port"]
topic = credentials["topic"]

# Generate a Client ID with the subscribe prefix.
client_id = f'subscribe-{random.randint(0, 100)}'
# username = 'emqx'
# password = 'public'

count = 0

def connect_mqtt() -> mqtt_client:
    def on_connect(client, userdata, flags, rc):
        if rc == 0:
            print("Connected to MQTT Broker!")
        else:
            print("Failed to connect, return code %d\n", rc)

    client = mqtt_client.Client(client_id)
    # client.username_pw_set(username, password)
    client.on_connect = on_connect
    client.connect(broker, port)
    return client


def subscribe(client: mqtt_client):
    
    def on_message(client, userdata, msg):
        global file, count
        data = msg.payload.decode()
        print(f"Received `{data}` from `{msg.topic}` topic")
        if len(data)>0 and data[0] == "R" and data[-1]=="B":
            data = data[1:-1]
        else:
            return
        timestamp = datetime.now().isoformat()
        formatted_data = f"{timestamp},{','.join(data.split())}\n"
        
        file.write(formatted_data)
        print(formatted_data)

        count += 1
        if (count >= 50):
            count = 0
            file.close()
            file = open(file_path, 'a')

    client.subscribe(topic)
    client.on_message = on_message


def run():
    client = connect_mqtt()
    subscribe(client)
    client.loop_forever()


if __name__ == '__main__':
    run()