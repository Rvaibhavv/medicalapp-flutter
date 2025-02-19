# Swasthya - Healthcare App

## Overview
Swasthya is a comprehensive healthcare application that connects patients with healthcare providers. The app facilitates appointment booking, pharmacy services, diagnostics, and ambulance services through an intuitive interface.

## Features
- Doctor appointment booking
- Pharmacy services
- Diagnostic test booking 
- Ambulance services
- Search functionality for doctors and specializations
- User profile management
- Real-time appointment scheduling

## Frontend (Flutter)

### Tech Stack
- Flutter SDK ^3.5.3
- Dart
- Provider for state management
- HTTP package for API integration

### Key Dependencies
- calendar_date_picker2: ^1.1.8
- day_night_time_picker: ^1.3.1
- intl: ^0.19.0
- font_awesome_flutter: ^10.8.0
- lucide_icons: ^0.257.0

### Setup Instructions
1. Install Flutter SDK
2. Clone the repository
3. Run `flutter pub get`
4. Configure environment variables
5. Run `flutter run` to start the app

### Project Structure


## Backend (Python)

### Tech Stack
- Python 3.9+
- Django framework
- Django REST framework
- PostgreSQL database
- Django authentication
- Gunicorn WSGI server

### Key Dependencies
- django
- djangorestframework
- django-cors-headers
- psycopg2-binary
- python-dotenv
- gunicorn
- whitenoise
- pillow

### Setup Instructions
1. Install Python 3.9+
2. Create and activate virtual environment
3. Install dependencies: `pip install -r requirements.txt`
4. Configure environment variables
5. Run migrations: `python manage.py migrate`
6. Create superuser: `python manage.py createsuperuser`
7. Start server: `python manage.py runserver`

### API Documentation
- Admin interface at `/admin`
- Django REST framework browsable API
- Authentication using Django's built-in auth
- RESTful endpoints for:
  - User management
  - Doctor profiles
  - Appointments
  - Medical records
  - Pharmacy orders
  - Diagnostic bookings
  - Ambulance requests

