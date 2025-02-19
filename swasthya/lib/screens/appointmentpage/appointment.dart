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
  TextEditingController searchController = TextEditingController();
  List<dynamic> doctors = [];
  List<dynamic> filteredDoctors = [];
  bool isLoading = true;
  String errorMessage = '';
  void _showDatePicker(String doctorname,int doctorid) async {
    final DateTime? pickedDate = await showCustomDatePicker(context);
    if (pickedDate != null && pickedDate != selectedDate) {
      setState(() async {
        selectedDate = pickedDate;

        final String? selectedTime = await showModalBottomSheet<String>(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (BuildContext context) {
            return  Timepicker(
              doctorId: doctorid,
              selectedDate: pickedDate,
            );
          },
        );

        if (selectedTime != null) {
          
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
                doctorid: doctorid,
              );
            },
          );
        } else {
          
          showDialog(
            context: context,
            barrierDismissible:
                false, 
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
                      Navigator.of(context).pop(); 
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
          return  Timepicker(
             doctorId: doctorid,
              selectedDate: DateTime.now(),
          );
        },
      );

      if (selectedTime != null) {
        
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
              doctorid:doctorid,
            );
          },
        );
      } else {
        showDialog(
          context: context,
          barrierDismissible:
              false, 
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


  @override
  void initState() {
    super.initState();
    fetchDoctors();
    searchController.addListener(_filterDoctors);
  }



  void _filterDoctors() {
    String query = searchController.text.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        filteredDoctors = List.from(doctors);
      } else {
        filteredDoctors = doctors.where((doctor) {
          String name = doctor['name'].toLowerCase();
          String specialization = doctor['specialization'].toLowerCase();
          List<String> diseases = [
            doctor['disease1']?.toLowerCase() ?? '',
            doctor['disease2']?.toLowerCase() ?? '',
            doctor['disease3']?.toLowerCase() ?? '',
            doctor['disease4']?.toLowerCase() ?? '',
            doctor['disease5']?.toLowerCase() ?? '',
            doctor['disease6']?.toLowerCase() ?? '',
            doctor['disease7']?.toLowerCase() ?? '',
          ];

          return name.contains(query) || specialization.contains(query) || diseases.any((d) => d.contains(query));
        }).toList();
      }
    });
  }

  Future<void> fetchDoctors({String query = ""}) async {
  try {
    final response = await http.get(
      Uri.parse('${AppConfig.baseUrl}/docAppoint/doctorlist/?search=$query'),
    );

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
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.maincolor,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              flex: 3,
              child: Container(
                color: MyColors.maincolor,
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                    horizontal: 15), // Adds side spacing
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment:
                      MainAxisAlignment.center, // Centers content
                  children: [
                    const Text(
                      "Find your Doctor",
                      style: TextStyle(
                        fontSize: 28, // Slightly reduced for balance
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(
                        height: 15), // Space between title and search bar
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                            BorderRadius.circular(30), // Smooth rounded corners
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 6,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: TextField(
                        onChanged: (value) {
    fetchDoctors(query: value);  // Call API with search query
  },
                        decoration: InputDecoration(
                          hintText: "Search by Disease or Specialization",
                          hintStyle: TextStyle(color: Colors.grey.shade500),
                          prefixIcon:
                              const Icon(Icons.search, color: Colors.grey),
                          border: InputBorder.none, // Removes default underline
                          contentPadding:
                              const EdgeInsets.symmetric(vertical: 15),
                        ),
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 8,
              child: Container(
                padding: const EdgeInsets.only(top: 25),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(60),
                    topLeft: Radius.circular(60),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black, 
                      spreadRadius: 1, 
                      blurRadius: 8, 
                      offset: Offset(4, 4), 
                    ),
                  ],
                ),
                child: (() {
                  if (isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (errorMessage.isNotEmpty) {
                    return Center(
                      child: Text(errorMessage,
                          style: const TextStyle(color: Colors.red)),
                    );
                  } else if (doctors.isEmpty) {
                    return const Center(child: Text('No doctors found'));
                  } else {
                    return ListView.builder(
                      itemCount: doctors.length,
                      itemBuilder: (context, index) {
                        final doctor = doctors[index];
                        return Container(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 13, vertical: 5),
                          height: 180,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: MyColors.deepMutedTeal,
                              width: 1.8,
                            ),
                            borderRadius: BorderRadius.circular(25),
                            color: Colors.white,
                          ),
                          child: Stack(
                            children: [
                              Container(
                                padding: const EdgeInsets.only(
                                    top: 20.0, left: 20.0),
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
                                padding:
                                    const EdgeInsets.only(left: 90, top: 20),
                                margin: const EdgeInsets.only(left: 20),
                                child: Text(
                                  doctor['name'],
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                              Container(
                                padding:
                                    const EdgeInsets.only(left: 90, top: 22),
                                margin:
                                    const EdgeInsets.only(left: 20, top: 20),
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
                                    },
                                    borderRadius: BorderRadius.circular(25),
                                    splashColor: Colors.white.withOpacity(0.3),
                                    highlightColor:
                                        Colors.white.withOpacity(0.2),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 15, vertical: 10),
                                      decoration: BoxDecoration(
                                        color: MyColors.deepMutedTeal,
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: const Text(
                                        "Info",
                                        style: TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.bold,
                                          color: Color.fromARGB(
                                              255, 255, 255, 255),
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
                                      _showDatePicker(doctor['name'],doctor['id']),
                                  color: MyColors.deepMutedTeal,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        18), 
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 31,
                                      vertical: 10), 
                                  child: const Text(
                                    "Book",
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white, 
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
              ),
            )
          ],
        ),
      ),
    );
  }
}
