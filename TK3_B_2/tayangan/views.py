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
def show_series(request, series_id):
    episodes = []
    with connection.cursor() as cursor:
        cursor.execute(
            f"SELECT judul, sinopsis, asal_negara FROM TAYANGAN WHERE id = '{series_id}'"
        )
        series_details = cursor.fetchone()

        if series_details:
            cursor.execute(
                f"SELECT genre FROM GENRE_TAYANGAN WHERE id_tayangan = '{series_id}'"
            )
            genres = [genre[0] for genre in cursor.fetchall()]


            cursor.execute(
                f"SELECT id_sutradara FROM TAYANGAN WHERE id = '{series_id}'"
            )
            director_id = cursor.fetchone()[0] if cursor.rowcount > 0 else None

            director = None
            if director_id:
                cursor.execute(
                    f"SELECT nama FROM CONTRIBUTORS WHERE id = '{director_id}'"
                )
                director = cursor.fetchone()[0]

            cursor.execute(
                f"SELECT id_pemain FROM MEMAINKAN_TAYANGAN WHERE id_tayangan = '{series_id}'"
            )
            pemain_ids = cursor.fetchall()

            pemain_names = []
            for pemain_id in pemain_ids:
                cursor.execute(
                    f"SELECT nama FROM CONTRIBUTORS WHERE id = '{pemain_id[0]}'"
                )
                pemain_name = cursor.fetchone()
                if pemain_name:
                    pemain_names.append(pemain_name[0])

            pemain = pemain_names if pemain_names else None

            cursor.execute(
                f"SELECT id_penulis_skenario FROM MENULIS_SKENARIO_TAYANGAN WHERE id_tayangan = '{series_id}'"
            )
            penulis_ids = cursor.fetchall()

            penulis_names = []
            for penulis_id in penulis_ids:
                cursor.execute(
                    f"SELECT nama FROM CONTRIBUTORS WHERE id = '{penulis_id[0]}'"
                )
                penulis_name = cursor.fetchone()
                if penulis_name:
                    penulis_names.append(penulis_name[0])

            penulis = penulis_names if penulis_names else None

            cursor.execute(f"SELECT * FROM EPISODE WHERE id_series = '{series_id}'")
            episodes = cursor.fetchall()
            episodes_with_index = [(i, *episode) for i, episode in enumerate(episodes)]

            series_details = {
                'judul': series_details[0],
                'sinopsis': series_details[1],
                'asal_negara': series_details[2],
                'genres': genres,
                'sutradara': director,
                'pemain' : pemain,
                'penulis' : penulis,
                'id_tayangan' : series_id,
                'episodes' : episodes_with_index,
            }

    return render(request, 'HalamanSeries.html', {'series_details': series_details})


def show_episode(request, series_id, episode_number):
    episode_number = int(episode_number)
    with connection.cursor() as cursor:
        cursor.execute(f"SELECT judul FROM TAYANGAN WHERE id = '{series_id}'")
        series_title = cursor.fetchone()

        cursor.execute(f"SELECT * FROM EPISODE WHERE id_series = '{series_id}'")
        episodes = cursor.fetchall()
        episodes_with_index = [(i, *episode) for i, episode in enumerate(episodes)]

        if 0 <= episode_number < len(episodes):
            episode = episodes[episode_number]
        else:
            episode = None

    context = {
        'episodes' : episodes_with_index,
        'episode': episode,
        'series_title': series_title[0] if series_title else None,  # Ensure series_title is not None before accessing the title
    }
    return render(request, 'HalamanEpisode.html', context)

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