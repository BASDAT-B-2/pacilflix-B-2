from django.shortcuts import render

# Create your views here.
def show_series(request):
    return render(request, "HalamanSeries.html")

def show_episode(request):
    return render(request, "HalamanEpisode.html")

def show_film(request):
    return render(request, "HalamanFilm.html")

def show_tayangan(request):
    return render(request, "Tayangan.html")

def show_trailer(request):
    return render(request, "trailer.html")