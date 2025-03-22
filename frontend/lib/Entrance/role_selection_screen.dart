import 'package:auth_firebase/LoginSignupAuth/auth_service.dart';
import 'package:auth_firebase/LoginSignupAuth/login_screen.dart';
import 'package:auth_firebase/Entrance/EntranceWidgets/button.dart';
import 'package:flutter/material.dart';
import 'package:auth_firebase/Entrance/petowner_registration_screen.dart';
import 'package:auth_firebase/Entrance/vet_registration_screen.dart';

class RoleSelectionScreen extends StatelessWidget {
  const RoleSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF357376), // Medium Greenish Shade
              Color(0xFF1D4D4F), // Darkest Brand Color
              Color(0xFF6BA8A9), // Lightest Green
            ],
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Who are you?',
              style: TextStyle(
                color: Colors.white,
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 50),
            _buildRoleButton(
              context,
              "I'm a Pet Owner",
              () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                      builder: (_) => const PetOwnerRegistrationScreen()),
                );
              },
            ),
            const SizedBox(height: 20),
            _buildRoleButton(
              context,
              "I'm a Vet",
              () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                      builder: (_) => const VetRegistrationScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRoleButton(
      BuildContext context, String role, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: Colors.teal,
        minimumSize: const Size(250, 60),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      ),
      child: Text(
        role,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
