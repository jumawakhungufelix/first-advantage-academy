from rest_framework import viewsets, permissions
from rest_framework.decorators import api_view, permission_classes, action
from rest_framework.permissions import AllowAny
from rest_framework.response import Response
from django.contrib.auth.models import User
from django.db.models import Avg, Count
from.models import Course, Student
from.serializers import CourseSerializer, StudentSerializer

class CourseViewSet(viewsets.ModelViewSet):
    queryset = Course.objects.all()
    serializer_class = CourseSerializer
    permission_classes = [permissions.IsAuthenticated]

class StudentViewSet(viewsets.ModelViewSet):
    queryset = Student.objects.all()
    serializer_class = StudentSerializer
    permission_classes = [permissions.IsAuthenticated]

    @action(detail=False, methods=['get'], url_path='stats')
    def stats(self, request):
        total = Student.objects.count()
        active = Student.objects.filter(is_active=True).count()
        avg_marks = Student.objects.aggregate(avg=Avg('marks'))['avg'] or 0
        by_course = Student.objects.values('course__name').annotate(count=Count('id'))
        return Response({
            "total_students": total,
            "active_students": active,
            "average_marks": round(avg_marks, 2),
            "students_per_course": list(by_course)
        })

@api_view(['POST'])
@permission_classes([AllowAny])
def register_view(request):
    username = request.data.get('username')
    password = request.data.get('password')
    email = request.data.get('email')
    if User.objects.filter(username=username).exists():
        return Response({"error": "Username exists"}, status=400)
    User.objects.create_user(username=username, password=password, email=email)
    return Response({"message": "User created"}, status=201)

@api_view(['POST'])
def logout_view(request):
    
    
    return Response({"message": "Logged out successfully"})