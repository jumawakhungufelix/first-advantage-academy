from django.db import models

# Create your models here.

class Course(models.Model):
    course_name= models.CharField(max_length=50)
    code= models.CharField(max_length=20)
    description= models.CharField(max_length=200, blank= True)
    
    def __str__(self):
        return f'{self.course_name}  {self.code}'
    
