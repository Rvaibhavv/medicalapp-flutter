import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class UpiPaymentPage extends StatelessWidget {
  const UpiPaymentPage({super.key});

  final String receiverUpiId = "rvaibhavr@ybl"; // Your UPI ID
  final String receiverName = "Vaibhav Raj";
  final double amount = 9.0;

  void _launchUpiPayment(BuildContext context) async {
    final Uri upiUri = Uri.parse(
      'upi://pay?pa=$receiverUpiId&pn=$receiverName&am=$amount&cu=INR&tr=TXN123456&tn=Medicine+Payment',
    );

    if (await canLaunchUrl(upiUri)) {
      await launchUrl(upiUri, mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Could not launch UPI app")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pay via UPI"),
        backgroundColor: Colors.teal,
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () => _launchUpiPayment(context),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.teal,
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 30),
          ),
          child: Text("Pay ₹$amount", style: const TextStyle(fontSize: 16, color: Colors.white)),
        ),
      ),
    );
  }
}
