# Student Management REST API - Week 8 Lab Activity

A fully tested REST API built with Django REST Framework and SimpleJWT authentication.

## 🚀 Features
- JWT Authentication (login/logout/refresh/register)
- Students CRUD
- Courses CRUD
- Custom Action: `/api/students/stats/` - analytics

## 📁 Project Structure
```
student_application/
├── student_app/
│   ├── student_app/      # Project config (settings, urls, wsgi)
│   ├── students/          # App (models, views, serializers, urls)
│   └── manage.py
├── postman_collection.json
├── requirements.txt
├── .gitignore
└── README.md
```

## 🛠️ Tech Stack
- Python 3.14
- Django 6.0
- Django REST Framework
- SimpleJWT

## ⚙️ Installation

```bash
# 1. Clone repo
git clone <your-bootcamp-repo-url>
cd week-8/REST_api/lab_activity/student_application/student_app

# 2. Create venv
python -m venv my_venv
source my_venv/bin/activate  # Linux/Mac
# my_venv\Scripts\activate  # Windows

# 3. Install deps
pip install -r requirements.txt
# or
pip install djangorestframework djangorestframework-simplejwt

# 4. Migrate
python manage.py makemigrations
python manage.py migrate

# 5. Run
python manage.py runserver
# Server at http://127.0.0.1:8000/
```

## 🔐 Auth Endpoints

| Method | Endpoint | Auth | Description |
|--------|----------|------|-------------|
| POST | `/api/register/` | No | Register new user |
| POST | `/api/login/` | No | Get JWT access & refresh |
| POST | `/api/token/refresh/` | No | Refresh token |
| POST | `/api/logout/` | Yes | Logout (blacklist) |

**Register Example:**
```json
{
  "username": "felix",
  "password": "12345678",
  "email": "felix@example.com"
}
```

**Login Response:**
```json
{
  "refresh": "eyJ...",
  "access": "eyJ..."
}
```

Use header for all protected routes:
```
Authorization: Bearer <access_token>
```

## 📚 Courses CRUD

| Method | Endpoint | Description |
|--------|----------|-------------|
| POST | `/api/courses/` | Create course |
| GET | `/api/courses/` | List all courses |
| GET | `/api/courses/{id}/` | Retrieve course |
| PUT | `/api/courses/{id}/` | Update course |
| DELETE | `/api/courses/{id}/` | Delete course |

**Create Course Example:**
```json
{
  "name": "Computer Science",
  "code": "CS101",
  "description": "Introduction to CS"
}
```

## 👨‍🎓 Students CRUD

| Method | Endpoint | Description |
|--------|----------|-------------|
| POST | `/api/students/` | Create student |
| GET | `/api/students/` | List students |
| GET | `/api/students/{id}/` | Retrieve student |
| PATCH | `/api/students/{id}/` | Partial update |
| DELETE | `/api/students/{id}/` | Delete student |

**Create Student Example:**
```json
{
  "name": "Felix Flire",
  "reg_no": "FA001",
  "email": "felix@student.com",
  "course_id": 1,
  "marks": 85,
  "year": "3",
  "is_active": true
}
```

## 📊 Custom Action - Stats

`GET /api/students/stats/` - Requires Auth

**Response:**
```json
{
  "total_students": 10,
  "active_students": 8,
  "average_marks": 82.5,
  "students_per_course": [
    {"course__name": "Computer Science", "count": 5},
    {"course__name": "Math", "count": 5}
  ]
}
```

## 🧪 Testing with Postman

All endpoints are fully tested.

1. Import `postman_collection.json` into Postman
2. Set environment variable `base_url = http://127.0.0.1:8000/api`
3. Run collection in order:
   - 1. Auth -> Register -> Login (auto-saves token)
   - 2. Courses CRUD
   - 3. Students CRUD
   - 4. Custom Action -> Stats

Postman collection included in repo: `./postman_collection.json`

## 📄 Submission
- Django project with one app `students`
- Postman collection exported as JSON
- All endpoints tested: auth, students CRUD, courses CRUD, stats

## 👤 Author
Felix Juma - First Advantage Academy 
