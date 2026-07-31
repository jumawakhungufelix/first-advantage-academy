from django.urls import path
from . import views

urlpatterns=[
    path('', views.home, name = 'home'),
    path('contacts/',views.contacts, name= 'contacts'),
    path('menu/', views.menu, name = 'menu'),
    path('about/',views.about,name = 'about'),
]