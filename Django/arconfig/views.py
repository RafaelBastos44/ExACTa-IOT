from django.shortcuts import render
from django.shortcuts import HttpResponse
from django.http import JsonResponse
from paho.mqtt import client as mqtt_client
import arconfig.pub_mqtt as pub
from arconfig.geraIRAR import geraComandoIRAR

def config_ar(request):
    if request.method == 'POST':
        valor = request.POST.get('chaveAr')
        # print("configuação")
        # print(valor)
        code = geraComandoIRAR(ligado="OFF")
        topic = "IRAR%s"%valor
        pub.envia(topic,code)
        print("Código: %s enviado para %s"%(code,topic))

        return JsonResponse({'status': 'sucesso'})
    else:
        return JsonResponse({'status': 'erro'})
