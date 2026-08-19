from django.db import models
from course.models import Course


# Create your models here.

class Student(models.Model):
    name = models.CharField(max_length= 100)
    email = models.EmailField(unique= True)
    reg_no = models.CharField(max_length=10,unique= True)
    course = models.ForeignKey(Course, on_delete= models.CASCADE, related_name= 'students')
    year = models.CharField(max_length= 10)
    
    def __str__(self):
        return f'{self.name}   {self.reg_no}'
    
    
    
