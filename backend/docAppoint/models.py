from django.db import models
from accounts.models import UserProfile
class Doctor(models.Model):
    name = models.CharField(max_length=100)
    specialization = models.CharField(max_length=100)
    profile_description = models.TextField()
    career_path = models.TextField()
    highlights = models.TextField()
    age = models.IntegerField()
    gender = models.CharField(max_length=10)  

    # Existing disease fields
    disease1 = models.CharField(max_length=100, blank=True, null=True)
    disease2 = models.CharField(max_length=100, blank=True, null=True)
    disease3 = models.CharField(max_length=100, blank=True, null=True)
    disease4 = models.CharField(max_length=100, blank=True, null=True)
    disease5 = models.CharField(max_length=100, blank=True, null=True)
    disease6 = models.CharField(max_length=100, blank=True, null=True)
    disease7 = models.CharField(max_length=100, blank=True, null=True)

    class Meta:
        db_table = 'doctor'  

    def __str__(self):
        return self.name



class Appointment(models.Model):
    user = models.ForeignKey(UserProfile, on_delete=models.CASCADE)
    doctor = models.ForeignKey(Doctor, on_delete=models.CASCADE)
    doctor_name = models.CharField(max_length=255)  # New field to store doctor's name
    appointment_date = models.DateField()
    appointment_time = models.CharField(max_length=255)
    created_at = models.DateTimeField(auto_now_add=True)
    class Meta:
        db_table = 'appointment'

    def __str__(self):
        return f"{self.user.user.username} - {self.doctor_name} on {self.appointment_date} at {self.appointment_time}"
