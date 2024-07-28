from django.shortcuts import render
from django.shortcuts import HttpResponse
from django.http import JsonResponse
from paho.mqtt import client as mqtt_client
from arconfig.pub_mqtt import envia_msg_mqtt, client_id
from arconfig.geraIRAR import geraComandoIRAR
import json

def config_ar(request):
    if request.method == 'POST':
        body = json.loads(request.body)
        idAr = body.get('idAr')
        temperatura = body.get('tempAr')
        modo = body.get('modoAr')
        ligado = body.get('ligado')

        # code = geraComandoIRAR(ligado="OFF")
        # code = geraComandoIRAR(ligado=ligado,temp=temperatura, mode=modo)
        # topic = "IRAR%s"%idAr
        topic = "ExACTa_FIT_AR"
        idNode = "IRAR_01"
        nIR = 1

        msg = f"{client_id},{idNode},IRAR;{nIR};mode={modo};temp={temperatura};ligado={ligado}"

        try:
            # envia_msg_mqtt(topic,code)
            # print("Código: %s enviado para %s"%(code,topic))
            envia_msg_mqtt(topic,msg)
            print("Mensagem '%s' enviada para %s"%(msg,topic))
        except:
            print("Não foi possível enviar a mensagem.")
            return JsonResponse({'status': 'error'})

        return JsonResponse({'status': 'sucesso'})
    else:
        return JsonResponse({'status': 'erro'})
