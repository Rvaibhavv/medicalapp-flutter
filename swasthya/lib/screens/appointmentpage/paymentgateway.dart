import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:swasthya/screens/customnavbar.dart';
import '../mycolors.dart';
import '../../user_provider.dart';
import 'package:provider/provider.dart';
import '../../config.dart';
import '../bottomnav.dart';

class Paymentgateway extends StatefulWidget {
  final DateTime? selectedDate;
  final String selectedTime;
  final int doctorid;
  final String doctorname;

  const Paymentgateway({
    Key? key,
    required this.selectedDate,
    required this.selectedTime,
    required this.doctorname,
    required this.doctorid,
  }) : super(key: key);

  @override
  State<Paymentgateway> createState() => _PaymentgatewayState();
}

class _PaymentgatewayState extends State<Paymentgateway> {
  bool _isLoading = false;

  Future<void> bookAppointment(int userid) async {
    setState(() {
      _isLoading = true;
    });

    try {
      final response = await http.post(
        Uri.parse('${AppConfig.baseUrl}/docAppoint/book-appointment/'), // Update this URL
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'user_id': userid,
          'doctor_id': widget.doctorid,
          'doctor_name': widget.doctorname,
          'appointment_date': DateFormat('yyyy-MM-dd').format(widget.selectedDate!),
          'appointment_time': widget.selectedTime,
        }),
      );

      if (response.statusCode == 201) {
          print('Appointment booked successfully!');
        Navigator.pop(context); // Go back after booking
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to book appointment!')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    int userid = Provider.of<UserProvider>(context).userId;
    String formattedDate = widget.selectedDate != null
        ? DateFormat('d MMMM yyyy').format(widget.selectedDate!)
        : 'No date selected';

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            CustomNavBar(title: "Payment"),

            // Booking Summary
            Container(
              margin: const EdgeInsets.all(16.0),
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 2,
                    offset: const Offset(0, 1),
                  ),
                ],
                border: Border.all(color: Colors.grey.shade300, width: 1),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Booking Summary',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black87),
                  ),
                  const Divider(thickness: 1, color: Colors.grey),
                  const SizedBox(height: 10),
                  Text('Doctor Name: ${widget.doctorname}', style: const TextStyle(fontSize: 18, color: Colors.black54)),
                  const SizedBox(height: 10),
                  Text('Appointment Date: $formattedDate', style: const TextStyle(fontSize: 18, color: Colors.black54)),
                  const SizedBox(height: 10),
                  Text('Appointment Time: ${widget.selectedTime}', style: const TextStyle(fontSize: 18, color: Colors.black54)),
                ],
              ),
            ),

            // Payment Details
            Container(
              margin: const EdgeInsets.all(16.0),
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 2,
                    offset: const Offset(0, 1),
                  ),
                ],
                border: Border.all(color: Colors.grey.shade300, width: 1),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Payment Details',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black87),
                  ),
                  Divider(thickness: 1, color: Colors.grey),
                  SizedBox(height: 10),
                  Text('Consultation Fee: ₹500', style: TextStyle(fontSize: 18, color: Colors.black54)),
                  SizedBox(height: 10),
                  Text('Service Charge: ₹50', style: TextStyle(fontSize: 18, color: Colors.black54)),
                  SizedBox(height: 10),
                  Text('Total Amount: ₹550', style: TextStyle(fontSize: 18, color: Colors.black87, fontWeight: FontWeight.bold)),
                ],
              ),
            ),

            // Pay Now Button
            Align(
              alignment: Alignment.centerRight,
              child: Container(
                width: 150,
                margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: MaterialButton(
  onPressed: _isLoading
      ? null
      : () async {
          await bookAppointment(userid);
          Navigator.pushReplacement(
            context,
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) =>
                  const BottomNavScreen(startIndex: 0),
              transitionDuration: Duration.zero, // No animation duration
              reverseTransitionDuration: Duration.zero, // No reverse animation
            ),
          );
        },
  color: MyColors.maincolor,
  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
  padding: const EdgeInsets.symmetric(vertical: 14),
  child: _isLoading
      ? const CircularProgressIndicator(color: Colors.white)
      : const Text(
          'Pay Now',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
)

              ),
            )
          ],
        ),
      ),
    );
  }
}
