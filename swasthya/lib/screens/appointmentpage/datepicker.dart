// datepicker.dart
import 'package:flutter/material.dart';
import '../mycolors.dart';
Future<DateTime?> showCustomDatePicker(BuildContext context) async {
  return await showDatePicker(
    context: context,
    initialDate: DateTime.now(),
    firstDate: DateTime.now(),
    lastDate: DateTime(2026),
    builder: (BuildContext context, Widget? child) {
      return Theme(
        data: ThemeData(
          primarySwatch: Colors.blue,
          dialogBackgroundColor: Colors.white,
          textTheme: const TextTheme(
            bodyLarge: TextStyle(color: Colors.black),
          ),
          colorScheme: const ColorScheme.light(
            primary: MyColors.maincolor,
            onPrimary: Colors.white,
            onSurface: Colors.black,
          ),
          buttonTheme:const ButtonThemeData(
            textTheme: ButtonTextTheme.primary,
          ),
        ),
        child: child!,
      );
    },
  );
}
 