// veta-app/lib/screens/login_screen.dart
import 'package:flutter/material.dart';
import 'petO_home_page.dart'; 
import 'vet_home_page.dart'; 
import 'package:font_awesome_flutter/font_awesome_flutter.dart';


class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF64CCC5),
      appBar: AppBar(
        title: const Text('Login'),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Veta.lk',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.bold,
                fontSize: 32,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Select Your Role',
              style: TextStyle(fontSize: 24, color: Colors.black),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => VetHomePage()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF357376),
              ),
              child: const Text(
                'Veterinarian',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => PetOHomePage()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF357376),
              ),
              child: const Text(
                'Pet Owner',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
