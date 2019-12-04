from django.http import HttpResponse

def index(request):
    return HttpResponse("Welcome page, project works!")
