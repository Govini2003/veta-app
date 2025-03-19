import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/services.dart';

class AuthService {
  final _auth = FirebaseAuth.instance;
  final UserService _userService = UserService();

  // Store verification code for password reset
  String? _verificationCode;
  String? _resetEmail;

  // Sync user with backend after successful authentication
  Future<void> syncUserWithBackend({
    String? displayName,
    String? photoURL,
    String? phoneNumber,
    String? role,
  }) async {
    try {
      final User? currentUser = _auth.currentUser;
      if (currentUser == null) return;

      await _userService.syncUserWithBackend({
        'displayName': displayName ?? currentUser.displayName,
        'photoURL': photoURL ?? currentUser.photoURL,
        'phoneNumber': phoneNumber ?? currentUser.phoneNumber,
        'role': role,
      });
    } catch (e) {
      log('Error syncing user with backend: $e');
      // Handle error - maybe retry or show notification
    }
  }

  Future<void> sendEmailVerification() async {
    try {
      await _auth.currentUser?.sendEmailVerification();
    } catch (e) {
      print(e.toString());
    }
  }

  // Method to send password reset email with verification code
  Future<String> sendPasswordResetEmail(String email) async {
    try {
      _resetEmail = email;
      // Generate a random 6-digit verification code
      _verificationCode =
          (100000 + (DateTime.now().millisecondsSinceEpoch % 900000))
              .toString();

      // In a real app, you would send this code via email using a backend service
      // For now, we'll just return the code for demonstration purposes
      // In production, you would use Firebase's sendPasswordResetEmail method:
      // await _auth.sendPasswordResetEmail(email: email);

      log("Verification code sent: $_verificationCode", name: 'AuthService');
      return _verificationCode!;
    } catch (e) {
      log("Password reset email error: $e", name: 'AuthService');
      rethrow;
    }
  }

  // Method to verify the reset code
  bool verifyResetCode(String code) {
    return code == _verificationCode;
  }

  // Method to update password after verification
  Future<void> updatePassword(String newPassword) async {
    try {
      // In a real app with proper email verification flow:
      // User user = _auth.currentUser!;
      // await user.updatePassword(newPassword);

      // For our demo, we'll re-authenticate and then update
      if (_resetEmail != null) {
        // In a real app, you would use the confirmPasswordReset method
        // or have the user sign in and then update their password
        await _auth.sendPasswordResetEmail(email: _resetEmail!);
        log("Password reset email sent to $_resetEmail", name: 'AuthService');
      }
    } catch (e) {
      log("Update password error: $e", name: 'AuthService');
      rethrow;
    }
  }

  // Method to directly use Firebase's password reset
  Future<void> sendFirebasePasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      log("Firebase password reset email error: $e", name: 'AuthService');
      rethrow;
    }
  }

  // Login with email and password
  Future<User?> loginWithEmailAndPassword(String email, String password) async {
    try {
      final UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Sync with backend
      await syncUserWithBackend();

      return result.user;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // Sign in with Google
  Future<User?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) return null;

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential result =
          await _auth.signInWithCredential(credential);

      // Sync with backend
      await syncUserWithBackend();

      return result.user;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // Register with email and password
  Future<User?> registerWithEmailAndPassword(
      String email, String password, String displayName, String role) async {
    try {
      final UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Update display name
      await result.user?.updateDisplayName(displayName);

      // Sync with backend
      await syncUserWithBackend(
        displayName: displayName,
        role: role,
      );

      return result.user;
    } catch (e) {
      print(e.toString());
      return null;
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

  // Complete logout method that handles both Firebase signout and clearing SharedPreferences
  Future<void> logoutUser() async {
    try {
      // Sign out from Firebase
      await _auth.signOut();

      // Sign out from Google if it was used
      await GoogleSignIn().signOut();

      // Clear user role from SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('user_role');

      log("User logged out successfully", name: 'AuthService');
    } catch (e) {
      log("Logout Error: $e", name: 'AuthService');
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

  getUserRole(String uid) {}
}
