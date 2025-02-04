from rest_framework import serializers
from .models import Doctor


class DoctorSerializer(serializers.ModelSerializer):
    class Meta:
        model = Doctor
        fields = '__all__'  # You can specify the fields you want to include, e.g., ['id', 'name', 'specialization']


