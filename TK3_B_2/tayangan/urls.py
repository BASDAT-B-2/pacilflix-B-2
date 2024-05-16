from django.urls import path
from tayangan.views import *

app_name = 'tayangan'

urlpatterns = [
    path('', show_tayangan, name='show_tayangan'),
    path('trailer/', show_trailer, name='show_trailer'),
    path('series/<uuid:series_id>/', show_series, name='show_series'),
    path('film/<uuid:id>', show_film, name='show_film'),
    path('episode/', show_episode, name='show_episode'),
]