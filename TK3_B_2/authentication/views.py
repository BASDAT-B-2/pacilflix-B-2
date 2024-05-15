from django.shortcuts import render
from django.shortcuts import redirect
from django.contrib.auth.forms import UserCreationForm
from django.contrib import messages  
from django.contrib.auth import authenticate, login, logout
from django.contrib.auth.decorators import login_required
from django.db import connection
from django.http import HttpResponseRedirect, JsonResponse
from django.urls import reverse
from django.views.decorators.csrf import csrf_exempt

@csrf_exempt
def register(request):
    if request.method == "POST":
        username = request.POST.get("username")
        password = request.POST.get("password")
        country = request.POST.get("country")
        try :
            with connection.cursor() as cursor:
                cursor.execute(f"INSERT INTO PENGGUNA VALUES ('{username}', '{password}', '{country}')")
            return render(request, "register.html")
        except Exception as e:
            return render(request, "register.html", {'error':e})
    else:
        return render(request, "register.html")

@csrf_exempt
def login_user(request):
    context = {"error": ""}
    if request.method == "POST":
        username = request.POST.get("username")
        password = request.POST.get("password")
        with connection.cursor() as cursor:
            cursor.execute(f"SELECT username, negara_asal FROM PENGGUNA WHERE username='{username}' AND password='{password}'")
            pengguna = cursor.fetchall()
            print(pengguna)
        
        if len(pengguna) != 0:
            username = pengguna[0][0]
            negara_asal = pengguna[0][1]
            response = HttpResponseRedirect(reverse("tayangan:show_tayangan"))
            response.set_cookie('username', username)
            response.set_cookie('negara', negara_asal)
            response.set_cookie('is_authenticated', "True")
            return response
        else:
            context = {"error": "Username atau password salah. Silakan coba lagi."}
            return render(request, 'login.html', context)
    return render(request, 'login.html', context)

def logout_user(request):
    response = HttpResponseRedirect(reverse('authentication:landing'))
    response.delete_cookie('username')
    response.delete_cookie('negara')
    response.delete_cookie('is_authenticated')
    return response

def landing(request):
    return render(request, 'LoginRegist.html')