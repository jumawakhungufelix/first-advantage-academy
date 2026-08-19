from django.db import models

class Course(models.Model):
    name = models.CharField(max_length=100)
    code = models.CharField(max_length=20, unique=True)
    description = models.TextField(blank=True)

    def __str__(self):
        return f"{self.code} - {self.name}"

class Student(models.Model):
    name = models.CharField(max_length=100)
    reg_no = models.CharField(max_length=20, unique=True)
    email = models.EmailField(unique=True)
    marks = models.IntegerField(default=0)
    year = models.IntegerField()
    is_active = models.BooleanField(default=True)
    course = models.ForeignKey(Course, on_delete=models.CASCADE, related_name='students')

    @property
    def grade(self):
        # This is for the ReadOnlyField in your serializer
        if self.marks >= 70:
            return 'A'
        elif self.marks >= 60:
            return 'B'
        elif self.marks >= 50:
            return 'C'
        elif self.marks >= 40:
            return 'D'
        else:
            return 'F'

    def __str__(self):
        return f"{self.name} {self.reg_no}"