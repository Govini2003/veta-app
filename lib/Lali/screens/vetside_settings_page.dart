import 'package:flutter/material.dart';
import 'vet_home_page.dart';
import 'vet_appointments_page.dart';
import 'vet_dashboard.dart';
import 'vet_payment_page.dart';
import 'vet_profile.dart';

class VetSettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Settings',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeader('Account Settings'),
            _buildSettingsItem(
              icon: Icons.person,
              title: 'Edit Profile',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => VetProfile()),
                );
              },
            ),
            _buildSettingsItem(
              icon: Icons.lock,
              title: 'Change Password',
              onTap: () {
                // Navigate to Change Password Page
              },
            ),
            _buildSettingsItem(
              icon: Icons.notifications,
              title: 'Notification Preferences',
              onTap: () {
                // Navigate to Notification Preferences Page
              },
            ),
            SizedBox(height: 20),

            _buildSectionHeader('App Settings'),
            _buildSettingsItem(
              icon: Icons.language,
              title: 'Language',
              onTap: () {
                // Navigate to Language Settings Page
              },
            ),
            _buildSettingsItem(
              icon: Icons.color_lens,
              title: 'Theme',
              onTap: () {
                // Navigate to Theme Settings Page
              },
            ),
            _buildSettingsItem(
              icon: Icons.help_outline,
              title: 'Help & Support',
              onTap: () {
                // Navigate to Help & Support Page
              },
            ),
            SizedBox(height: 20),

            _buildSectionHeader('Privacy & Security'),
            _buildSettingsItem(
              icon: Icons.security,
              title: 'Privacy Policy',
              onTap: () {
                // Navigate to Privacy Policy Page
              },
            ),
            _buildSettingsItem(
              icon: Icons.shield,
              title: 'Terms of Service',
              onTap: () {
                // Navigate to Terms of Service Page
              },
            ),
            SizedBox(height: 20),

            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Handle logout
                },
                child: Text(
                  'Logout',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF357376),
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFF357376),
        unselectedItemColor: Colors.grey,
        currentIndex: 4,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.calendar_today), label: 'Appointments'),
          BottomNavigationBarItem(icon: Icon(Icons.business), label: 'Insights'),
          BottomNavigationBarItem(icon: Icon(Icons.money), label: 'Payments'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
        ],
        onTap: (index) {
          switch (index) {
            case 0:
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => VetHomePage()),
              );
              break;
            case 1:
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => VetAppointmentsPage()),
              );
              break;
            case 2:
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => VetDashboard()),
              );
              break;
            case 3:
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => VetPaymentPage()),
              );
              break;
            case 4:
              // Already on Settings page
              break;
          }
        },
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: TextStyle(
          fontFamily: 'Poppins',
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Color(0xFF357376),
        ),
      ),
    );
  }

  Widget _buildSettingsItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: Color(0xFF357376)),
      title: Text(
        title,
        style: TextStyle(
          fontFamily: 'Questrial',
          fontSize: 16,
          color: Colors.black87,
        ),
      ),
      trailing: Icon(Icons.arrow_forward, color: Colors.grey),
      onTap: onTap,
    );
  }
} 