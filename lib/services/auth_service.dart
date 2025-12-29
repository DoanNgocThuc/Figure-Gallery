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

  Future<String> getUserId() async {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      String userId = user.uid;
      return userId;
    } else {
      debugPrint("Can't get user");
      return '';
    }
  }

  Future<User?> getCurrentUser() async {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return user;
    } else {
      debugPrint("Can't get current User");
      return null;
    }
  }
}
