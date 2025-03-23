//veta-app/frontend1/lib/Lali/screens/vetside_settings_page.dart
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'vet_home_page.dart';
import 'vet_appointments_page.dart';
import 'vet_dashboard.dart';
import 'vet_payment_page.dart';
import 'vet_profile.dart';

class VetsideSettingsPage extends StatefulWidget {
  @override
  _VetsideSettingsPageState createState() => _VetsideSettingsPageState();
}

class _VetsideSettingsPageState extends State<VetsideSettingsPage> {
  int _currentIndex = 4;

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
      body: ListView(
        padding: EdgeInsets.all(16.0),
        children: [
          _buildSectionHeader('Account Settings'),
          _buildSettingsItem(
            icon: Icons.person,
            title: 'Profile Settings',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => VetProfile()),
              );
            },
          ),
          _buildSettingsItem(
            icon: Icons.payment,
            title: 'Payment Settings',
            onTap: () {
              // Navigate to payment settings
            },
          ),
          _buildSettingsItem(
            icon: Icons.notifications,
            title: 'Notification Settings',
            onTap: () {
              // Navigate to notification settings
            },
          ),
          SizedBox(height: 24),
          _buildSectionHeader('App Settings'),
          _buildSettingsItem(
            icon: Icons.language,
            title: 'Language',
            onTap: () {
              // Navigate to language settings
            },
          ),
          _buildSettingsItem(
            icon: Icons.palette,
            title: 'Theme',
            onTap: () {
              // Navigate to theme settings
            },
          ),
          SizedBox(height: 24),
          _buildSectionHeader('Privacy & Security'),
          _buildSettingsItem(
            icon: Icons.privacy_tip,
            title: 'Privacy Policy',
            onTap: () {
              // Navigate to privacy policy
            },
          ),
          _buildSettingsItem(
            icon: Icons.description,
            title: 'Terms of Service',
            onTap: () {
              // Navigate to terms of service
            },
          ),
          _buildSettingsItem(
            icon: Icons.logout,
            title: 'Logout',
            onTap: () {
              // Handle logout
            },
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFF357376),
        unselectedItemColor: Colors.grey,
        currentIndex: 4, // Set to 4 for Settings tab
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
      padding: const EdgeInsets.symmetric(vertical: 8.0),
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
    return Card(
      elevation: 0,
      child: ListTile(
        leading: Icon(icon, color: Color(0xFF357376)),
        title: Text(
          title,
          style: TextStyle(
            fontFamily: 'Questrial',
            fontSize: 16,
          ),
        ),
        trailing: Icon(Icons.chevron_right, color: Colors.grey),
        onTap: onTap,
      ),
    );
  }
} 
