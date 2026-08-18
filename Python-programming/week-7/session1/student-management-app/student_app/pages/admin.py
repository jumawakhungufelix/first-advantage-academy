from django.contrib import admin

# Register your models here.

from django.contrib import admin
from .models import Student, Course

@admin.register(Course)
class CourseAdmin(admin.ModelAdmin):
    list_display = ('name', 'code')
    search_fields = ('name',)

@admin.register(Student)
class StudentAdmin(admin.ModelAdmin):
    list_display = ('name', 'reg_no', 'email', 'marks', 'course', 'is_active')
    list_filter = ('is_active', 'course')
    search_fields = ('name', 'reg_no', 'email')
    list_editable = ('is_active',)