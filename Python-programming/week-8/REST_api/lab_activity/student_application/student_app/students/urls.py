from django.urls import path, include
from rest_framework.routers import DefaultRouter
from.views import CourseViewSet, StudentViewSet, register_view, logout_view
from rest_framework_simplejwt.views import TokenObtainPairView, TokenRefreshView

router = DefaultRouter()
router.register('courses', CourseViewSet)
router.register('students', StudentViewSet)

urlpatterns = [
    path('register/', register_view, name='register'),
    path('login/', TokenObtainPairView.as_view(), name='login'),
    path('token/refresh/', TokenRefreshView.as_view(), name='token_refresh'),
    path('logout/', logout_view, name='logout'),
    path('', include(router.urls)),
]