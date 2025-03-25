from django.db import models

class Medicine(models.Model):
    id = models.IntegerField(primary_key=True)  # Matches your existing random ID
    name = models.CharField(max_length=255)
    price = models.DecimalField(max_digits=10, decimal_places=2)

    class Meta:
        db_table = 'medicine'  # Explicitly map to existing table

    def __str__(self):
        return f"{self.name} - ₹{self.price}"
