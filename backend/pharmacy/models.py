from django.db import models

class Medicine(models.Model):
    id = models.IntegerField(primary_key=True)  # Matches your existing random ID
    name = models.CharField(max_length=255)
    price = models.DecimalField(max_digits=10, decimal_places=2)

    class Meta:
        db_table = 'medicine'  # Explicitly map to existing table

    def __str__(self):
        return f"{self.name} - ₹{self.price}"


class CartItem(models.Model):
    user_id = models.IntegerField()
    medicine = models.ForeignKey(Medicine, on_delete=models.CASCADE)
    quantity = models.PositiveIntegerField(default=1)
    added_at = models.DateTimeField(auto_now_add=True)

    class Meta:
        db_table = 'cart_item'

    def __str__(self):
        return f"User {self.user_id} - {self.medicine.name} x {self.quantity}"
