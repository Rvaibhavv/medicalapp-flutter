import 'package:flutter/material.dart';

class UserProvider with ChangeNotifier {
  int _userId = 0;
  String _userName = "";

  int get userId => _userId;
  String get userName => _userName;

  void setUser(String name) {
    _userName = name;
    notifyListeners();
  }

  void setId(int id) {
    _userId = id;
    notifyListeners();
    print("User IDssssssssss: $_userId");
  }
}
