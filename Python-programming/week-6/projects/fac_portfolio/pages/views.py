from django.shortcuts import render

# Create your views here.

def home(request):
    return render(request, 'pages/home.html')

def about(request):
    return render(request, 'pages/about.html')

def skills(request):
    return render(request, 'pages/skills.html')

def projects(request):
    return render( request, 'pages/projects.html')

def contacts(request):
    return render(request, 'pages/contacts.html')
