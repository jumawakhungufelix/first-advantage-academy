from django.db import models

# Create your models here.


class Course(models.Model):
    name        = models.CharField(max_length=100)
    code        = models.CharField(max_length=20, unique=True)
    description = models.TextField(blank=True)
    created_at  = models.DateTimeField(auto_now_add=True)
 
    def __str__(self):
        return f'{self.code} — {self.name}'
 
class Student(models.Model):
    # Relationships
    course = models.ForeignKey(Course, on_delete=models.CASCADE,
                               related_name='students')
    # Text fields
    name     = models.CharField(max_length=150)
    reg_no   = models.CharField(max_length=30, unique=True)
    email    = models.EmailField(unique=True)
    bio      = models.TextField(blank=True, null=True)
 
    # Numeric fields
    marks    = models.FloatField(default=0.0)
    year     = models.IntegerField(default=1)
    fee_paid = models.DecimalField(max_digits=10, decimal_places=2, default=0)
 
    # Boolean & Date
    is_active  = models.BooleanField(default=True)
    date_joined= models.DateField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)
 
    # Computed property
    @property
    def grade(self):
        if self.marks >= 70: return 'A'
        elif self.marks >= 60: return 'B'
        elif self.marks >= 50: return 'C'
        return 'Fail'
    
    def __str__(self):
        return f'{self.name} ({self.reg_no})'