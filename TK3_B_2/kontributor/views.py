from django.shortcuts import render
from django.db import connection


# Create your views here.
def show_kontributor(request):
    with connection.cursor() as cursor:
        cursor.execute(f"SELECT nama, jenis_kelamin, kewarganegaraan FROM contributors")
        daftar_kontributor = cursor.fetchall()
        for i in range(len(daftar_kontributor)) :
            tipe = []
            cursor.execute(f"SELECT c.nama FROM contributors c join pemain p on p.id=c.id where c.nama = \'{daftar_kontributor[i][0]}\'")
            aktor = cursor.fetchone()
            if aktor:
                tipe.append('Aktor')
            cursor.execute(f"SELECT c.id FROM contributors c join penulis_skenario p on p.id=c.id where c.nama = \'{daftar_kontributor[i][0]}\'")
            penulis = cursor.fetchone()
            if penulis:
                tipe.append('Penulis')  
            cursor.execute(f"SELECT c.id FROM contributors c join sutradara s on s.id=c.id where c.nama = \'{daftar_kontributor[i][0]}\'")
            sutradara = cursor.fetchone()
            if sutradara:
                tipe.append('Sutradara')
            daftar_kontributor[i] = list(daftar_kontributor[i])
            daftar_kontributor[i].insert(3, tipe)
            daftar_kontributor[i] = tuple(daftar_kontributor[i])
    
    context = {'daftar_kontributor': daftar_kontributor}
    return render(request, "kontributor.html", context)