import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:provider/provider.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

import '../../config.dart';
import '../../user_provider.dart';
import '../bottomnav.dart';
import '../mycolors.dart';
import '../customnavbar.dart';

class Paymentgateway extends StatefulWidget {
  final DateTime? selectedDate;
  final String selectedTime;
  final int doctorid;
  final String doctorname;

  const Paymentgateway({
    super.key,
    required this.selectedDate,
    required this.selectedTime,
    required this.doctorname,
    required this.doctorid,
  });

  @override
  State<Paymentgateway> createState() => _PaymentgatewayState();
}

class _PaymentgatewayState extends State<Paymentgateway> {
  late Razorpay _razorpay;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  @override
  void dispose() {
    _razorpay.clear();
    super.dispose();
  }

  void _startPayment(int userId) {
    var options = {
      'key': AppConfig.razorpayKey,
      'amount': 55000, // ₹550 in paise
      'currency': 'INR',
      'name': 'Swasthya',
      'description': 'Doctor Appointment',
      'prefill': {'contact': '9876543210', 'email': 'user@example.com'},
      'notes': {
        'user_id': userId,
        'doctor_id': widget.doctorid,
      },
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint('Error: $e');
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) async {
    int userId = Provider.of<UserProvider>(context, listen: false).userId;

    // Call backend to book appointment
    await bookAppointment(userId);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Payment Successful")),
    );

    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const BottomNavScreen(startIndex: 0),
        transitionDuration: Duration.zero,
        reverseTransitionDuration: Duration.zero,
      ),
    );
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Payment Failed")),
    );
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    debugPrint("External Wallet: ${response.walletName}");
  }

  Future<void> bookAppointment(int userid) async {
    setState(() => _isLoading = true);

    try {
      final response = await http.post(
        Uri.parse('${AppConfig.baseUrl}/docAppoint/book-appointment/'),
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
        debugPrint('Appointment booked!');
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

    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    int userId = Provider.of<UserProvider>(context).userId;
    String formattedDate = widget.selectedDate != null
        ? DateFormat('d MMMM yyyy').format(widget.selectedDate!)
        : 'No date selected';

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CustomNavBar(title: "Payment"),
            const SizedBox(height: 10),
            // Booking Summary
            _buildSummarySection(formattedDate),
            // Payment Details
            _buildPaymentDetails(),
            // Pay Now Button
            Align(
              alignment: Alignment.centerRight,
              child: Container(
                width: 150,
                margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: MaterialButton(
                  onPressed: _isLoading ? null : () => _startPayment(userId),
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
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildSummarySection(String formattedDate) {
    return Container(
      margin: const EdgeInsets.all(16.0),
      padding: const EdgeInsets.all(16.0),
      decoration: _cardBoxDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Booking Summary', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black87)),
          const Divider(thickness: 1, color: Colors.grey),
          const SizedBox(height: 10),
          Text('Doctor Name: ${widget.doctorname}', style: const TextStyle(fontSize: 18, color: Colors.black54)),
          const SizedBox(height: 10),
          Text('Appointment Date: $formattedDate', style: const TextStyle(fontSize: 18, color: Colors.black54)),
          const SizedBox(height: 10),
          Text('Appointment Time: ${widget.selectedTime}', style: const TextStyle(fontSize: 18, color: Colors.black54)),
        ],
      ),
    );
  }

  Widget _buildPaymentDetails() {
    return Container(
      margin: const EdgeInsets.all(16.0),
      padding: const EdgeInsets.all(16.0),
      decoration: _cardBoxDecoration(),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Payment Details', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black87)),
          Divider(thickness: 1, color: Colors.grey),
          SizedBox(height: 10),
          Text('Consultation Fee: ₹500', style: TextStyle(fontSize: 18, color: Colors.black54)),
          SizedBox(height: 10),
          Text('Service Charge: ₹50', style: TextStyle(fontSize: 18, color: Colors.black54)),
          SizedBox(height: 10),
          Text('Total Amount: ₹550', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87)),
        ],
      ),
    );
  }

  BoxDecoration _cardBoxDecoration() {
    return BoxDecoration(
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
    );
  }
}
