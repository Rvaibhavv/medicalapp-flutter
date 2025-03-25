from django.urls import path
from .views import MedicineListView

urlpatterns = [
    path('medicines/', MedicineListView.as_view(), name='medicine-list'),
]
