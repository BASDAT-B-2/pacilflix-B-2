from django.shortcuts import render
from django.db import connection
from datetime import datetime, timedelta
import json
from django.http import JsonResponse
from django.views.decorators.csrf import csrf_exempt

# Create your views here.
def show_langganan(request):
    username = request.COOKIES.get('username')
    active_package = []
    history = []
    with connection.cursor() as cursor:
        cursor.execute(f"SELECT nama, harga, resolusi_layar FROM paket")
        daftar_paket = cursor.fetchall()
        cursor.execute(f"SELECT metode_pembayaran, start_date_time, end_date_time, nama_paket, timestamp_pembayaran  FROM transaction WHERE username = %s ORDER BY timestamp_pembayaran DESC", [username])
        list_history = cursor.fetchall()
        history = list_history
    for i in range(len(history)) :
        date_obj = history[i][2]
        date_as_datetime = datetime.combine(date_obj, datetime.min.time())
        if datetime.now() < date_as_datetime:
            active_package = history[i]
            break
    print(active_package)
    context = {
        'username': username,
        'active_package': active_package,
        'daftar_paket': daftar_paket,
        'history': history
    }
    
    return render(request, "langganan.html", context)

@csrf_exempt
def proses_pembayaran(request, package):
    if request.method == "POST":
        data = json.loads(request.body)
        username = request.COOKIES.get("username")
        startdate = datetime.now().strftime('%Y-%m-%d')  # Format the current datetime as string (date only)
        enddate = (datetime.now() + timedelta(days=30)).strftime('%Y-%m-%d')  # Format the end date as string (date only)
        metode_pembayaran = data.get("paymentMethod")
        timestamp = datetime.now().strftime('%Y-%m-%d %H:%M:%S')  # Format the current datetime as string (with time)
        try:
            with connection.cursor() as cursor:
                cursor.execute("INSERT INTO TRANSACTION (username, start_date_time, end_date_time, nama_paket, metode_pembayaran, timestamp_pembayaran) VALUES (%s, %s, %s, %s, %s, %s)",
                               (username, startdate, enddate, package, metode_pembayaran, timestamp))
            return JsonResponse({'status': 'success'})
        except Exception as e:
            return JsonResponse({'status': 'failed'})
    else:
        return render(request, "pembayaran.html", {'package': package})



