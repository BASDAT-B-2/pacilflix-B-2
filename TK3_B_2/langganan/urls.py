from django.urls import path
from langganan.views import *

app_name = 'langganan'

urlpatterns = [
    path('', show_langganan, name='show_langganan'),
    path('pembayaran/<str:package>/', proses_pembayaran, name='pembayaran'),
]