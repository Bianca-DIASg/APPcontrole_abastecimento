import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  static Future<bool> login(String email, String password) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email, password: password);
      return true;
    } catch (_) {
      return false;
    }
  }

  static Future<void> register(String email, String password) async {
    await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email, password: password);
  }

  static Future<void> logout() async {
    await FirebaseAuth.instance.signOut();
  }
}    
