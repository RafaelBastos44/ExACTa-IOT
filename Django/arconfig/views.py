from django.shortcuts import render
from django.shortcuts import HttpResponse
from django.http import JsonResponse

def config_ar(request):
    if request.method == 'POST':
        valor = request.POST.get('chaveAr')
        print("configuação")
        print(valor)
        return JsonResponse({'status': 'sucesso'})
    else:
        return JsonResponse({'status': 'erro'})
