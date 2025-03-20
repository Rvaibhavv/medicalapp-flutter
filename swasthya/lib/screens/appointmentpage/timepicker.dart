import 'package:flutter/material.dart';
import '../mycolors.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../config.dart';
import 'package:intl/intl.dart';

class Timepicker extends StatefulWidget {
  final int doctorId; // Doctor ID
  final DateTime selectedDate;

  const Timepicker({
    super.key,
    required this.doctorId,
    required this.selectedDate,
  });

  @override
  State<Timepicker> createState() => _TimepickerState();
}

class _TimepickerState extends State<Timepicker> {
  final ContainerColor = MyColors.maincolor; // Define the border color
  int? selectedIndex; // State to keep track of the selected container
  String? selectedTime; // Variable to store the selected time
  List<String> bookedSlots = [];

  @override
  void initState() {
    super.initState();
    // Print the doctor ID and selected date
    print('Doctor IDdd: ${widget.doctorId}');
    print('Selected Date: ${widget.selectedDate}');
    fetchBookedSlots();

  }
   Future<void> fetchBookedSlots() async {
  final formattedDate = DateFormat('yyyy-MM-dd').format(widget.selectedDate);
  final url = Uri.parse('${AppConfig.baseUrl}/docAppoint/booked-slots/');

  try {
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "doctor_id": widget.doctorId,
        "date": formattedDate
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        bookedSlots = List<String>.from(data['booked_slots']);
        print("Booked slots: $bookedSlots");
      });
    } else {
      print("Error fetching booked slots: ${response.body}");
    }
  } catch (e) {
    print("Exception: $e");
  }
}


  bool isSlotBooked(String time) {
    return bookedSlots.contains(time);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.5,
      padding: const EdgeInsets.all(20), // Add padding inside the container
      decoration: const BoxDecoration(
        color: Colors.white, // Set the background color of the container to white
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const Text("Morning", style: TextStyle(fontSize: 20)),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              buildContainer(0, "10:00 AM"),
              buildContainer(1, "11:00 AM"),
              buildContainer(2, "12:00 PM"),
            ],
          ),
          const SizedBox(height: 5), // Space between rows

          const Text("Afternoon", style: TextStyle(fontSize: 20)),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              buildContainer(3, "1:00 PM"),
              buildContainer(4, "2:00 PM"),
              buildContainer(5, "3:00 PM"),
            ],
          ),
          const SizedBox(height: 5), // Space between rows

          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              buildContainer(6, "4:00 PM"),
            ],
          ),
          const SizedBox(height: 5), // Space between rows

          const Text("Evening", style: TextStyle(fontSize: 20)),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              buildContainer(7, "5:00 PM"),
              buildContainer(8, "6:00 PM"),
            ],
          ),
          const SizedBox(height: 10),

          // Row to align the button to the right
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              MaterialButton(
                onPressed: () {
                  if (selectedTime != null) {
                    Navigator.pop(context, selectedTime);
                  } else {
                    Navigator.pop(context, null);
                  }

                  // Navigate to Paymentgateway after popping
                },
                color: ContainerColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(40), // Curved border
                ),
                padding: const EdgeInsets.symmetric(
                    horizontal: 31, vertical: 10), // Adjust size
                child: const Text(
                  "Continue",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white, // White text color
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget buildContainer(int index, String text) {
  bool isSelected = selectedIndex == index;
  bool isBooked = isSlotBooked(text);

  return GestureDetector(
    onTap: isBooked
        ? null // Disable tapping on booked slots
        : () {
            setState(() {
              selectedIndex = index;
              selectedTime = text;
            });
          },
    child: Container(
      width: 100,
      height: 55,
      margin: const EdgeInsets.only(right: 14),
      decoration: BoxDecoration(
        color: isBooked
            ? const Color.fromARGB(255, 241, 190, 164) // Grey out booked slots
            : (isSelected ? ContainerColor : Colors.white),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: isBooked ? MyColors.mutedSunsetOrange : ContainerColor, width: 2),
      ),
      child: Center(
        child: Text(
          text,
          style: TextStyle(
            color: isBooked
                ? MyColors.darkSunsetOrange // Dark grey for booked slots
                : (isSelected ? Colors.white : ContainerColor),
          ),
        ),
      ),
    ),
  );
}

}
