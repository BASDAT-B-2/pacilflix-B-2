from django.shortcuts import render, redirect
from django.db import connection
from django.contrib.auth.decorators import login_required
from django.http import JsonResponse
from datetime import datetime, timedelta
from django.http import HttpResponse
from django.contrib.auth.forms import UserCreationForm
from django.contrib import messages  
from django.contrib.auth import authenticate, login, logout
from django.urls import reverse
from django.views.decorators.csrf import csrf_exempt
from django.contrib.auth.forms import UserCreationForm
from django.contrib.auth import authenticate, login, logout
from django.http import HttpResponseRedirect

# Create your views here.
def show_series(request):
    return render(request, "HalamanSeries.html")

def show_episode(request):
    return render(request, "HalamanEpisode.html")

def show_film(request,id):
    film = []
    film_tinfo = []
    ulasan = []

    with connection.cursor() as cursor:
            cursor.execute(f'SELECT id_tayangan, url_video_film, release_date_film, durasi_film FROM FILM WHERE id_tayangan = %s', (id,))
            info = cursor.fetchone()
            film = info
            cursor.execute(f'SELECT id, JUDUL, SINOPSIS, url_video_trailer, release_date_trailer, asal_negara FROM TAYANGAN WHERE id = %s', (id,))
            info_tayangan = cursor.fetchone()
            film_tinfo = info_tayangan
            cursor.execute(f'SELECT id_tayangan, username, rating, deskripsi FROM ULASAN WHERE id_tayangan = %s', (id,))
            data_ulasan = cursor.fetchall()
            ulasan = data_ulasan

    # hitung_tujuh = datetime.now() - timedelta(days=7)
    
    # with connection.cursor() as cursor:
    #     cursor.execute(f'SELECT  t.id,  COUNT(r.username) as views FROM TAYANGAN t LEFT JOIN RIWAYAT_NONTON r ON t.id = r.id_tayangan LEFT JOIN FILM f ON t.id = f.id_tayangan WHERE r.end_date_time >= %s AND EXTRACT(EPOCH FROM (r.end_date_time - r.start_date_time)) >= (0.7 * f.durasi_film * 60) GROUP BY t.id ORDER BY views ;', [hitung_tujuh])
    #     totalview = cursor.fetchall()
    #     if len(totalview) < 10:
    #         cursor.execute(f'SELECT t.id, COUNT(r.username) as views FROM TAYANGAN t LEFT JOIN RIWAYAT_NONTON r  ON t.id = r.id_tayangan LEFT JOIN FILM f ON t.id = f.id_tayangan WHERE id_tayangan = %s AND t.id NOT IN (SELECT t.id FROM TAYANGAN t LEFT JOIN RIWAYAT_NONTON r ON t.id = r.id_tayangan LEFT JOIN FILM f ON t.id = f.id_tayangan  WHERE r.end_date_time >= %s AND EXTRACT(EPOCH FROM (r.end_date_time - r.start_date_time)) >= (0.7 * f.durasi_film * 60) GROUP BY t.id ORDER BY COUNT(r.username)) GROUP BY t.id, t.judul, t.release_date_trailer ORDER BY views ; ', (id,))
    #         totalview = cursor.fetchone()
            


    context = {
        'id' : id,
        'film' : film,
        'film_tinfo' : film_tinfo,
        'ulasan' : ulasan,
        # 'totalview' : totalview
    }
    return render(request, "HalamanFilm.html", context)

# @login_required
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

    hitung_tujuh = datetime.now() - timedelta(days=7)
    
    with connection.cursor() as cursor:
        cursor.execute(f'SELECT  t.id, t.judul, t.sinopsis, t.url_video_trailer, t.release_date_trailer, COUNT(r.username) as views FROM TAYANGAN t LEFT JOIN RIWAYAT_NONTON r ON t.id = r.id_tayangan LEFT JOIN FILM f ON t.id = f.id_tayangan WHERE r.end_date_time >= %s AND EXTRACT(EPOCH FROM (r.end_date_time - r.start_date_time)) >= (0.7 * f.durasi_film * 60) GROUP BY t.id ORDER BY views DESC LIMIT 10;', [hitung_tujuh])
        topten = cursor.fetchall()
        if len(topten) < 10:
            cursor.execute(f'SELECT t.id, t.judul, t.sinopsis, t.url_video_trailer, t.release_date_trailer, COUNT(r.username) as views FROM TAYANGAN t LEFT JOIN RIWAYAT_NONTON r  ON t.id = r.id_tayangan LEFT JOIN FILM f ON t.id = f.id_tayangan WHERE t.id NOT IN (SELECT t.id FROM TAYANGAN t LEFT JOIN RIWAYAT_NONTON r ON t.id = r.id_tayangan LEFT JOIN FILM f ON t.id = f.id_tayangan  WHERE r.end_date_time >= %s AND EXTRACT(EPOCH FROM (r.end_date_time - r.start_date_time)) >= (0.7 * f.durasi_film * 60) GROUP BY t.id ORDER BY COUNT(r.username) DESC LIMIT 10) GROUP BY t.id, t.judul, t.release_date_trailer ORDER BY views DESC LIMIT %s;', [hitung_tujuh, 10 - len(topten)])
            additional_tayangan = cursor.fetchall()
            topten.extend(additional_tayangan)

    context = {
        'tayangan' : tayangan,
        'series' : series,
        'film' : film,
        'topten' : topten
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
    hitung_tujuh = datetime.now() - timedelta(days=7)

    with connection.cursor() as cursor:
        cursor.execute(f'SELECT  t.id, t.judul, t.sinopsis, t.url_video_trailer, t.release_date_trailer, COUNT(r.username) as views FROM TAYANGAN t LEFT JOIN RIWAYAT_NONTON r ON t.id = r.id_tayangan LEFT JOIN FILM f ON t.id = f.id_tayangan WHERE r.end_date_time >= %s AND EXTRACT(EPOCH FROM (r.end_date_time - r.start_date_time)) >= (0.7 * f.durasi_film * 60) GROUP BY t.id ORDER BY views DESC LIMIT 10;', [hitung_tujuh])
        topten = cursor.fetchall()
        if len(topten) < 10:
            cursor.execute(f'SELECT t.id, t.judul, t.sinopsis, t.url_video_trailer, t.release_date_trailer, COUNT(r.username) as views FROM TAYANGAN t LEFT JOIN RIWAYAT_NONTON r  ON t.id = r.id_tayangan LEFT JOIN FILM f ON t.id = f.id_tayangan WHERE t.id NOT IN (SELECT t.id FROM TAYANGAN t LEFT JOIN RIWAYAT_NONTON r ON t.id = r.id_tayangan LEFT JOIN FILM f ON t.id = f.id_tayangan  WHERE r.end_date_time >= %s AND EXTRACT(EPOCH FROM (r.end_date_time - r.start_date_time)) >= (0.7 * f.durasi_film * 60) GROUP BY t.id ORDER BY COUNT(r.username) DESC LIMIT 10) GROUP BY t.id, t.judul, t.release_date_trailer ORDER BY views DESC LIMIT %s;', [hitung_tujuh, 10 - len(topten)])
            additional_tayangan = cursor.fetchall()
            topten.extend(additional_tayangan)

    context = {
        'tayangan' : tayangan,
        'series' : series,
        'film' : film,
        'topten' : topten
    }

    return render(request, "trailer.html", context)

@csrf_exempt
def ulasan(request, id):
    if request.method == "POST":
        username = request.POST.get("username")
        deskripsi = request.POST.get("deskripsi")
        rating = request.POST.get("rating")

        try :
            with connection.cursor() as cursor:
                cursor.execute(f"INSERT INTO ULASAN VALUES ('{id}','{username}','{datetime.now()}', '{rating}', '{deskripsi}')")
            
            return redirect('show_film', id=id)  
        except Exception as e:
            return render(request, "HalamanFilm.html", {'error': str(e)})

    return HttpResponse(status=405)