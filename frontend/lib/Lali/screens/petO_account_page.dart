import 'package:flutter/material.dart';
import '../../features/profile/profile_navigation.dart';
import 'package:auth_firebase/LoginSignupAuth/auth_service.dart';
import 'package:auth_firebase/Entrance/welcome_screen.dart';
import 'petO_home_page.dart';
import 'petO_activities_page.dart';

class PetOAccountPage extends StatelessWidget {
  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Text(
          'My Account',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Color(0xFF357376),
        actions: [
          IconButton(
            icon: Icon(Icons.help_outline),
            onPressed: () => ProfileNavigation.showHelpAndSupport(context),
          ),
        ],
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
                      onPressed: () =>
                          ProfileNavigation.navigateToEditProfile(context),
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
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Poppins',
                      ),
                    ),
                    SizedBox(height: 16),
                    ListTile(
                      leading: Icon(Icons.pets, color: Color(0xFF357376)),
                      title: Text('My Pets'),
                      trailing: Icon(Icons.arrow_forward_ios),
                      onTap: () => ProfileNavigation.navigateToPetDetails(
                        context,
                        // Optional parameters can be added here if available
                      ),
                    ),
                    ListTile(
                      leading: Icon(Icons.add_circle, color: Color(0xFF357376)),
                      title: Text('Add New Pet'),
                      trailing: Icon(Icons.arrow_forward_ios),
                      onTap: () => ProfileNavigation.navigateToAddPet(context),
                    ),
                    ListTile(
                      leading: Icon(Icons.event, color: Color(0xFF357376)),
                      title: Text('Pet Activities'),
                      trailing: Icon(Icons.arrow_forward_ios),
                      onTap: () =>
                          ProfileNavigation.navigateToPetActivities(context),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16),

            // Veterinary Services Section
            Card(
              elevation: 4,
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Veterinary Services',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Poppins',
                      ),
                    ),
                    SizedBox(height: 16),
                    ListTile(
                      leading: Icon(Icons.medical_services,
                          color: Color(0xFF357376)),
                      title: Text('Vet Services'),
                      trailing: Icon(Icons.arrow_forward_ios),
                      onTap: () =>
                          ProfileNavigation.navigateToVetServices(context),
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
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Poppins',
                      ),
                    ),
                    SizedBox(height: 16),
                    ListTile(
                      leading: Icon(Icons.settings, color: Color(0xFF357376)),
                      title: Text('Account Settings'),
                      trailing: Icon(Icons.arrow_forward_ios),
                      onTap: () =>
                          ProfileNavigation.showAccountSettings(context),
                    ),
                    ListTile(
                      leading:
                          Icon(Icons.person_outline, color: Color(0xFF357376)),
                      title: Text('Owner Details'),
                      trailing: Icon(Icons.arrow_forward_ios),
                      onTap: () =>
                          ProfileNavigation.navigateToAddOwnerDetails(context),
                    ),
                    ListTile(
                      leading: Icon(Icons.security, color: Color(0xFF357376)),
                      title: Text('Privacy Settings'),
                      trailing: Icon(Icons.arrow_forward_ios),
                      onTap: () {
                        //  privacy settings navigation (ToDo)
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.logout, color: Colors.red),
                      title:
                          Text('Logout', style: TextStyle(color: Colors.red)),
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
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Color(0xFF357376),
        unselectedItemColor: Colors.grey,
        currentIndex: 3, // Account tab
        onTap: (index) {
          if (index == 0) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => PetOHomePage()),
            );
          } else if (index == 1) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => PetOHomePage()),
            );
          } else if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => PetOActivitiesPage()),
            );
          } else if (index == 3) {
            // Already on Account page
          }
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.medical_services),
            label: 'Services',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment),
            label: 'Activities',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Account'),
        ],
      ),
    );
  }
}
