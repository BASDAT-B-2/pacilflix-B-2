from django.urls import path
from tayangan.views import *

app_name = 'tayangan'

urlpatterns = [
    path('', show_tayangan, name='show_tayangan'),
    path('trailer/', show_trailer, name='show_trailer'),
    path('series/<uuid:series_id>/', show_series, name='show_series'),
    path('favorit/<uuid:id>/', add_favorit, name='add_favorit'),
    path('unduh/<uuid:id>/', add_download, name='add_download'),
    path('film/<uuid:id>/', show_film, name='show_film'),
    path('ulasan/<uuid:id>/', ulasan, name='ulasan'),
    path('episode/<uuid:series_id>/<int:episode_number>/', show_episode, name='show_episode'),
]