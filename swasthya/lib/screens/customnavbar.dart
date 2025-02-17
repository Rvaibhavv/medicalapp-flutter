import 'package:flutter/material.dart';
import 'mycolors.dart'; // Import the color palette

class CustomNavBar extends StatelessWidget {
  final String title;  // Title to be passed to the custom navbar

  CustomNavBar({required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100, // Height of the navbar
      padding:const EdgeInsets.only(top: 40,bottom :10,left:13), // Adjust for status bar height
      color: MyColors.maincolor, // Background color of the navbar
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,  // To space out the title and actions
        children: [
          
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          
        ],
      ),
    );
  }
}


