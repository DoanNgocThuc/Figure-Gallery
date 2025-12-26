import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/foundation.dart";

class AuthService {
  Future<void> loginWithEmailAndPassword(String email, String password) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      debugPrint("The login error: $e");
      throw e.toString();
    }
  }

  Future<void> signUpWithEmailAndPassword(String email, String password) async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      debugPrint("The signUp error: $e");
      throw e.toString();
    }
  }

  Future<void> signOut() async {
    try {
      await FirebaseAuth.instance.signOut();
    } catch (e) {
      debugPrint("The signOut error: $e");
      throw e.toString();
    }
  }
}
