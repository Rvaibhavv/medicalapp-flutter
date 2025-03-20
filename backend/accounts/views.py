from django.contrib.auth.hashers import make_password
from django.http import JsonResponse
from django.views.decorators.csrf import csrf_exempt
import json
from django.contrib.auth.hashers import check_password
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
    
            return JsonResponse({
                "id": user.id,
                "name": user.name,
                "phone": user.phone,
                "message": "User registered successfully!"}, status=201)
        
        except Exception as e:
            print("Error:", str(e))  # Debugging print
            return JsonResponse({"error": str(e)}, status=400)

    return JsonResponse({"error": "Invalid request"}, status=400)



@csrf_exempt
def login_user(request):
    if request.method == 'POST':
        try:
            data = json.loads(request.body.decode('utf-8'))  # Ensure correct decoding
            print("Received Data:", data)  # Debugging

            email = data.get('email')
            password = data.get('password')

            user = UserProfile.objects.filter(email=email).first()

            if user:
                print(f"User Found: {user.email}")
                if check_password(password, user.password):  # Verify hashed password
                    response_data = {"message": "Login successful", "user_id": user.id, "name": user.name, "phone": user.phone}
                    return JsonResponse(response_data, status=200)
                else:
                    print("Password incorrect")
            else:
                print("User not found")

            return JsonResponse({"error": "Invalid email or password"}, status=401)

        except json.JSONDecodeError as e:
            print("JSON Decode Error:", str(e))
            return JsonResponse({"error": "Invalid JSON format"}, status=400)

        except Exception as e:
            print("Login Error:", str(e))
            return JsonResponse({"error": str(e)}, status=400)

    return JsonResponse({"error": "Invalid request"}, status=400)
