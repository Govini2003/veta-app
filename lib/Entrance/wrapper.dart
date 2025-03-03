import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:auth_firebase/LoginSignupAuth/login_screen.dart';
import 'package:auth_firebase/Entrance/role_selection_screen.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // Check connection state first
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        // Check for any errors
        if (snapshot.hasError) {
          return const Center(
            child: Text('Something went wrong'),
          );
        }

        // Determine which screen to show based on authentication state
        if (snapshot.hasData) {
          return const RoleSelectionScreen();
        } else {
          return const LoginScreen();
        }
      },
    );
  }
}
