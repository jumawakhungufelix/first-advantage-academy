from django.urls import path, include
from rest_framework.routers import DefaultRouter
from .views import StudentViewSet, register_view

router = DefaultRouter()
router.register('students', StudentViewSet, basename='student')

urlpatterns = [
    path('register/', register_view, name='register'),
    path('', include(router.urls)),
]