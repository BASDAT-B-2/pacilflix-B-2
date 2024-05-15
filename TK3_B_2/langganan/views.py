from django.shortcuts import render

# Create your views here.
def show_langganan(request):
    return render(request, "langganan.html")

def pembayaran(request):
    return render(request, "pembayaran.html")
