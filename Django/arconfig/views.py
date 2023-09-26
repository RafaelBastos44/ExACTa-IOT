from django.shortcuts import render
from django.shortcuts import HttpResponse
from django.http import JsonResponse
from paho.mqtt import client as mqtt_client
from arconfig.pub_mqtt import envia_msg_mqtt
from arconfig.geraIRAR import geraComandoIRAR

def config_ar(request):
    if request.method == 'POST':
        valor = request.POST.get('chaveAr')
        # print("configuação")
        # print(valor)
        code = geraComandoIRAR(ligado="OFF")
        topic = "IRAR%s"%valor
        try:
            envia_msg_mqtt(topic,code)
            print("Código: %s enviado para %s"%(code,topic))
        except:
            print("Não foi possível enviar o código.")
            return JsonResponse({'status': 'error'})

        return JsonResponse({'status': 'sucesso'})
    else:
        return JsonResponse({'status': 'erro'})
