import 'package:flutter/material.dart';
import 'Home/home.dart';
import 'virtualdoctor.dart';
import 'settings.dart';
import 'appointmentpage/appointment.dart';
import 'mycolors.dart';
import 'pharmacy/pharmacy.dart';

class BottomNavScreen extends StatefulWidget {
  final int startIndex;

  const BottomNavScreen({Key? key, this.startIndex = 0}) : super(key: key);

  @override
  _BottomNavScreenState createState() => _BottomNavScreenState();
}

class _BottomNavScreenState extends State<BottomNavScreen> {
  late int _currentIndex;
  bool _isCenterButtonSelected = false;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.startIndex;
  }

  final List<Widget> _pages = [
    HomePage(),
    PharmacyPage(),
    AppointmentPage(),
    VirtualDoctor(),
    SettingsPage(),
  ];

  void _changePage(int index) {
    setState(() {
      _currentIndex = index;
      _isCenterButtonSelected = index == 2;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: Stack(
        clipBehavior: Clip.none,
        children: [
          BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            currentIndex: _currentIndex,
            backgroundColor: Colors.white,
            onTap: (index) {
              if (index != 2) {
                _changePage(index);
              }
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
                icon: SizedBox.shrink(),
                label: '',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.medical_information_outlined),
                label: 'Diagnostics',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.medical_services_outlined),
                label: 'Ambulance',
              ),
            ],
            selectedItemColor: MyColors.maincolor,
            unselectedItemColor: Colors.black,
            showUnselectedLabels: true,
          ),
          Positioned(
            bottom: 3,
            left: MediaQuery.of(context).size.width / 2 - 35,
            child: GestureDetector(
              onTap: () => _changePage(2),
              child: Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                  border: Border.all(
                    color: _isCenterButtonSelected ? MyColors.maincolor : Colors.transparent,
                    width: 1.8,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.add,
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
