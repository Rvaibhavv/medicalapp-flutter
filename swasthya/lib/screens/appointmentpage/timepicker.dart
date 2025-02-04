import 'package:flutter/material.dart';

class Timepicker extends StatefulWidget {
  const Timepicker({super.key});

  @override
  State<Timepicker> createState() => _TimepickerState();
}

class _TimepickerState extends State<Timepicker> {
  final  ContainerColor = const
      Color.fromARGB(255, 255, 158, 204); // Define the border color
  int? selectedIndex; // State to keep track of the selected container
  String? selectedTime; // Variable to store the selected time

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.5,
      padding: const EdgeInsets.all(20), // Add padding inside the container
      decoration: const BoxDecoration(
        color:
            Colors.white, // Set the background color of the container to white
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
                color: const Color.fromARGB(255, 255, 158, 204),
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
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedIndex = index;
          selectedTime = text; // Store the selected time
        });
      },
      child: Container(
        width: 100,
        height: 55,
        margin: const EdgeInsets.only(right: 14), // Spacing between boxes
        decoration: BoxDecoration(
          color: isSelected ? ContainerColor : Colors.white,
          borderRadius: BorderRadius.circular(10),
          border:
              Border.all(color: ContainerColor, width: 2), // Set border color
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(color: isSelected ? Colors.white : ContainerColor),
          ),
        ),
      ),
    );
  }
}
