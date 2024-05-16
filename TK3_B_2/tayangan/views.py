from django.shortcuts import render, redirect
from django.db import connection
from django.contrib.auth.decorators import login_required
from django.http import JsonResponse
from datetime import datetime
from django.http import HttpResponse
from django.contrib.auth.forms import UserCreationForm
from django.contrib import messages  
from django.contrib.auth import authenticate, login, logout
from django.urls import reverse
from django.views.decorators.csrf import csrf_exempt

# Create your views here.
def show_series(request):
    return render(request, "HalamanSeries.html")

def show_episode(request):
    return render(request, "HalamanEpisode.html")

def show_film(request,id):
    film = []
    film_tinfo = []
    with connection.cursor() as cursor:
            cursor.execute(f'SELECT id_tayangan, url_video_film, release_date_film, durasi_film FROM FILM WHERE id_tayangan = %s', (id,))
            info = cursor.fetchone()
            film = info
            cursor.execute(f'SELECT id, JUDUL, SINOPSIS, url_video_trailer, release_date_trailer FROM TAYANGAN WHERE id = %s', (id,))
            info_tayangan = cursor.fetchone()
            film_tinfo = info_tayangan

    context = {
        'id' : id,
        'film' : film,
        'film_tinfo' : film_tinfo,
    }

    return render(request, "HalamanFilm.html", context)

#@login_required
def show_tayangan(request):
    film = []
    series = []
    with connection.cursor() as cursor:
        cursor.execute(
            f'SELECT * FROM FILM;')
        film = cursor.fetchall()
        for i in range(len(film)) :
            cursor.execute(f'SELECT id, JUDUL, SINOPSIS, url_video_trailer, release_date_trailer FROM TAYANGAN WHERE id = \'{film[i][0]}\'')
            info = cursor.fetchone()
            film[i] = info
        cursor.execute(
            f'SELECT * FROM SERIES;')
        series = cursor.fetchall()
        for i in range(len(series)) :
            cursor.execute(f'SELECT id, JUDUL, SINOPSIS, url_video_trailer, release_date_trailer FROM TAYANGAN WHERE id = \'{series[i][0]}\'')
            info_seri = cursor.fetchone()
            series[i] = info_seri        

    tayangan = film+series

    context = {
        'tayangan' : tayangan,
        'series' : series,
        'film' : film
    }

    return render(request, "Tayangan.html", context)

def show_trailer(request):
    film = []
    series = []
    with connection.cursor() as cursor:
        cursor.execute(
            f'SELECT * FROM FILM;')
        film = cursor.fetchall()
        for i in range(len(film)) :
            cursor.execute(f'SELECT id, JUDUL, SINOPSIS, url_video_trailer, release_date_trailer FROM TAYANGAN WHERE id = \'{film[i][0]}\'')
            info = cursor.fetchone()
            film[i] = info
        cursor.execute(
            f'SELECT * FROM SERIES;')
        series = cursor.fetchall()
        for i in range(len(series)) :
            cursor.execute(f'SELECT id, JUDUL, SINOPSIS, url_video_trailer, release_date_trailer FROM TAYANGAN WHERE id = \'{series[i][0]}\'')
            info_seri = cursor.fetchone()
            series[i] = info_seri        

    tayangan = film+series

    context = {
        'tayangan' : tayangan,
        'series' : series,
        'film' : film
    }
    return render(request, "trailer.html", context)