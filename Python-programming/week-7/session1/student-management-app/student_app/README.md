# Student Management System - Django

A simple, Bootstrap 5 powered Student Management System built with Django 6.1. Manage students, courses, grades, and enrollment with full CRUD functionality.

![Python](https://img.shields.io/badge/Python-3.14.5-blue)
![Django](https://img.shields.io/badge/Django-6.1-green)
![Bootstrap](https://img.shields.io/badge/Bootstrap-5.3-purple)

## Features

- ✅ Add / Edit / Delete Students
- ✅ Student List with Active filter
- ✅ Grade Letter calculation (A, B, C, D, F) alongside marks
- ✅ Average marks & Total students stats with `Avg` and `Count`
- ✅ Course-wise student count with `annotate`
- ✅ Detail view with `get_object_or_404`
- ✅ Bootstrap 5 Responsive UI
- ✅ Namespaced URLs (`pages:`)

## Tech Stack

- **Backend:** Django 6.1, Python 3.14.5
- **Database:** SQLite (default)
- **Frontend:** Django Templates + Bootstrap 5.3
- **ORM Features:** `filter()`, `aggregate()`, `annotate()`, `Count`, `Avg`

## Project Structure

student-management-app/
├── student_app/
│ ├── pages/
│ │ ├── models.py # Student, Course models + grade_letter property
│ │ ├── views.py # student_list, detail, add, update, delete
│ │ ├── urls.py # app_name = 'pages'
│ │ ├── forms.py # StudentForm (ModelForm)
│ │ └── templates/pages/
│ │ ├── base.html
│ │ ├── list.html # Main list with marks + grade
│ │ ├── detail.html
│ │ ├── edit.html # Bootstrap edit form
│ │ └── form.html
│ └── student_app/
│ ├── urls.py # include('pages.urls')
│ └── settings.py
└── README.md


## Models

**Student**
- `name`, `reg_no` (unique), `email`, `marks`, `is_active`, `course` (FK)
- `@property def grade_letter()` -> Returns A/B/C/D/F based on marks

**Course**
- `name`, `code`

## Installation

1. Clone / Copy project
```bash
cd student-management-app/student_app

python3 -m venv venv
source venv/bin/activate  # Linux/Mac
# venv\Scripts\activate on Windows

pip install django

python manage.py makemigrations
python manage.py migrate

python manage.py createsuperuser

python manage.py runserver

Visit http://127.0.0.1:8000/
URLs

Path
	

Name
	

View
	

Function

/
	

pages:list
	

student_list
	

List active students ordered by name

/add/
	

pages:add
	

add_student
	

Create student

/<int:pk>/
	

pages:detail
	

student_detail
	

Detail with get_object_or_404

/<int:pk>/edit/
	

pages:edit
	

update_student
	

Edit with instance=student

/<int:pk>/delete/
	

pages:delete
	

delete_student
	

Delete

    Note on <int:pk>: Captures integer ID from URL and passes as pk to view. pk = Primary Key. Used to fetch specific student: get_object_or_404(Student, pk=pk)

    Note on NoReverseMatch: Always use namespaced URL: {% url 'pages:edit' s.pk %} not {% url 'edit' s.pk %} when you have app_name = 'pages' in urls.py.


Author
Felix Juma - First Advantage Academy - Python Programming 