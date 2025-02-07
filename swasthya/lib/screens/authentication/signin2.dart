import 'package:flutter/material.dart';

class SignIn2Screen extends StatefulWidget {
  final String name;
  final String age;
  final String gender;
  final String phone;

  SignIn2Screen({
    required this.name,
    required this.age,
    required this.gender,
    required this.phone,
  });

  @override
  _SignIn2ScreenState createState() => _SignIn2ScreenState();
}

class _SignIn2ScreenState extends State<SignIn2Screen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  void _completeRegistration() {
    if (_formKey.currentState!.validate()) {
      print('Name: ${widget.name}');
      print('Age: ${widget.age}');
      print('Gender: ${widget.gender}');
      print('Phone: ${widget.phone}');
      print('Email: ${_emailController.text}');
      print('Password: ${_passwordController.text}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Sign Up - Step 2')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Align(alignment: Alignment.centerLeft, child: Text('Email')),
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  hintText: 'e.g. johndoe@example.com',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an email';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              Align(alignment: Alignment.centerLeft, child: Text('Password')),
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  hintText: 'Enter your password',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a password';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              Align(alignment: Alignment.centerLeft, child: Text('Confirm Password')),
              TextFormField(
                controller: _confirmPasswordController,
                obscureText: true,
                decoration: InputDecoration(
                  hintText: 'Re-enter your password',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please confirm your password';
                  }
                  if (value != _passwordController.text) {
                    return 'Passwords do not match';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _completeRegistration,
                child: Text('Complete Registration'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
