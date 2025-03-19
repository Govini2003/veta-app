import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart'; // For FontAwesomeIcons
import 'package:auth_firebase/LoginSignupAuth/auth_service.dart';
import 'package:auth_firebase/Entrance/welcome_screen.dart';
import 'vet_home_page.dart';
import 'vet_dashboard.dart';
import 'vet_appointments_page.dart';
import 'edit_profile_page.dart';

class VetProfile extends StatelessWidget {
  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Text('Veterinarian Profile',
            style: TextStyle(fontFamily: 'Poppins', color: Colors.white)),
        backgroundColor: Color(0xFF357376),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header Area
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 50, // Large circular display
                        backgroundImage: AssetImage(
                            'assets/profile_photo.png'), // Placeholder for profile photo
                      ),
                      SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Dr. FirstName LastName',
                              style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Poppins')), // Updated font
                          SizedBox(height: 4),
                          Text('SLVC Registration: 123456 - 2023',
                              style: TextStyle(
                                  fontSize: 14,
                                  fontFamily: 'Questrial')), // Updated font
                          SizedBox(height: 4),
                          Text('Verified',
                              style: TextStyle(
                                  color: Colors
                                      .green)), // Or "Pending Verification"
                        ],
                      ),
                      Spacer(),
                    ],
                  ),
                  SizedBox(height: 20),

                  // Profile Sections (Expandable/Collapsible)
                  _buildExpandableSection('Personal Details',
                      'Details about personal information...'),
                  _buildExpandableSection('Contact Information',
                      'Details about contact information...'),
                  _buildExpandableSection('Professional Credentials',
                      'Details about credentials...'),
                  _buildExpandableSection(
                      'Practice Information', 'Details about practice...'),
                  _buildExpandableSection(
                      'Services & Fees', 'Details about services...'),
                  _buildExpandableSection(
                      'Service Availability', 'Details about availability...'),
                  _buildExpandableSection('Payment Methods Accepted',
                      'Details about payment methods...'),

                  // Add Logout Section
                  SizedBox(height: 20),
                  Card(
                    elevation: 2,
                    color: Colors.red.shade50,
                    child: ListTile(
                      leading: Icon(Icons.logout, color: Colors.red),
                      title: Text('Logout',
                          style: TextStyle(
                              color: Colors.red, fontFamily: 'Poppins')),
                      onTap: () async {
                        try {
                          await _authService.logoutUser();
                          // Navigate to welcome screen and remove all previous routes
                          Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                                builder: (context) => WelcomeScreen()),
                            (route) => false,
                          );
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content:
                                    Text('Logout failed: ${e.toString()}')),
                          );
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 20), // Add some space above the button
          Center(
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => EditProfilePage()),
                );
              },
              child: Text('Edit Profile',
                  style: TextStyle(
                      fontFamily: 'Poppins',
                      color: Colors.white)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF357376),
              ),
            ),
          ),
          SizedBox(height: 20), // Add space below the button
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFF357376),
        unselectedItemColor: Colors.grey,
        currentIndex: 4, // Settings tab
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.calendar_today), label: 'Appointments'),
          BottomNavigationBarItem(
              icon: Icon(Icons.business), label: 'Insights'),
          BottomNavigationBarItem(icon: Icon(Icons.money), label: 'Payments'),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings), label: 'Settings'),
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
              // Navigate to Payments (not implemented yet)
              break;
            case 4:
              // Already on Profile/Settings page
              break;
          }
        },
      ),
    );
  }

  Widget _buildExpandableSection(String title, String content) {
    return ExpansionTile(
      title: Text(title,
          style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              fontFamily: 'Poppins')), // Updated font
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(content,
              style: TextStyle(fontFamily: 'Questrial')), // Updated font
        ),
      ],
    );
  }
}
