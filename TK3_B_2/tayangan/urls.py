from django.urls import path
from tayangan.views import *

app_name = 'tayangan'

urlpatterns = [
    path('', show_tayangan, name='show_tayangan'),
    path('trailer/', show_trailer, name='show_trailer'),
    path('series/', show_series, name='show_series'),
    path('film/', show_film, name='show_film'),
    path('episode/', show_episode, name='show_episode'),
]