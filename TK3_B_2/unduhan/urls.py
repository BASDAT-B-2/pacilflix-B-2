from django.urls import path
from unduhan.views import *

app_name = 'unduhan'

urlpatterns = [
    path('', show_unduhan, name='show_unduhan'),
]