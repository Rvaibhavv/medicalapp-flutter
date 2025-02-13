from rest_framework import viewsets, filters
from .models import Doctor
from .serializers import DoctorSerializer

class DoctorViewSet(viewsets.ModelViewSet):
    queryset = Doctor.objects.all()
    serializer_class = DoctorSerializer  # Keep this
    filter_backends = [filters.SearchFilter]
    search_fields = [
        'name', 
        'specialization', 
        'disease1', 
        'disease2', 
        'disease3', 
        'disease4', 
        'disease5', 
        'disease6', 
        'disease7'
    ]  # Enables search across these fields
