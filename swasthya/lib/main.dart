import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'user_provider.dart';
import 'screens/splash.dart';
void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => UserProvider(),
      child:  MyApp(),
    ),
  );
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
            home: const Splash(), // Start with the HomeScreen
    );
  }
}
