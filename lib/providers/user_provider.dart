import 'package:flutter/material.dart';
import '../models/user.dart';

class UserProvider with ChangeNotifier {
  User _user = User(
    name: 'Mahasiswa',
    role: 'Mahasiswa',
  );

  User get user => _user;

  void updateName(String newName) {
    if (newName.trim().isEmpty) {
      _user = User(
        name: 'Mahasiswa',
        role: _user.role,
      );
    } else {
      _user = User(
        name: newName.trim(),
        role: _user.role,
      );
    }
    notifyListeners();
  }

  void updateUser(User newUser) {
    _user = newUser;
    notifyListeners();
  }
}