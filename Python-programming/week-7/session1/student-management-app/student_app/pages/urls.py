from django.urls import path
from . import views

app_name = 'pages'   





urlpatterns = [
    path('', views.student_list, name='list'),
    path('add/', views.add_student, name='add'),
    path('<int:pk>/', views.student_detail, name='detail'),
    path('<int:pk>/edit',views.student_edit,name='edit'),
    path('<int:pk>/delete/', views.delete_student, name='delete'),
]