from django.urls import path
from . import views

urlpatterns = [
    path('',views.config_ar, name='config_ar')
]