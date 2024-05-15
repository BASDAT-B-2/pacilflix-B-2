from django.urls import path
from langganan.views import *

app_name = 'langganan'

urlpatterns = [
    path('', show_langganan, name='show_langganan'),
    path('pembayaran/', pembayaran, name='pembayaran'),
]