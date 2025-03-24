//veta-app/frontend1/lib/Entrance/wrapper.dart
import 'package:firebase_auth/firebase_auth.dart'; 
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:auth_firebase/LoginSignupAuth/login_screen.dart';
import 'package:auth_firebase/Entrance/role_selection_screen.dart';
import 'package:auth_firebase/Lali/screens/petO_home_page.dart';
import 'package:auth_firebase/Lali/screens/vet_home_page.dart';

class Wrapper extends StatefulWidget {
  const Wrapper({super.key});

  @override
  State<Wrapper> createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  String? userRole;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _checkUserRole();
  }

  Future<void> _checkUserRole() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userRole = prefs.getString('user_role');
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // Check connection state first
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        // Check for any errors
        if (snapshot.hasError) {
          return const Scaffold(
            body: Center(
              child: Text('Something went wrong'),
            ),
          );
        }

        // Determine which screen to show based on authentication state
        if (snapshot.hasData) {
          // User is authenticated
          if (userRole == 'pet_owner') {
            return WillPopScope(
              onWillPop: () async {
                return await _onWillPop(context);
              },
              child: PetOHomePage(),
            );
          } else if (userRole == 'vet') {
            return WillPopScope(
              onWillPop: () async {
                return await _onWillPop(context);
              },
              child: VetHomePage(),
            );
          } else {
            // User is authenticated but role not set
            return const RoleSelectionScreen();
          }
        } else {
          // User is not authenticated
          return const LoginScreen();
        }
      },
    );
  }

  // Handle back button press with double-tap to exit
  DateTime? _lastBackPressTime;

  Future<bool> _onWillPop(BuildContext context) async {
    final now = DateTime.now();
    if (_lastBackPressTime == null ||
        now.difference(_lastBackPressTime!) > const Duration(seconds: 2)) {
      _lastBackPressTime = now;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Press back again to exit'),
          duration: Duration(seconds: 2),
        ),
      );
      return false;
    }
    return true;
  }
}
