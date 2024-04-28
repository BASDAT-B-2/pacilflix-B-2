from django.shortcuts import render

# Create your views here.
def show_main(request):
    context = {
        'name': 'Kelompok 2',
        'class': 'Basdat B'
    }

    return render(request, "main.html", context)