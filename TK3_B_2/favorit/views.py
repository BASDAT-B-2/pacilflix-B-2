from django.shortcuts import redirect, render
from django.db import connection
from django.http import HttpResponse
from django.urls import reverse
from datetime import datetime, timedelta
from django.views.decorators.csrf import csrf_exempt


# Create your views here.
def daftar_favorit(request):
    username = request.COOKIES.get('username')
    records_daftar_favorit = []

    with connection.cursor() as cursor:
        cursor.execute(
            f'SELECT * FROM DAFTAR_FAVORIT WHERE username = %s', [username])
        records_daftar_favorit = cursor.fetchall()

    context = {
        'status': 'success',
        'records_daftar_favorit': records_daftar_favorit,
    }
    response = render(request, 'DaftarFavorit.html', context)
    return response

# def tayangan_favorit(request):
#     timestamp = request.GET.get('timestamp')
#     username = request.COOKIES.get('username')
#     records_tayangan_favorit = []

#     with connection.cursor() as cursor:
#         cursor.execute(
#             f'SELECT id_tayangan FROM TAYANGAN_MEMILIKI_DAFTAR_FAVORIT WHERE username = \'{username}\' AND timestamp = \'{timestamp}\'')
#         records_tayangan_favorit = cursor.fetchall()
#         for i in range(len(records_tayangan_favorit)):
#             cursor.execute(
#                 f'SELECT judul FROM TAYANGAN WHERE id = \'{records_tayangan_favorit[i][0]}\'')
#             records_tayangan_favorit[i] = records_tayangan_favorit[i] + cursor.fetchone()
#     context = {
#             'status': 'success',
#             'records_tayangan_favorit': records_tayangan_favorit,
#             'time': timestamp
#         }
#     response = render(request, 'TayanganFavorit.html', context)
#     return response
@csrf_exempt
def hapus_daftar(request):
    username = request.COOKIES.get('username')

    time = request.POST.get("time")
    time_cleaned = time.replace('a.m.', 'AM').replace('p.m.', 'PM')
    judul = request.POST.get("title")
    try: 
        print("Deleting records with username:", username, "and timestamp:", time_cleaned)

        with connection.cursor() as cursor:
            delete_query_daftar_favorit = f'DELETE FROM DAFTAR_FAVORIT WHERE username = \'{username}\' AND judul = \'{judul}\''

            cursor.execute(delete_query_daftar_favorit)

        connection.commit()
        print("Records deleted successfully")

        return redirect('daftar_favorit:show_favorit')
    except Exception as e:
        print("An error occurred:", e)
        return HttpResponse("An error occurred: " + str(e), status=500)

# def hapus_tayangan_favorit(request):
#     username = request.COOKIES.get('username')
#     timestamp = request.GET.get('timestamp')
#     id_tayangan = request.GET.get('id_tayangan')
#     print(2)
#     with connection.cursor() as cursor:
#         cursor.execute(
#             f'DELETE FROM TAYANGAN_MEMILIKI_DAFTAR_FAVORIT WHERE username = \'{username}\' AND timestamp = \'{timestamp}\' \
#                 AND id_tayangan = \'{id_tayangan}\'')
#     connection.commit()
#     redirect_url = reverse('show_favorit:tayangan_favorit') + '?timestamp=' + timestamp
#     return HttpResponseRedirect(redirect_url)