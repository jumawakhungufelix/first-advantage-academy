from django.contrib.auth.models import User
from rest_framework import viewsets, permissions
from rest_framework.decorators import api_view, permission_classes
from rest_framework.response import Response
from rest_framework.permissions import AllowAny
from.models import Student
from.serializers import StudentSerializer

# 1. MAIN STUDENT CRUD - Handles /api/students/
class StudentViewSet(viewsets.ModelViewSet):
    queryset = Student.objects.all()
    serializer_class = StudentSerializer
    # Only logged in users with valid token can access students
    permission_classes = [permissions.IsAuthenticated]

# 2. REGISTER - Handles /api/register/
# Anyone can register, so AllowAny
@api_view(['POST'])
@permission_classes([AllowAny])
def register_view(request):
    username = request.data.get('username')
    password = request.data.get('password')
    email = request.data.get('email')

    if not username or not password:
        return Response({"error": "username and password required"}, status=400)

    if User.objects.filter(username=username).exists():
        return Response({"error": "Username already exists"}, status=400)

    user = User.objects.create_user(username=username, password=password, email=email)
    return Response({"message": f"User {user.username} created successfully"}, status=201)