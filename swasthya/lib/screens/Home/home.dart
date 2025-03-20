import 'package:flutter/material.dart';
import 'package:swasthya/screens/bottomnav.dart';
import 'package:swasthya/screens/mycolors.dart';
import '../../user_provider.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import '../../config.dart';
import 'package:http/http.dart' as http;

Future<List<Appointment>> fetchAppointments() async {
  final response = await http.get(
    Uri.parse('${AppConfig.baseUrl}/docAppoint/api/appointments/'),
  );

  if (response.statusCode == 200) {
    List<dynamic> data = json.decode(response.body);

    return data.map((json) => Appointment.fromJson(json)).toList();
  } else {
    throw Exception('Failed to load appointments');
  }
}

class Appointment {
  final String doctorName;
  final int userId;
  final String date;
  final String time;

  Appointment(
      {required this.doctorName,
      required this.userId,
      required this.date,
      required this.time});

  factory Appointment.fromJson(Map<String, dynamic> json) {
    return Appointment(
      doctorName: json['doctor_name'],
      userId: json['user_id'],
      date: json['appointment_date'],
      time: json['appointment_time'],
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    String username = Provider.of<UserProvider>(context).userName;
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Welcome back,',
                style: TextStyle(color: Colors.white, fontSize: 13)),
            Text('$username',
                style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 22)),
          ],
        ),
        automaticallyImplyLeading: false,
        backgroundColor: MyColors.maincolor,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const CircleAvatar(
              backgroundColor: Colors.white,
              child:
                  Icon(Icons.settings_outlined, color: MyColors.deepTealGreen),
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: const CircleAvatar(
              backgroundColor: Colors.white,
              child:
                  Icon(Icons.person_2_outlined, color: MyColors.deepTealGreen),
            ),
          ),
        ],
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              flex: 3,
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(100),
                  ),
                  color: MyColors.maincolor,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Find Your Doctor",
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 20),
                      MaterialButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            PageRouteBuilder(
                              pageBuilder:
                                  (context, animation, secondaryAnimation) =>
                                      BottomNavScreen(startIndex: 2),
                              transitionDuration:
                                  Duration.zero, // No animation duration
                              reverseTransitionDuration:
                                  Duration.zero, // No reverse animation
                            ),
                          );
                        },
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding:
                            EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                        child: Text(
                          "Let's Go",
                          style: TextStyle(
                            fontSize: 18,
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
            Expanded(
              flex: 3,
              child: Container(
                color: Colors.white,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          PageRouteBuilder(
                            pageBuilder:
                                (context, animation, secondaryAnimation) =>
                                    BottomNavScreen(startIndex: 1),
                            transitionDuration:
                                Duration.zero, // No animation duration
                            reverseTransitionDuration:
                                Duration.zero, // No reverse animation
                          ),
                        );
                      },
                      child: _buildIconTile(
                          'assets/images/pharmacy.png', 'Pharmacy'),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          PageRouteBuilder(
                            pageBuilder:
                                (context, animation, secondaryAnimation) =>
                                    BottomNavScreen(startIndex: 3),
                            transitionDuration:
                                Duration.zero, // No animation duration
                            reverseTransitionDuration:
                                Duration.zero, // No reverse animation
                          ),
                        );
                      },
                      child: _buildIconTile(
                          'assets/images/diagnosis.png', 'Diagnosis'),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          PageRouteBuilder(
                            pageBuilder:
                                (context, animation, secondaryAnimation) =>
                                    BottomNavScreen(startIndex: 4),
                            transitionDuration:
                                Duration.zero, // No animation duration
                            reverseTransitionDuration:
                                Duration.zero, // No reverse animation
                          ),
                        );
                      },
                      child: _buildIconTile(
                          'assets/images/ambulance.png', 'Ambulance'),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 7,
              child: FutureBuilder<List<Appointment>>(
                future: fetchAppointments(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return const Center(
                        child: Text('Error loading appointments'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(
                        child: Text('No upcoming appointments'));
                  }
                  int userId =
                      Provider.of<UserProvider>(context, listen: false).userId;
                  final userAppointments = snapshot.data!
                      .where((appointment) => appointment.userId == userId)
                      .toList();

                  if (userAppointments.isEmpty) {
                    return Center(child: Text('No upcoming appointments'));
                  }

                  return Container(
                    color: Colors.white,
                    padding: EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Upcoming Appointments',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Expanded(
                          child: ListView.builder(
                            itemCount: userAppointments.length,
                            itemBuilder: (context, index) {
                              final appointment = userAppointments[index];
                              return Container(
                                child: Card(
                                  
                                  color: Colors.white,
                                  margin: const EdgeInsets.symmetric(vertical: 6),
                                  child: ListTile(
                                    leading: const Icon(Icons.calendar_today,
                                        color: MyColors.deepTealGreen),
                                    title: Text(appointment.doctorName),
                                    subtitle: Text(
                                        '${appointment.date} at ${appointment.time}'),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIconTile(String imagePath, String label) {
    return Column(
      children: [
        Image.asset(
          imagePath,
          width: 100,
          height: 100,
        ),
        Text(label, style: TextStyle(fontSize: 14)),
      ],
    );
  }
}
