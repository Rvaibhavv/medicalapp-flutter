import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:swasthya/screens/customnavbar.dart'; // Import the custom navbar

class Paymentgateway extends StatefulWidget {
  final DateTime? selectedDate;
  final String selectedTime;
  final String doctorname;

  const Paymentgateway({
    Key? key,
    required this.selectedDate,
    required this.selectedTime,
    required this.doctorname,
  }) : super(key: key);

  @override
  State<Paymentgateway> createState() => _PaymentgatewayState();
}



class _PaymentgatewayState extends State<Paymentgateway> {
  @override
  Widget build(BuildContext context) {
    // Format the selected date
    String formattedDate = widget.selectedDate != null
        ? DateFormat('d MMMM yyyy').format(widget.selectedDate!)
        : 'No date selected'; // Format the date as "d MMMM yyyy"

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
              margin: const EdgeInsets.all(16.0), // Add margin to create spacing around the box
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.white,  // Background color of the box
                borderRadius: BorderRadius.circular(12.0),  // Rounded corners
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),  // Subtle shadow color
                    spreadRadius: 1,  // Spread of shadow
                    blurRadius: 2,  // Blur effect
                    offset: const Offset(0, 1),  // Shadow position
                  ),
                ],
                border: Border.all(
                  color: Colors.grey.shade300,  // Light grey border
                  width: 1,  // Border width
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Booking Summary',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,  // Darker color for readability
                    ),
                  ),
                  const Divider(thickness: 1, color: Colors.grey),  // Adds a separator line
                  const SizedBox(height: 10),
                  Text(
                    'Doctor Name: ${widget.doctorname}',
                    style: const TextStyle(fontSize: 18, color: Colors.black54),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Appointment Date: $formattedDate', // Display formatted date
                    style: const TextStyle(fontSize: 18, color: Colors.black54),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Appointment Time: ${widget.selectedTime}',
                    style: const TextStyle(fontSize: 18, color: Colors.black54),
                  ),
                ],
              ),
            ),

            // Payment Details
            Container(
              margin: const EdgeInsets.all(16.0), // Add margin to create spacing around the box
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.white,  // Background color of the box
                borderRadius: BorderRadius.circular(12.0),  // Rounded corners
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),  // Subtle shadow color
                    spreadRadius: 1,  // Spread of shadow
                    blurRadius: 2,  // Blur effect
                    offset: const Offset(0, 1),  // Shadow position
                  ),
                ],
                border: Border.all(
                  color: Colors.grey.shade300,  // Light grey border
                  width: 1,  // Border width
                ),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Payment Details',
                    style:  TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,  // Darker color for readability
                    ),
                  ),
                   Divider(thickness: 1, color: Colors.grey),  // Adds a separator line
                   SizedBox(height: 10),
                  Text(
                    'Consultation Fee: ₹500',
                    style:  TextStyle(fontSize: 18, color: Colors.black54),
                  ),
                   SizedBox(height: 10),
                  Text(
                    'Service Charge: ₹50',
                    style:  TextStyle(fontSize: 18, color: Colors.black54),
                  ),
                   SizedBox(height: 10),
                  Text(
                    'Total Amount: ₹550',
                    style:  TextStyle(
                        fontSize: 18,
                        color: Colors.black87,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
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
        'Select Payment Method',
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
      const Divider(thickness: 1, color: Colors.grey),
      const SizedBox(height: 10),
      DropdownButton<String>(
        value: 'Credit Card',  // Initial value
        items:const [
          DropdownMenuItem<String>(
            value: 'Credit Card',
            child: Text('Credit Card'),
          ),
          DropdownMenuItem<String>(
            value: 'Debit Card',
            child: Text('Debit Card'),
          ),
          DropdownMenuItem<String>(
            value: 'UPI',
            child: Text('UPI'),
          ),
        ],
        onChanged: (String? newValue) {
          // Handle the selection here
        },
      ),
    ],
  ),
)

          ],
        ),
      ),
    );
  }
}
