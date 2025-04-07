// doctor_info_bottom_sheet.dart
import 'package:flutter/material.dart';
import 'package:swasthya/screens/mycolors.dart';
class DoctorInfoBottomSheet extends StatelessWidget {
  final dynamic doctor;

  const DoctorInfoBottomSheet({super.key, required this.doctor});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      height: MediaQuery.of(context).size.height * 0.5,
      decoration:const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Text(
              doctor['name'],
              style: const TextStyle(
                color: MyColors.maincolor,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            "Specialization: ${doctor['specialization']}",
            style: const TextStyle(fontSize: 18, 
            fontWeight: FontWeight.w600,
            
            ),
          ),
          const SizedBox(height: 10),
          Text(
            "Career Path: ${doctor['career_path']}",
            style:const TextStyle(fontSize: 16,
            color: Colors.grey),
          ),
          const SizedBox(height: 10),
          Text(
            "Highlights: ${doctor['highlights']}",
            style: const TextStyle(fontSize: 16,
            color: Colors.grey),
          ),
          const SizedBox(height: 20),
          
        ],
      ),
    );
  }
}
