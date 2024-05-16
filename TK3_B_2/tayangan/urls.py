from django.urls import path
from tayangan.views import *

app_name = 'tayangan'

urlpatterns = [
    path('', show_tayangan, name='show_tayangan'),
    path('trailer/', show_trailer, name='show_trailer'),
    path('series/<int:series_id>/', show_series, name='show_series'),
    path('film/<uuid:id>', show_film, name='show_film'),
    path('series/<int:series_id>/episode/<int:episode_number>/', show_episode, name='show_episode'),
]