from django import forms
from .models import Student, Course
 
class StudentForm(forms.ModelForm):
    class Meta:
        model   = Student
        fields  = ['name','reg_no','email','course','year','marks']
        widgets = {
            'name'   : forms.TextInput(attrs={'class':'form-control'}),
            'reg_no' : forms.TextInput(attrs={'class':'form-control'}),
            'email'  : forms.EmailInput(attrs={'class':'form-control'}),
            'course' : forms.Select(attrs={'class':'form-select'}),
            'year'   : forms.NumberInput(attrs={'class':'form-control'}),
            'marks'  : forms.NumberInput(attrs={'class':'form-control','step':'0.1'}),
        }