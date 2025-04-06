from django.urls import path
from .views import MedicineListView, AddToCartView, CartListView, RemoveCartItemView,clear_cart

urlpatterns = [
    path('medicines/', MedicineListView.as_view(), name='medicine-list'),
    path('add-to-cart/', AddToCartView.as_view(), name='add-to-cart'),
    path('cart/', CartListView.as_view(), name='cart-items'),
    path('cart/<int:pk>/', RemoveCartItemView.as_view(), name='remove-cart-item'),
    path('clear-cart/', clear_cart),

]
