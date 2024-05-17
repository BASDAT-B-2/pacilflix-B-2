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
from datetime import datetime, timedelta

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

            # cursor.execute('SELECT COUNT(*), AVG(rating) FROM RIWAYAT_NONTON WHERE id_tayangan = %s AND EXTRACT(EPOCH FROM (end_date_time - start_date_time)) >= (0.7 * %s * 60)', [film[0], film[3]])
            # view_info = cursor.fetchone()
            cursor.execute('SELECT genre FROM GENRE_TAYANGAN WHERE id_tayangan = %s', (id,))
            genres = cursor.fetchall()
            cursor.execute('SELECT p.nama FROM PEMAIN p JOIN MEMAINKAN_TAYANGAN m ON p.id = m.id_pemain WHERE m.id_tayangan = %s', (id,))
            actors = cursor.fetchall()
            cursor.execute('SELECT p.nama FROM PENULIS_SKENARIO p JOIN MENULIS_SKENARIO_TAYANGAN m ON p.id = m.id_penulis_skenario WHERE m.id_tayangan = %s', (id,))
            writers = cursor.fetchall()
            cursor.execute('SELECT s.nama FROM SUTRADARA s WHERE s.id = %s', [info[5]])
            director = cursor.fetchone()

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
        # 'view_info': view_info,
        'genres' : genres,
        'actors':actors,
        'writers':writers,
        'director':director
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