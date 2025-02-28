import 'package:flutter/material.dart';
import 'package:veta_1/features/profile/profile_navigation.dart';

class PetOAccountPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'My Account',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Color(0xFF357376),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Profile Section
            Card(
              elevation: 4,
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: Color(0xFF6BA8A9),
                      child: Icon(Icons.person, size: 50, color: Colors.white),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Pet Owner Name',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Poppins',
                      ),
                    ),
                    SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: () => ProfileNavigation.navigateToEditProfile(context),
                      child: Text('Edit Profile'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF357376),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16),
            
            // Pet Management Section
            Card(
              elevation: 4,
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Pet Management',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Poppins',
                      ),
                    ),
                    SizedBox(height: 16),
                    ListTile(
                      leading: Icon(Icons.pets, color: Color(0xFF357376)),
                      title: Text('My Pets'),
                      trailing: Icon(Icons.arrow_forward_ios),
                      onTap: () => ProfileNavigation.navigateToPetDetails(context),
                    ),
                    ListTile(
                      leading: Icon(Icons.add_circle, color: Color(0xFF357376)),
                      title: Text('Add New Pet'),
                      trailing: Icon(Icons.arrow_forward_ios),
                      onTap: () => ProfileNavigation.navigateToAddPet(context),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16),

            // Account Settings Section
            Card(
              elevation: 4,
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Account Settings',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Poppins',
                      ),
                    ),
                    SizedBox(height: 16),
                    ListTile(
                      leading: Icon(Icons.person_outline, color: Color(0xFF357376)),
                      title: Text('Owner Details'),
                      trailing: Icon(Icons.arrow_forward_ios),
                      onTap: () => ProfileNavigation.navigateToAddOwnerDetails(context),
                    ),
                    ListTile(
                      leading: Icon(Icons.security, color: Color(0xFF357376)),
                      title: Text('Privacy Settings'),
                      trailing: Icon(Icons.arrow_forward_ios),
                      onTap: () {
                        // TODO: Implement privacy settings navigation
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
