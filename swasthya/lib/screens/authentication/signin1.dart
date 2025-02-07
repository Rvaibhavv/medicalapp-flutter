import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'signin2.dart';

class SignIn1Screen extends StatefulWidget {
  @override
  _SignIn1ScreenState createState() => _SignIn1ScreenState();
}

class _SignIn1ScreenState extends State<SignIn1Screen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _genderController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  void _nextScreen() {
    if (_formKey.currentState!.validate()) {
      String name = _nameController.text;
      String age = _ageController.text;
      String gender = _genderController.text;
      String phone = _phoneController.text;

      print('Name: $name');
      print('Age: $age');
      print('Gender: $gender');
      print('Phone: $phone');

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SignIn2Screen(
            name: name,
            age: age,
            gender: gender,
            phone: phone,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Align(alignment: Alignment.centerLeft, child: Text('Full Name')),
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  hintText: 'e.g. John Doe',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16.0),
              Align(alignment: Alignment.centerLeft, child: Text('Age')),
              TextFormField(
                controller: _ageController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: 'e.g. 25',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16.0),
              Align(alignment: Alignment.centerLeft, child: Text('Gender')),
              TextFormField(
                controller: _genderController,
                decoration: InputDecoration(
                  hintText: 'e.g. Male/Female/Other',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16.0),
              Align(alignment: Alignment.centerLeft, child: Text('Phone Number')),
              TextFormField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  hintText: 'e.g. +1234567890',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _nextScreen,
                child: Text('Next'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
