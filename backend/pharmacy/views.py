from rest_framework.views import APIView
from rest_framework.response import Response
from .models import Medicine
from .serializers import MedicineSerializer

class MedicineListView(APIView):
    def get(self, request):
        medicines = Medicine.objects.all()
        serializer = MedicineSerializer(medicines, many=True)
        return Response(serializer.data)


from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework import status
from .models import CartItem
from .serializers import CartItemSerializer

class AddToCartView(APIView):
    def post(self, request):
        serializer = CartItemSerializer(data=request.data)
        if serializer.is_valid():
            serializer.save()
            return Response({"message": "Item added to cart!"}, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)


class CartListView(APIView):
    def get(self, request):
        user_id = request.query_params.get('user_id')
        if not user_id:
            return Response({"error": "user_id is required"}, status=400)
        cart_items = CartItem.objects.filter(user_id=user_id)
        serializer = CartItemSerializer(cart_items, many=True)
        return Response(serializer.data)

class RemoveCartItemView(APIView):
    def delete(self, request, pk):
        try:
            item = CartItem.objects.get(pk=pk)
            item.delete()
            return Response(status=status.HTTP_204_NO_CONTENT)
        except CartItem.DoesNotExist:
            return Response({"error": "Item not found"}, status=status.HTTP_404_NOT_FOUND)