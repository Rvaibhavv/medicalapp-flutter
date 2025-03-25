from rest_framework.views import APIView
from rest_framework.response import Response
from .models import Medicine
from .serializers import MedicineSerializer

class MedicineListView(APIView):
    def get(self, request):
        medicines = Medicine.objects.all()
        serializer = MedicineSerializer(medicines, many=True)
        return Response(serializer.data)
