import 'package:flutter/material.dart';
import 'home.dart';
import 'search.dart';
import 'Profile.dart';
import 'settings.dart';
import 'appointmentpage/appointment.dart';
import 'mycolors.dart';


class BottomNavScreen extends StatefulWidget {
  

  @override
  _BottomNavScreenState createState() => _BottomNavScreenState();
}

class _BottomNavScreenState extends State<BottomNavScreen> {
  int _currentIndex = 0; // Tracks the selected tab
  bool _isCenterButtonSelected =
      false; // Tracks whether the center button is selected

  final List<Widget> _pages = [
    HomePage(), // Index 0
    SearchPage(), // Index 1
    AppointmentPage(),
    ProfilePage(), // Index 3
    SettingsPage(), // Index 4
    // Index 5 (for the center button)
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex], // Displays the selected page
      bottomNavigationBar: Stack(
        clipBehavior: Clip.none, // Allows overflowing widgets
        children: [
          BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            currentIndex: _currentIndex,
            backgroundColor: Colors.white, // Set background color to white
            onTap: (index) {
              setState(() {
                if (index != 2) {
                  _currentIndex = index;
                  _isCenterButtonSelected =
                      false; // Reset center button state when tapping non-center
                }
              });
            },
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home_outlined),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.medication_outlined),
                label: 'Pharmacy',
              ),
              BottomNavigationBarItem(
                icon: SizedBox.shrink(), // Placeholder for the bulged icon
                label: '',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.medical_information_outlined),
                label: 'Diagnostics',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.medical_services_outlined), // Outlined ambulance icon
                label: 'Ambulance',
              ),
            ],
            selectedItemColor: MyColors.maincolor,
            unselectedItemColor: Colors.black,
            showUnselectedLabels: true,
          ),
          Positioned(
            bottom: 25, // Adjust the position to make the icon bulge upwards
            left: MediaQuery.of(context).size.width / 2 - 35, // Center the icon
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _currentIndex =
                      2; // Set index for the center button to AppointmentPage
                  _isCenterButtonSelected =
                      !_isCenterButtonSelected; // Toggle the selected state
                });
              },
              child: Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                  border: Border.all(
                    color: _isCenterButtonSelected
                        ? MyColors.maincolor // Border color when selected
                        : Colors.transparent, // No border when not selected
                    width: 1.8,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 8,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.add, // Hollow plus icon
                  size: 40,
                  color: MyColors.maincolor,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
