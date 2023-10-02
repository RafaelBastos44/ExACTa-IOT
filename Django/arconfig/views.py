from django.shortcuts import render
from django.shortcuts import HttpResponse
from django.http import JsonResponse
from paho.mqtt import client as mqtt_client
from arconfig.pub_mqtt import envia_msg_mqtt
from arconfig.geraIRAR import geraComandoIRAR
import json

def config_ar(request):
    if request.method == 'POST':
        body = json.loads(request.body)
        idAr = body['idAr']
        temperatura = body['tempAr']
        modo = body['modoAr']

        # code = geraComandoIRAR(ligado="OFF")
        code = geraComandoIRAR(temp=temperatura, mode=modo)
        topic = "IRAR%s"%idAr
        try:
            envia_msg_mqtt(topic,code)
            print("Código: %s enviado para %s"%(code,topic))
        except:
            print("Não foi possível enviar o código.")
            return JsonResponse({'status': 'error'})

        return JsonResponse({'status': 'sucesso'})
    else:
        return JsonResponse({'status': 'erro'})
