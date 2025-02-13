from django.db import models

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
