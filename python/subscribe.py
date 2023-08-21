import paho.mqtt.client as mqtt
import queue
#import data_filter

# mqtt_data_queue = queue.Queue()
# Definição de funções
def on_message(client, userdata, message):
    msg = str(message.payload.decode("utf-8"))
    print("Mensagem recebida: ", msg)
    #data_filter.process_data(msg)

def execute_mqtt_subscribe(mqtt_sub_queue):
    mqttBroker = "127.0.0.1"

    client = mqtt.Client("nodemcuServidor")
    client.connect(mqttBroker)
    client.loop_start()
    print("Subscribing to topic", "MIC")
    client.subscribe("MIC")
    client.on_message = on_message

    while True:
        # Verificar se é hora de parar
        if not mqtt_sub_queue.empty() and mqtt_sub_queue.get() == "stop":
            break

    # Encerrar a conexão com o broker MQTT
    print("Encerrando mqtt_subscribe...")
    client.loop_stop() 
    client.disconnect()

execute_mqtt_subscribe()