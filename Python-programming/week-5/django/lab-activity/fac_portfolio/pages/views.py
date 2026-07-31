from django.shortcuts import render
from django.http import HttpResponse

# Create your views here.

def home(request):
    return HttpResponse ('<h1>Welcome to Home Page</h1>')

def about(request):
    return render(request, 'pages/about.html',{
        'title' : 'About',
        'college_name': 'University of Eldoret',
        'course_name': 'Computer science',
        'highschool_name':'ST. Michels Secondary School'
        
    })

