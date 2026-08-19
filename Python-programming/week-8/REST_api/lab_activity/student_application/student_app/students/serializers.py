from rest_framework import serializers
from students.models import Student, Course
 
# ─── ModelSerializer — like ModelForm for APIs ────────
class CourseSerializer(serializers.ModelSerializer):
    class Meta:
        model  = Course
        fields = ['id','name','code','description']  # or '__all__'
 
class StudentSerializer(serializers.ModelSerializer):
    # Read-only computed field (not stored in DB)
    grade = serializers.ReadOnlyField()    # Uses @property from model
    # Nested serializer — expands ForeignKey to full object
    course = CourseSerializer(read_only=True)
    # Write field — accepts course id when creating
    course_id = serializers.PrimaryKeyRelatedField(
        queryset=Course.objects.all(), source='course', write_only=True
    )
 
    class Meta:
        model  = Student
        fields = ['id','name','reg_no','email','course','course_id',
                  'marks','grade','year','is_active']
        read_only_fields = ['id','grade']
 
    # Custom field-level validation
    def validate_marks(self, value):
        if not 0 <= value <= 100:
            raise serializers.ValidationError('Marks must be between 0 and 100.')
        return value
 
    # Custom object-level validation
    def validate(self, data):
        existing = Student.objects.filter(email=data.get('email')) \
            .exclude(pk=self.instance.pk if self.instance else None)
        if existing.exists():
            raise serializers.ValidationError(
                {'email': 'This email is already registered.'})
        return data