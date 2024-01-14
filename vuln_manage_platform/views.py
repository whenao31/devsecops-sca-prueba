from django.http import HttpResponse
from django.shortcuts import render
from sca.models import Result


def home(request):
    sca_results = Result.objects.all()
    context = {
        'results': sca_results,
    }
    return render(request, 'home.html', context)