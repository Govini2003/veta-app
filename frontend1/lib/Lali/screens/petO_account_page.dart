// veta-app/frontend1/lib/Lali/screens/petO_account_page.dart

import 'package:flutter/material.dart';
import '../../features/profile/profile_navigation.dart';
import 'package:auth_firebase/LoginSignupAuth/auth_service.dart';
import 'package:auth_firebase/Entrance/welcome_screen.dart';
import 'petO_home_page.dart';
import 'petO_activities_page.dart';
import 'petO_coll_page.dart';
import 'veta_account_page.dart';
import 'pet_services_screen.dart';
import 'edit_profile_screen.dart';
import 'owner_details_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PetOAccountPage extends StatefulWidget {
  @override
  _PetOAccountPageState createState() => _PetOAccountPageState();
}

class _PetOAccountPageState extends State<PetOAccountPage> {
  final AuthService _authService = AuthService();
  String _ownerName = 'Pet Owner Name';
  String _ownerLocation = '';

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  Future<void> _loadProfileData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _ownerName = prefs.getString('ownerName') ?? 'Pet Owner Name';
      _ownerLocation = prefs.getString('ownerLocation') ?? '';
    });
  }

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
                      _ownerName,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Poppins',
                      ),
                    ),
                    if (_ownerLocation.isNotEmpty) ...[
                      SizedBox(height: 8),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Color(0xFF6BA8A9).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.location_on,
                              color: Color(0xFF357376),
                              size: 16,
                            ),
                            SizedBox(width: 4),
                            Text(
                              _ownerLocation,
                              style: TextStyle(
                                fontSize: 14,
                                color: Color(0xFF357376),
                                fontFamily: 'Poppins',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                    SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: () async {
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EditProfileScreen(),
                          ),
                        );
                        if (result == true) {
                          _loadProfileData();
                        }
                      },
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
                    _buildAccountItem(
                      context,
                      'My Pets',
                      Icons.pets,
                      () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MyPetsPage(),
                          ),
                        );
                      },
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

            // Veta Section
            Card(
              elevation: 4,
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Veta',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Poppins',
                      ),
                    ),
                    SizedBox(height: 16),
                    ListTile(
                      leading: Icon(Icons.account_circle, color: Color(0xFF357376)),
                      title: Text('Veta Account'),
                      trailing: Icon(Icons.arrow_forward_ios),
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => VetaAccountPage()),
                      ),
                    ),
                    ListTile(
                      leading: Icon(Icons.stars, color: Color(0xFF357376)),
                      title: Text('Veta Points'),
                      trailing: Icon(Icons.arrow_forward_ios),
                      onTap: () {
                        // Navigate to Veta Points
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.card_giftcard, color: Color(0xFF357376)),
                      title: Text('Veta Rewards'),
                      trailing: Icon(Icons.arrow_forward_ios),
                      onTap: () {
                        // Navigate to Veta Rewards
                      },
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
                      leading: Icon(Icons.person_outline, color: Color(0xFF357376)),
                      title: Text('Owner Details'),
                      trailing: Icon(Icons.arrow_forward_ios),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => OwnerDetailsScreen(),
                          ),
                        );
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.notifications, color: Color(0xFF357376)),
                      title: Text('Notification Settings'),
                      trailing: Icon(Icons.arrow_forward_ios),
                      onTap: () {
                        // Navigate to Notification Settings
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.privacy_tip, color: Color(0xFF357376)),
                      title: Text('Privacy Settings'),
                      trailing: Icon(Icons.arrow_forward_ios),
                      onTap: () {
                        // Navigate to Privacy Settings
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
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Color(0xFF6BA8A9),
        ),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          backgroundColor: Color(0xFF6BA8A9),
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.white.withOpacity(0.7),
          currentIndex: 3,
          onTap: (index) {
            if (index == 0) {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => PetOHomePage()),
              );
            } else if (index == 1) {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => PetServicesScreen()),
              );
            } else if (index == 2) {
              Navigator.of(context).pushReplacement(
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
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Account',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAccountItem(BuildContext context, String title, IconData icon, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: Color(0xFF357376)),
      title: Text(title),
      trailing: Icon(Icons.arrow_forward_ios),
      onTap: onTap,
    );
  }
}
