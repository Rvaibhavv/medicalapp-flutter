from rest_framework import viewsets, filters
from .models import Doctor
from .serializers import DoctorSerializer
from rest_framework.decorators import api_view
from rest_framework.response import Response
from rest_framework import status
from .models import Appointment, UserProfile, Doctor
from django.http import JsonResponse
from datetime import date
from .models import Appointment
import json
from django.views.decorators.csrf import csrf_exempt
from datetime import datetime



class DoctorViewSet(viewsets.ModelViewSet):
    queryset = Doctor.objects.all()
    serializer_class = DoctorSerializer  # Keep this
    filter_backends = [filters.SearchFilter]
    search_fields = [
        'name', 
        'specialization', 
        'disease1', 
        'disease2', 
        'disease3', 
        'disease4', 
        'disease5', 
        'disease6', 
        'disease7'
    ] 
    
    
     # Enables search across these fields



@api_view(['POST'])
def book_appointment(request):
    user_id = request.data.get('user_id')
    doctor_id = request.data.get('doctor_id')
    appointment_date = request.data.get('appointment_date')
    appointment_time = request.data.get('appointment_time')

    if not all([user_id, doctor_id, appointment_date, appointment_time]):
        return Response({"error": "Missing required fields"}, status=status.HTTP_400_BAD_REQUEST)

    try:
        user = UserProfile.objects.get(id=user_id)
        doctor = Doctor.objects.get(id=doctor_id)
    except (UserProfile.DoesNotExist, Doctor.DoesNotExist):
        return Response({"error": "Invalid user or doctor ID"}, status=status.HTTP_404_NOT_FOUND)

    # Save appointment in the database, including doctor's name
    appointment = Appointment.objects.create(
        user=user,
        doctor=doctor,
        doctor_name=doctor.name,  # Storing the doctor's name
        appointment_date=appointment_date,
        appointment_time=appointment_time
    )

    return Response({
        "message": "Appointment successfully booked!",
        "doctor_name": doctor.name  # Return doctor's name in response
    }, status=status.HTTP_201_CREATED)

def get_upcoming_appointments(request):
    appointments = Appointment.objects.filter(appointment_date__gte=date.today()).order_by("appointment_date")
    appointment_list = [
        {
            "user_id": appointment.user_id,
            "doctor_name": appointment.doctor_name,
            "appointment_date": appointment.appointment_date.strftime("%Y-%m-%d"),
            "appointment_time": appointment.appointment_time,
        }
        for appointment in appointments
    ]

    return JsonResponse(appointment_list, safe=False)




@csrf_exempt
def get_booked_slots(request):
    if request.method != "POST":
        return JsonResponse({'error': 'Invalid request method'}, status=405)

    try:
        data = json.loads(request.body)  # Read JSON body
        doctor_id = data.get('doctor_id')
        date_str = data.get('date')  # Example: "2025-02-19"

        if not doctor_id or not date_str:
            return JsonResponse({'error': 'Missing parameters'}, status=400)

        # Convert string date to Python date object
        appointment_date = datetime.strptime(date_str, "%Y-%m-%d").date()

        # Fetch booked slots from the database using date object
        booked_slots = list(Appointment.objects.filter(doctor_id=doctor_id, appointment_date=appointment_date)
                            .values_list('appointment_time', flat=True))

        return JsonResponse({'booked_slots': booked_slots})

    except json.JSONDecodeError:
        return JsonResponse({'error': 'Invalid JSON'}, status=400)
    except ValueError:
        return JsonResponse({'error': 'Invalid date format, expected YYYY-MM-DD'}, status=400)
