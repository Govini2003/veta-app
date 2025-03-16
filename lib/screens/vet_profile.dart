// veta-app/lib/screens/vet_profile.dart
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart'; // For FontAwesomeIcons

class VetProfile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Veterinarian Profile', style: TextStyle(fontFamily: 'Poppins', color: Colors.white)),
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
                        backgroundImage: AssetImage('assets/profile_photo.png'), // Placeholder for profile photo
                      ),
                      SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Dr. FirstName LastName', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, fontFamily: 'Poppins')), // Updated font
                          SizedBox(height: 4),
                          Text('SLVC Registration: 123456 - 2023', style: TextStyle(fontSize: 14, fontFamily: 'Questrial')), // Updated font
                          SizedBox(height: 4),
                          Text('Verified', style: TextStyle(color: Colors.green)), // Or "Pending Verification"
                        ],
                      ),
                      Spacer(),
                    ],
                  ),
                  SizedBox(height: 20),

                  // Profile Sections (Expandable/Collapsible)
                  _buildExpandableSection('Personal Details', 'Details about personal information...'),
                  _buildExpandableSection('Contact Information', 'Details about contact information...'),
                  _buildExpandableSection('Professional Credentials', 'Details about credentials...'),
                  _buildExpandableSection('Practice Information', 'Details about practice...'),
                  _buildExpandableSection('Services & Fees', 'Details about services...'),
                  _buildExpandableSection('Service Availability', 'Details about availability...'),
                  _buildExpandableSection('Payment Methods Accepted', 'Details about payment methods...'),
                ],
              ),
            ),
          ),
          SizedBox(height: 20), 
          Center(
            child: ElevatedButton(
              onPressed: () {
                // Navigate to edit profile functionality
              },
              child: Text('Edit Profile', style: TextStyle(fontFamily: 'Poppins', color: Colors.white)), // Updated font color to white
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF357376), 
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExpandableSection(String title, String content) {
    return ExpansionTile(
      title: Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, fontFamily: 'Poppins')), // font
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(content, style: TextStyle(fontFamily: 'Questrial')), //  font
        ),
      ],
    );
  }
}
