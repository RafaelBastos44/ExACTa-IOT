from django.shortcuts import render

def mostra_mapa(request):
    return render(request,'mapa.html')