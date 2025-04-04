import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'mycolors.dart';

class AmbulancePage extends StatelessWidget {
  const AmbulancePage({super.key});

  final String ambulanceNumber = "9660208666"; // Update this if your backend gives a number

  Future<void> _callAmbulance() async {
    final Uri phoneUri = Uri(scheme: 'tel', path: ambulanceNumber);
    if (await canLaunchUrl(phoneUri)) {
      await launchUrl(phoneUri);
    } else {
      throw 'Could not launch $ambulanceNumber';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Call Ambulance"),
        backgroundColor: MyColors.maincolor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.local_hospital, size: 100, color: MyColors.maincolor),
            const SizedBox(height: 24),
            const Text(
              "Need emergency medical help?",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            const Text(
              "Tap the button below to call an ambulance instantly.",
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
            ElevatedButton.icon(
              onPressed: _callAmbulance,
              icon: const Icon(Icons.call),
              label: Text("Call $ambulanceNumber",style: const  TextStyle(color: Colors.white),),
              style: ElevatedButton.styleFrom(
                backgroundColor: MyColors.maincolor,
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
