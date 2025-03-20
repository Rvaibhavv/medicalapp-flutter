import 'package:flutter/material.dart';

class UserProvider with ChangeNotifier {
  int _userId = 0;
  String _userName = "";
  String _phone = "";

  int get userId => _userId;
  String get userName => _userName;
  String get phone => _phone;

  void setUser(String name) {
    _userName = name;
    notifyListeners();
  }

  void setPhone(String phone)
  {
    _phone = phone;
    notifyListeners();
    print("phoneeeeee: $_phone");
  }
  void setId(int id) {
    _userId = id;
    notifyListeners();
    print("User IDssssssssss: $_userId");
  }
}
