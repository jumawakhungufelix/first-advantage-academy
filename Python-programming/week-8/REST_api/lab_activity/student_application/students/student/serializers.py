from rest_framework import serializers
from .models import Student
from course.models import Course
from course.serializers import CourseSerializer  # import serializer from other app

class StudentSerializer(serializers.ModelSerializer):
    # When you GET, show full course object
    course = CourseSerializer(read_only=True)
    
    # When you POST, just send course_id
    course_id = serializers.PrimaryKeyRelatedField(
        queryset=Course.objects.all(),
        source='course',
        write_only=True
    )

    class Meta:
        model = Student
        fields = ['id', 'name', 'course', 'course_id', 'reg_no', 'year']
        read_only_fields = ['id']