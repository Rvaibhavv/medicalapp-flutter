import 'package:flutter/material.dart';
import 'package:swasthya/screens/authentication/terms.dart';
import 'package:swasthya/screens/authentication/privacy.dart';

class Choose extends StatefulWidget {
  const Choose({super.key});

  @override
  State<Choose> createState() => _ChooseState();
}

class _ChooseState extends State<Choose> {
  final Color buttonTextColor =
      const Color.fromARGB(255, 255, 169, 209); // Pink color

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // White background
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisSize:
                MainAxisSize.min, // Ensures buttons stay in the center
            children: [
              Text(
                "SWASTHYA", // App name
                style: TextStyle(
                  color: const Color.fromARGB(255, 255, 169, 209), // Text color
                  fontSize: 50,
                  fontWeight: FontWeight.bold,
                  shadows: [
                    Shadow(
                      offset: const Offset(3.0,
                          3.0), // Horizontal and vertical displacement of the shadow
                      blurRadius: 10.0, // Blur radius of the shadow
                      color: Colors.grey
                          .withOpacity(0.3), // Shadow color with transparency
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 50),
              Image.asset('assets/images/choose.png'),

              const SizedBox(height: 80),

              SizedBox(
                height: 60,
                width: 350, // Increased width
                child: MaterialButton(
                  onPressed: () {},
                  color: Colors.white, // Button background is white
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(12), // Slight curve on borders
                    side: BorderSide(
                        color: buttonTextColor, width: 2), // Pink border
                  ),
                  child: Text(
                    "Sign in",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                      color: buttonTextColor, // Pink text color
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20), // Space between buttons
              SizedBox(
                height: 60,
                width: 350, // Increased width
                child: MaterialButton(
                  onPressed: () {},
                  color: Colors.white, // Button background is white
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(12), // Slight curve on borders
                    side: BorderSide(
                        color: buttonTextColor, width: 2), // Pink border
                  ),
                  child: Text(
                    "Login",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                      color: buttonTextColor, // Pink text color
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              SizedBox(
                height: 15,
                width: 350,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  TermsPage()), // Your home screen widget
                        );
                      },
                      child: const Text(
                        "Terms and Conditions",
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w900,
                          color: Color.fromARGB(
                              255, 255, 169, 209), // Clickable text color
                          // Underline to indicate link
                        ),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.fromLTRB(1, 0, 2, 0),
                      child: Text(
                        " and",
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w900,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  PrivacyPolicyPage()), // Your home screen widget
                        );
                      },
                      child: const Text(
                        "Privacy Policy",
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w900,
                          color: Color.fromARGB(255, 255, 169, 209),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
