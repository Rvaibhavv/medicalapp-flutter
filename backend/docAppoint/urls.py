# docAppoint/urls.py
from django.urls import path, include
from rest_framework.routers import DefaultRouter
from .views import  DoctorViewSet
router = DefaultRouter()
router.register(r'doctorlist', DoctorViewSet, basename='doctor')




urlpatterns = [
    path('', include(router.urls)),
]
