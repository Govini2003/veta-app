// veta-app/frontend1/lib/Lali/screens/pet_services_screen.dart

import 'package:flutter/material.dart';
import 'vets_screen.dart';
import 'petO_home_page.dart';
import 'petO_activities_page.dart';
import 'petO_account_page.dart';

class PetServicesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Pet Services',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Find a Vet Button
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => VetsScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF1D4D4F),
                  padding: EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'Find a Vet',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),

            // Available Services Section
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Available Services',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 16),
                  
                  // Veterinary Section
                  _buildExpandableService(
                    'Veterinary',
                    Icons.medical_services,
                    [
                      'General Checkup',
                      'Vaccination',
                      'Surgery',
                      'Emergency Care',
                      'Dental Care',
                    ],
                  ),

                  // Pet Grooming Section.
                  _buildExpandableService(
                    'Pet Grooming',
                    Icons.content_cut,
                    [
                      'Bath & Brush',
                      'Hair Cut',
                      'Nail Trimming',
                      'Ear Cleaning',
                      'Teeth Brushing',
                    ],
                  ),

                  // Pet Training Section.
                  _buildExpandableService(
                    'Pet Training',
                    Icons.school,
                    [
                      'Basic Obedience',
                      'Behavior Modification',
                      'Puppy Training',
                      'Advanced Training',
                      'Group Classes',
                    ],
                  ),

                  // Pet Sitting Section
                  _buildExpandableService(
                    'Pet Sitting',
                    Icons.pets,
                    [
                      'Day Care',
                      'Overnight Stay',
                      'Dog Walking',
                      'Home Visits',
                    ],
                    initiallyExpanded: true,
                  ),
                ],
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
          currentIndex: 1,
          onTap: (index) {
            if (index == 0) {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => PetOHomePage()),
              );
            } else if (index == 1) {
              // Already on Services page
            } else if (index == 2) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PetOActivitiesPage()),
              );
            } else if (index == 3) {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => PetOAccountPage()),
              );
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

  Widget _buildExpandableService(
    String title,
    IconData icon,
    List<String> services, {
    bool initiallyExpanded = false,
  }) {
    return Card(
      margin: EdgeInsets.only(bottom: 8),
      child: ExpansionTile(
        initiallyExpanded: initiallyExpanded,
        leading: Icon(icon, color: Color(0xFF1D4D4F)),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        children: services.map((service) {
          if (title == 'Pet Sitting' && initiallyExpanded) {
            return ListTile(
              title: Text(service),
              trailing: Switch(
                value: false,
                onChanged: (bool value) {},
                activeColor: Color(0xFF1D4D4F),
              ),
            );
          }
          return ListTile(
            title: Text(service),
          );
        }).toList(),
      ),
    );
  }
} 
