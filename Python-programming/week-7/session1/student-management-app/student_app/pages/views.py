from django.shortcuts import render, get_object_or_404, redirect
from .forms import StudentForm
from .models import Student, Course

from django.db.models import Avg, Count

# Create your views here.

def student_list(request):
    students  = Student.objects.filter(is_active=True).order_by('name')
    stats     = Student.objects.aggregate(avg=Avg('marks'), total=Count('id'))
    courses   = Course.objects.annotate(student_count=Count('students'))
   
    return render(request, 'pages/list.html', {
        'students': students,
        'stats'   : stats,
        'courses' : courses,
        
    })
 
def student_detail(request, pk):
    # get_object_or_404 is safer than get() — shows 404 page, not crash!
    student = get_object_or_404(Student, pk=pk)
    return render(request, 'pages/detail.html', {'student': student})
 
def add_student(request):
    form = StudentForm(request.POST or None)
    if form.is_valid():
        form.save()
        
        return redirect('pages:list')
    return render(request,'pages/add.html',{'form':form,'title':'Add Student'})
 
def student_edit(request, pk):
    student = get_object_or_404(Student, pk=pk)
    form    = StudentForm(request.POST or None, instance=student)
    if form.is_valid():
        form.save()
       
        return redirect('pages:detail', pk=pk)
    return render(request,'pages/edit.html',{'form':form,'student':student})
def delete_student(request,pk):
    student = get_object_or_404(Student, pk=pk)
    student.delete()
    return redirect('pages:list')

