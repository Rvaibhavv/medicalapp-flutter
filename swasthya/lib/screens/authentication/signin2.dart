import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:swasthya/screens/mycolors.dart';
import '../bottomnav.dart';
import '../../config.dart';
import 'package:provider/provider.dart';
import '../../user_provider.dart';

const Color primaryColor = MyColors.maincolor;

class SignIn2Screen extends StatefulWidget {
  final String name;
  final String dob;
  final String gender;
  final String phone;

  const SignIn2Screen({
    required this.name,
    required this.dob,
    required this.gender,
    required this.phone,
    super.key,
  });

  @override
  _SignIn2ScreenState createState() => _SignIn2ScreenState();
}

class _SignIn2ScreenState extends State<SignIn2Screen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _completeRegistration() async {
    if (!_formKey.currentState!.validate()) return;

    final url = Uri.parse('${AppConfig.baseUrl}/api/register/');
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        'name': widget.name,
        'dob': widget.dob,
        'gender': widget.gender,
        'phone': widget.phone,
        'email': _emailController.text,
        'password': _passwordController.text,
      }),
    );

    if (response.statusCode == 201) {
          Provider.of<UserProvider>(context, listen: false).setUser('name');
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => BottomNavScreen()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${jsonDecode(response.body)['error']}')),
      );
    }
  }

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      resizeToAvoidBottomInset: true, // Prevents overflow
      body: SafeArea(
        child: GestureDetector(
          onTap: () =>
              FocusScope.of(context).unfocus(), // Dismiss keyboard on tap
          child: Column(
            children: [
              /// Top Section (Title)
              Expanded(
                flex: 2,
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
                      children: const [
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

              /// Bottom Section (Form)
              Expanded(
                flex: 7,
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(50),
                      topLeft: Radius.circular(50),
                    ),
                  ),
                  padding: const EdgeInsets.all(16.0),

                  /// Scrollable Form
                  child: SingleChildScrollView(
                   
                    child: Center(
                      // Ensures the form is centered
                      child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisSize:
                              MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                               crossAxisAlignment: CrossAxisAlignment.center,
                               // Takes minimal height
                          children: [
                            const SizedBox(
                                height: 40), // Extra spacing for centering

                            /// Email Field
                            const Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'Email',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            TextFormField(
                              controller: _emailController,
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                hintText: 'e.g. johndoe@example.com',
                                prefixIcon: const Icon(Icons.email,
                                    color: primaryColor),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: primaryColor, width: 2.5),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              validator: (value) => value!.isEmpty
                                  ? 'Please enter an email'
                                  : null,
                            ),
                            const SizedBox(height: 16.0),

                            /// Password Field
                            const Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'Password',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            TextFormField(
                              controller: _passwordController,
                              obscureText: true,
                              decoration: InputDecoration(
                                hintText: 'Enter your password',
                                prefixIcon:
                                    const Icon(Icons.lock, color: primaryColor),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: primaryColor, width: 2.5),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              validator: (value) =>
                                  value!.isEmpty ? 'Enter your password' : null,
                            ),
                            const SizedBox(height: 24.0),

                            /// Submit Button
                            ElevatedButton(
                              onPressed: _completeRegistration,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: primaryColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                padding: const EdgeInsets.symmetric(
                                    vertical: 14, horizontal: 70),
                              ),
                              child: const Text(
                                'Next',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),

                            const SizedBox(
                                height: 40), // Extra spacing for centering
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
