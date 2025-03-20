import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:swasthya/screens/mycolors.dart';
import 'package:swasthya/screens/authentication/otp_screen.dart'; // Import OTP screen
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
  bool _isLoading = false;

  Future<void> _completeRegistration() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

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
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      print('Response: $responseData');

      if (responseData.containsKey('id') && responseData.containsKey('name')) {
        int userId = responseData['id'];
        String userName = responseData['name'];
        String phone = responseData['phone'];

        // Store in Provider
        Provider.of<UserProvider>(context, listen: false).setUser(userName);
        Provider.of<UserProvider>(context, listen: false).setId(userId);
        Provider.of<UserProvider>(context, listen: false).setPhone(phone);

        // Navigate to OTP Screen
        Future.delayed(Duration(milliseconds: 500), () {
          if (mounted) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => OtpScreen(phoneNumber: "+91$phone"),
              ),
            );
          }
        });
      } else {
        _showError("Unexpected response format");
      }
    } else {
      final errorMessage =
          jsonDecode(response.body)['error'] ?? 'Registration failed';
      _showError(errorMessage);
    }

    setState(() => _isLoading = false);
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error: $message')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      resizeToAvoidBottomInset: true, // Prevents overflow
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(), // Dismiss keyboard
          child: Column(
            children: [
              Expanded(
                flex: 2,
                child: Container(
                  color: primaryColor,
                  padding: const EdgeInsets.only(left: 20, bottom: 20),
                  child: const Align(
                    alignment: Alignment.centerLeft,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
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
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
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
                  child: SingleChildScrollView(
                    child: Center(
                      child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const SizedBox(height: 40),
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
                            ElevatedButton(
                              onPressed: _isLoading ? null : _completeRegistration,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: primaryColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                padding: const EdgeInsets.symmetric(
                                    vertical: 14, horizontal: 70),
                              ),
                              child: _isLoading
                                  ? const CircularProgressIndicator(color: Colors.white)
                                  : const Text(
                                      'Next',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                            ),
                            const SizedBox(height: 40),
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
