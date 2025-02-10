import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'datepicker.dart';
import 'doctorbottom.dart';
import 'timepicker.dart';
import 'paymentgateway.dart';
import '../mycolors.dart';
import '../../config.dart';

class AppointmentPage extends StatefulWidget {
  const AppointmentPage({super.key});

  @override
  _AppointmentPageState createState() => _AppointmentPageState();
}

class _AppointmentPageState extends State<AppointmentPage> {
  DateTime? selectedDate;

  // Inside your original file

  void _showDatePicker(String doctorname) async {
    final DateTime? pickedDate = await showCustomDatePicker(context);

    if (pickedDate != null && pickedDate != selectedDate) {
      setState(() async {
        selectedDate = pickedDate;

        // Show time picker and wait for the selected time
        final String? selectedTime = await showModalBottomSheet<String>(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (BuildContext context) {
            return Timepicker();
          },
        );

        if (selectedTime != null) {
          print('Selected date: $selectedDate');
          print('Selected time: $selectedTime');
          print('Doctor name: $doctorname');
          // ignore: unused_local_variable
          final String? payment = await showModalBottomSheet<String>(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            builder: (BuildContext context) {
              return Paymentgateway(
                selectedDate: selectedDate,
                selectedTime: selectedTime,
                doctorname: doctorname,
              );
            },
          );
        } else {
          print('No time selected.');
          showDialog(
            context: context,
            barrierDismissible:
                false, // Prevents dismissing by tapping outside the dialog
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text(
                  'No Time Selected',
                  style: TextStyle(color: MyColors.maincolor),
                ),
                content: const Text('Please select a time to proceed.'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(); // Close the dialog
                    },
                    child: const Text('OK'),
                  ),
                ],
              );
            },
          );
        }
      });
    } else {
      selectedDate = DateTime.now();

      final String? selectedTime = await showModalBottomSheet<String>(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (BuildContext context) {
          return Timepicker();
        },
      );

      if (selectedTime != null) {
        print('Selected date: $selectedDate');
        print('Selected time: $selectedTime');
        print('Doctor name: $doctorname');
// ignore: unused_local_variable
        final String? payment = await showModalBottomSheet<String>(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (BuildContext context) {
            return Paymentgateway(
              selectedDate: selectedDate,
              selectedTime: selectedTime,
              doctorname: doctorname,
            );
          },
        );
      } else {
        print('No time selected.');
        showDialog(
          context: context,
          barrierDismissible:
              false, // Prevents dismissing by tapping outside the dialog
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text(
                'No Time Selected',
                style: TextStyle(color: MyColors.maincolor),
              ),
              content: const Text('Please select a time to proceed.'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Close the dialog
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
      }
    }
  }

  List<dynamic> doctors = [];
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    fetchDoctors();
  }

  Future<void> fetchDoctors() async {
    try {
      final response = await http
          .get(Uri.parse('${AppConfig.baseUrl}/docAppoint/doctorlist'));
      print('Response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        setState(() {
          doctors = jsonDecode(response.body);
          isLoading = false;
        });
      } else {

        
        setState(() {
          errorMessage = 'Failed to load doctors. Please try again later.';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Error fetching data: $e';
        isLoading = false;
      });
    }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              flex: 1,
              child: Container(
                width: double.infinity,
                child: Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        decoration:const BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: MyColors.maincolor, // Border color
                              width: 1.8,
                            ),
                          ),
                        ),
                        padding:const EdgeInsets.fromLTRB(13, 17, 10, 10),
                        child: const Text(
                          "Select The Doctor",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: MyColors.maincolor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              height: 0.1,
              color: Colors.grey,
            ),
            Expanded(
              flex: 9,
              child: (() {
                if (isLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (errorMessage.isNotEmpty) {
                  return Center(
                    child:
                        Text(errorMessage, style: const TextStyle(color: Colors.red)),
                  );
                } else if (doctors.isEmpty) {
                  return const Center(child: Text('No doctors found'));
                } else {
                  return ListView.builder(
                    itemCount: doctors.length,
                    itemBuilder: (context, index) {
                      final doctor = doctors[index];
                      return Container(
                        margin:
                            const EdgeInsets.symmetric(horizontal: 13, vertical: 5),
                        height: 180,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color:MyColors.deepMutedTeal,
                            width: 1.8,
                          ),
                          borderRadius: BorderRadius.circular(25),
                          color: Colors.white,
                        ),
                        child: Stack(
                          children: [
                            Container(
                              padding:const EdgeInsets.only(top: 20.0, left: 20.0),
                              child: Align(
                                alignment: Alignment.topLeft,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(90),
                                  child: Image.asset(
                                    'assets/images/doctor1.jpg',
                                    fit: BoxFit.cover,
                                    height: 80,
                                    width: 80,
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              padding:const EdgeInsets.only(left: 90, top: 20),
                              margin:const EdgeInsets.only(left: 20),
                              child: Text(
                                doctor['name'],
                                style:const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.only(left: 90, top: 22),
                              margin: const EdgeInsets.only(left: 20, top: 20),
                              child: Text(
                                doctor['specialization'],
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 70,
                              left: 108,
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  onTap: () {
                                    showModalBottomSheet(
                                      context: context,
                                      isScrollControlled: true,
                                      backgroundColor: Colors.transparent,
                                      builder: (BuildContext context) {
                                        return DoctorInfoBottomSheet(
                                            doctor: doctor);
                                      },
                                    );
                                    print("Info button clicked");
                                  },
                                  borderRadius: BorderRadius.circular(25),
                                  splashColor: Colors.white.withOpacity(0.3),
                                  highlightColor: Colors.white.withOpacity(0.2),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 15, vertical: 10),
                                    decoration: BoxDecoration(
                                      color: MyColors.deepMutedTeal,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child:const Text(
                                      "Info",
                                      style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold,
                                        color:
                                            Color.fromARGB(255, 255, 255, 255),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 20,
                              right: 20,
                              child: MaterialButton(
                                onPressed: () =>
                                    _showDatePicker(doctor['name']),
                                color: MyColors.deepMutedTeal,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      18), // Curved border
                                ),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 31,
                                    vertical: 10), // Adjust size
                                child: const Text(
                                  "Book",
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white, // White text color
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                }
              })(),
            )
          ],
        ),
      ),
    );
  }
}
