import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User? get user => _auth.currentUser;

  bool get isLogged => user != null;

  Future<bool> login(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      notifyListeners();
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<String?> register(String email, String password) async {
    try {
      await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      notifyListeners();
      return null;
    } catch (e) {
      return e.toString();
    }
  }

  Future<void> logout() async {
    await _auth.signOut();
    notifyListeners();
  }
}
