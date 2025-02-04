import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Column(
        children: [
          Expanded(
            flex: 2,
            child: Container(
              color: Colors.white,
              child: const Center(
                child: Text(
                  'this is home page',
                  style: TextStyle(color: Colors.black, fontSize: 24),
                ),
              ),
            ),
          ),
        ],
      ),
    ));
  }
}
