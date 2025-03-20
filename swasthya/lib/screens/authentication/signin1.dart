import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:swasthya/screens/mycolors.dart';
import 'signin2.dart';

// Define a common color variable
const Color primaryColor = MyColors.maincolor;

class SignIn1Screen extends StatefulWidget {
  const SignIn1Screen({super.key});

  @override
  SignIn1ScreenState createState() => SignIn1ScreenState();
}

class SignIn1ScreenState extends State<SignIn1Screen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  String _gender = 'Male';

  void _nextScreen() {
    if (_formKey.currentState!.validate()) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SignIn2Screen(
            name: _nameController.text,
            dob: _dobController.text,
            gender: _gender,
            phone: _phoneController.text,
          ),
        ),
      );
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData(
            primarySwatch: Colors.blue,
            dialogBackgroundColor: Colors.white,
            textTheme: const TextTheme(
              bodyLarge: TextStyle(color: Colors.black),
            ),
            colorScheme: const ColorScheme.light(
              primary: MyColors.maincolor,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
            buttonTheme: const ButtonThemeData(
              textTheme: ButtonTextTheme.primary,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _dobController.text = "${picked.year}-${picked.month}-${picked.day}";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      body: Column(
        children: [
          Expanded(
            flex: 3,
            child: Container(
              color: primaryColor,
              padding: const EdgeInsets.only(
                  left: 20, bottom: 20), // Adjust padding as needed
              child: const Align(
                alignment: Alignment.centerLeft,
                child: Column(
                  mainAxisSize: MainAxisSize
                      .min, // Keeps it at the bottom instead of taking full space
                  crossAxisAlignment:
                      CrossAxisAlignment.start, // Aligns text to the left
                  children:  [
                    Text(
                      'Sign Up',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 35,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Welcome to the world where health matters!',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12, // Adjust size as needed
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            flex: 9,
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white, // Add color inside BoxDecoration
                border: Border(
                  top: BorderSide(color: primaryColor, width: 1),
                ),
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(50),
                  topLeft: Radius.circular(50),
                ),
              ),
              padding:
                  const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    const Text('Full Name',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    TextFormField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        hintText: 'e.g. John Doe',
                        prefixIcon:
                            const Icon(Icons.person, color: primaryColor),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12)),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: primaryColor, width: 2.5),
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      validator: (value) =>
                          value!.isEmpty ? 'Please enter your full name' : null,
                    ),
                    const SizedBox(height: 16.0),
                    const Text('Date of Birth',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    TextFormField(
                      controller: _dobController,
                      readOnly: true,
                      onTap: () => _selectDate(context),
                      decoration: InputDecoration(
                        hintText: 'Select your date of birth',
                        prefixIcon: const Icon(Icons.calendar_today,
                            color: primaryColor),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12)),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: primaryColor, width: 2.5),
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      validator: (value) =>
                          value!.isEmpty ? 'Enter your date of birth' : null,
                    ),
                    const SizedBox(height: 16.0),
                    const Text('Gender',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    CupertinoSegmentedControl<String>(
                      children: {
                        'Male': Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text('Male',
                              style: TextStyle(
                                  color: _gender == 'Male'
                                      ? Colors.white
                                      : Colors.black)),
                        ),
                        'Female': Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text('Female',
                              style: TextStyle(
                                  color: _gender == 'Female'
                                      ? Colors.white
                                      : Colors.black)),
                        ),
                      },
                      selectedColor: primaryColor,
                      borderColor: primaryColor,
                      groupValue: _gender,
                      onValueChanged: (value) =>
                          setState(() => _gender = value),
                    ),
                    const SizedBox(height: 16.0),
                    const Text('Phone Number',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    TextFormField(
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        hintText: 'e.g. +1234567890',
                        prefixIcon:
                            const Icon(Icons.phone, color: primaryColor),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12)),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: primaryColor, width: 2.5),
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      validator: (value) =>
                          value!.isEmpty ? 'Enter your phone number' : null,
                    ),
                    const SizedBox(height: 20.0),
                    ElevatedButton(
                      onPressed: _nextScreen,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        padding: const EdgeInsets.symmetric(
                          vertical: 14,
                        ),
                      ),
                      child: const Text('Next',
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white)),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
