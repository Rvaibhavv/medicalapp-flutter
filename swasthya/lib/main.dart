import 'package:flutter/material.dart';
import 'screens/splash.dart';
void main() {
  
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.pink,
        fontFamily: 'Poppins',
      ),
      title: 'Medical APP',
            home: Splash(), // Start with the HomeScreen
    );
  }
}
