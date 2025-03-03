import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final _auth = FirebaseAuth.instance;

  Future<UserCredential?> loginWithGoogle() async {
    try {
      final googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        throw Exception("Google sign-in failed");
      }

      final googleAuth = await googleUser.authentication;
      if (googleAuth == null ||
          googleAuth.idToken == null ||
          googleAuth.accessToken == null) {
        throw Exception("Google authentication failed");
      }

      final cred = GoogleAuthProvider.credential(
          idToken: googleAuth.idToken, accessToken: googleAuth.accessToken);

      return await _auth.signInWithCredential(cred);
    } catch (e) {
      log("Google login error: $e", name: 'AuthService');
      return null;
    }
  }

  Future<User?> createUserWithEmailAndPassword(
      String email, String password) async {
    try {
      final cred = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      return cred.user;
    } on FirebaseAuthException catch (e) {
      log("Signup Error: ${e.code} - ${e.message}", name: 'AuthService');
      rethrow;
    } catch (e) {
      log("Unexpected Signup Error: $e", name: 'AuthService');
      rethrow;
    }
  }

  Future<User?> loginUserWithEmailAndPassword(
      String email, String password) async {
    try {
      final cred = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      return cred.user;
    } on FirebaseAuthException catch (e) {
      log("Login Error: ${e.code} - ${e.message}", name: 'AuthService');
      rethrow;
    } catch (e) {
      log("Unexpected Login Error: $e", name: 'AuthService');
      rethrow;
    }
  }

  Future<void> signout() async {
    try {
      await _auth.signOut();
    } catch (e) {
      log("Signout Error: $e", name: 'AuthService');
      rethrow;
    }
  }

  // Utility method for email validation
  bool isValidEmail(String email) {
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+$');
    return emailRegex.hasMatch(email);
  }

  // Utility method for password strength validation
  bool isStrongPassword(String password) {
    return password.length >= 8 &&
        password.contains(RegExp(r'[A-Z]')) &&
        password.contains(RegExp(r'[a-z]')) &&
        password.contains(RegExp(r'[0-9]')) &&
        password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));
  }
}
