from django.db import models

class Doctor(models.Model):
    name = models.CharField(max_length=100)
    specialization = models.CharField(max_length=100)
    profile_description = models.TextField()
    career_path = models.TextField()
    highlights = models.TextField()
    age = models.IntegerField()
    gender = models.CharField(max_length=10)  # Consider using choices for gender

    class Meta:
        db_table = 'doctor'  # Set the table name to 'doctor'

    def __str__(self):
        return self.name  




    