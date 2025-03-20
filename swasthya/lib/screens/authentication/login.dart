import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../config.dart';
import '../mycolors.dart';
import 'package:provider/provider.dart';
import '../../user_provider.dart';
import 'otp_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;

  Future<void> _login() async {
  setState(() {
    _isLoading = true;
    _errorMessage = null;
  });

  final response = await http.post(
    Uri.parse('${AppConfig.baseUrl}/api/login/'),
    headers: {"Content-Type": "application/json"},
    body: jsonEncode({
      "email": _emailController.text,
      "password": _passwordController.text,
    }),
  );

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    print("Full API Response: $data");

    Provider.of<UserProvider>(context, listen: false).setUser(data['name']);
    Provider.of<UserProvider>(context, listen: false).setId(data['user_id']);
    Provider.of<UserProvider>(context, listen: false).setPhone(data['phone']);

    String phone = Provider.of<UserProvider>(context, listen: false).phone;
    print("Phone: $phone");

    // Delay navigation to avoid context disposal issues
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
    setState(() {
      _errorMessage = jsonDecode(response.body)['error'] ?? "Invalid email or password";
    });
  }

  setState(() {
    _isLoading = false;
  });
}



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.maincolor,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              flex: 2,
              child: Container(
                padding: const EdgeInsets.only(left: 20, bottom: 20),
                child: const Align(
                  alignment: Alignment.centerLeft,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Login',
                        style: TextStyle(color: Colors.white, fontSize: 35, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'Welcome back! Please log in to continue.',
                        style: TextStyle(color: Colors.white, fontSize: 12),
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
                  borderRadius: BorderRadius.only(topRight: Radius.circular(50), topLeft: Radius.circular(50)),
                ),
                padding: const EdgeInsets.all(16.0),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(height: 40),
                      const Align(alignment: Alignment.centerLeft, child: Text('Email', style: TextStyle(fontWeight: FontWeight.bold))),
                      TextFormField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          hintText: 'e.g. johndoe@example.com',
                          prefixIcon: const Icon(Icons.email, color: MyColors.maincolor),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                      const SizedBox(height: 16.0),
                      const Align(alignment: Alignment.centerLeft, child: Text('Password', style: TextStyle(fontWeight: FontWeight.bold))),
                      TextFormField(
                        controller: _passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          hintText: 'Enter your password',
                          prefixIcon: const Icon(Icons.lock, color: MyColors.maincolor),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                      if (_errorMessage != null) ...[
                        const SizedBox(height: 10),
                        Text(_errorMessage!, style: const TextStyle(color: Colors.red)),
                      ],
                      const SizedBox(height: 24.0),
                      ElevatedButton(
                        onPressed: _isLoading ? null : _login,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: MyColors.maincolor,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 70),
                        ),
                        child: _isLoading
                            ? const CircularProgressIndicator(color: Colors.white)
                            : const Text(
                                'Login',
                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                              ),
                      ),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
