# docAppoint/urls.py
from django.urls import path, include
from rest_framework.routers import DefaultRouter
from .views import  DoctorViewSet,book_appointment,get_upcoming_appointments,get_booked_slots
router = DefaultRouter()
router.register(r'doctorlist', DoctorViewSet, basename='doctor')




urlpatterns = [
    path('', include(router.urls)),
    path('book-appointment/', book_appointment, name='book_appointment'),
    path('api/appointments/', get_upcoming_appointments, name='get_appointments'),
    path('booked-slots/', get_booked_slots, name='get_booked_slots'),
]
