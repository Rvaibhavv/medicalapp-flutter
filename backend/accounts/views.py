from django.contrib.auth.hashers import make_password
from django.http import JsonResponse
from django.views.decorators.csrf import csrf_exempt
import json
from .models import UserProfile

@csrf_exempt
def register_user(request):
    if request.method == 'POST':
        try:
            data = json.loads(request.body)
            print("Received Data:", data)  # Debugging print

            # Create user profile
            user = UserProfile.objects.create(
                name=data['name'],
                dob=data['dob'],
                gender=data['gender'],
                phone=data['phone'],
                email=data['email'],
                password=make_password(data['password'])  # Hash password for security
            )

            print("User Created:", user)  # Debugging print

            return JsonResponse({"message": "User registered successfully!"}, status=201)
        
        except Exception as e:
            print("Error:", str(e))  # Debugging print
            return JsonResponse({"error": str(e)}, status=400)

    return JsonResponse({"error": "Invalid request"}, status=400)
