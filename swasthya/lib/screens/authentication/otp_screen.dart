import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:swasthya/screens/bottomnav.dart';
import 'package:swasthya/screens/mycolors.dart';

class OtpScreen extends StatefulWidget {
  final String phoneNumber;

  const OtpScreen({Key? key, required this.phoneNumber}) : super(key: key);

  @override
  _OtpScreenState createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final List<TextEditingController> _otpControllers =
      List.generate(6, (index) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (index) => FocusNode());
  String _verificationId = "";
  bool _isLoading = false;
  bool _otpSent = false;

  @override
  void initState() {
    super.initState();
    _sendOtp();
  }

  void _sendOtp() async {
    setState(() {
      _isLoading = true;
      _otpSent = false;
    });

    await _auth.verifyPhoneNumber(
      phoneNumber: widget.phoneNumber,
      timeout: const Duration(seconds: 60),
      verificationCompleted: (PhoneAuthCredential credential) async {
        await _auth.signInWithCredential(credential);
        _navigateToHome();
      },
      verificationFailed: (FirebaseAuthException e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Verification failed: ${e.message}")),
        );
        setState(() => _isLoading = false);
      },
      codeSent: (String verificationId, int? resendToken) {
        setState(() {
          _verificationId = verificationId;
          _isLoading = false;
          _otpSent = true;
        });
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        setState(() => _verificationId = verificationId);
      },
    );
  }

  void _verifyOtp() async {
    setState(() => _isLoading = true);

    try {
      String otpCode =
          _otpControllers.map((controller) => controller.text).join();
      if (otpCode.length != 6) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Enter a 6-digit OTP!")),
        );
        setState(() => _isLoading = false);
        return;
      }

      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: _verificationId,
        smsCode: otpCode,
      );

      await _auth.signInWithCredential(credential);
      _navigateToHome();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Invalid OTP!")),
      );
    }

    setState(() => _isLoading = false);
  }

  void _navigateToHome() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const BottomNavScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            /// Top Section (2/9 ratio)

            /// Bottom Section (7/9 ratio) with Background Color
            Expanded(
              flex: 7,
              child: Container(
                color: Colors.white,
                padding: const EdgeInsets.all(16.0),
                child: SingleChildScrollView(
                  // Wrap in ScrollView to prevent overflow
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.center, // Center content
                    children: [
                      /// Image at the Top
                      Image.asset(
                        'assets/images/otp.png',
                        width: 350, // Adjust width to avoid overflow
                        height: 350, // Adjust height to avoid overflow
                        fit: BoxFit.contain,
                      ),

                      const SizedBox(height: 15), // Space after image

                      /// First Text Below Image
                      const Text(
                        "Enter the OTP sent to your mobile number",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),

                      const SizedBox(height: 5), // Space between texts

                      /// Second Text Below First
                      const Text(
                        "Please enter the 6-digit code to verify",
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                        textAlign: TextAlign.center,
                      ),

                      const SizedBox(height: 20), // Space before OTP fields

                      /// OTP Input Fields (Now Flexible)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: List.generate(6, (index) {
                          return SizedBox(
                            width: 45,
                            height: 50,
                            child: TextField(
                              controller: _otpControllers[index],
                              focusNode: _focusNodes[index],
                              keyboardType: TextInputType.number,
                              maxLength: 1,
                              textAlign: TextAlign.center,
                              
                              style: const TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                              decoration: InputDecoration(
                                counterText: "",
                                filled: true ,
                                contentPadding: EdgeInsets.zero,
                                fillColor: const Color.fromARGB(255, 237, 249, 249),
                                enabledBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(color: const Color.fromARGB(255, 237, 249, 249)),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(12)),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: MyColors.maincolor),
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(12)),
                                ),
                              ),
                              onChanged: (value) {
                                if (value.isNotEmpty && index < 5) {
                                  _focusNodes[index].unfocus();
                                  FocusScope.of(context)
                                      .requestFocus(_focusNodes[index + 1]);
                                } else if (value.isEmpty && index > 0) {
                                  _focusNodes[index].unfocus();
                                  FocusScope.of(context)
                                      .requestFocus(_focusNodes[index - 1]);
                                }
                              },
                            ),
                          );
                        }),
                      ),

                      const SizedBox(height: 25), // Space before button

                      /// Verify Button (Always visible)
                      ElevatedButton(
                        onPressed: _verifyOtp,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: MyColors.maincolor,
                          minimumSize: const Size(300, 50),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          "Verify",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),

                      const SizedBox(height: 10), // Space below button

                      /// OTP Status Message (Instead of replacing the button)
                      _isLoading
                          ? const Text(
                              "Sending OTP...",
                              style:
                                  TextStyle(fontSize: 16, color: Colors.grey),
                            )
                          : _otpSent
                              ? const Text(
                                  "OTP Sent!",
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.green),
                                )
                              : const SizedBox(), // Empty space if nothing to show

                      const SizedBox(
                          height: 20), // Add extra space at the bottom
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
