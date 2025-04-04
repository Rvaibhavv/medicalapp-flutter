from rest_framework import serializers
from .models import Medicine, CartItem

class MedicineSerializer(serializers.ModelSerializer):
    class Meta:
        model = Medicine
        fields = ['id', 'name', 'price']


class CartItemSerializer(serializers.ModelSerializer):
    medicine_name = serializers.CharField(source='medicine.name', read_only=True)
    medicine_price = serializers.DecimalField(source='medicine.price', max_digits=10, decimal_places=2, read_only=True)

    class Meta:
        model = CartItem
        fields = ['id', 'user_id', 'medicine', 'quantity', 'medicine_name', 'medicine_price']
