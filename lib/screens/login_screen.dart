import 'package:flutter/material.dart';
import 'petO_home_page.dart'; // Import Pet Owner Home Page
import 'vet_home_page.dart'; // Import Veterinarian Home Page
import 'package:flutter/material.dart';


class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF64CCC5), // Set the background color
      appBar: AppBar(
        title: Text('Login'),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Veta.lk',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.bold,
                fontSize: 32,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Select Your Role',
              style: TextStyle(fontSize: 24, color: Colors.black),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => VetHomePage()), // Navigate to Vet Home Page
                );
              },
              child: Text(
                'Veterinarian',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF357376), // Use backgroundColor instead of primary
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => PetOHomePage()), // Navigate to Pet Owner Home Page
                );
              },
              child: Text(
                'Pet Owner',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF357376), // Use backgroundColor instead of primary
              ),
            ),
          ],
        ),
      ),
    );
  }
}
