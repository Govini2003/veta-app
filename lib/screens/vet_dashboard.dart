// veta-app/lib/screens/vet_dashboard.dart
// Navigating Through Insights in Bottom Navigation Bar

import 'package:flutter/material.dart';
import 'petO_home_page.dart'; // Pet Owner Home Page
import 'petO_account_page.dart'; // Pet Owner Account Page
import 'vet_home_page.dart'; // VetHomePage
import 'package:font_awesome_flutter/font_awesome_flutter.dart'; //FontAwesomeIcons

class VetDashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Veta.lk - Vet Dashboard',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Color(0xFF357376),
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              // Navigate to settings page
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome Section
            Text(
              'Welcome, Dr. Smith!',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Color(0xFF357376),
              ),
            ),
            SizedBox(height: 20),

            // Quick Actions Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                QuickActionButton(
                  icon: Icons.calendar_today,
                  label: 'Appointments',
                  onTap: () {
                    // Navigate to appointments page
                  },
                ),
                QuickActionButton(
                  icon: Icons.pets,
                  label: 'Add Patient',
                  onTap: () {
                    // Navigate to add patient page
                  },
                ),
                QuickActionButton(
                  icon: Icons.message,
                  label: 'Messages',
                  onTap: () {
                    // Navigate to messages page
                  },
                ),
              ],
            ),
            SizedBox(height: 30),

            // Upcoming Appointments Section
            Text(
              'Upcoming Appointments',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF357376),
              ),
            ),
            SizedBox(height: 10),
            AppointmentCard(
              patientName: 'Buddy',
              time: '10:00 AM',
              date: 'Oct 25, 2023',
            ),
            AppointmentCard(
              patientName: 'Max',
              time: '2:00 PM',
              date: 'Oct 25, 2023',
            ),
            SizedBox(height: 30),

            // Statistics Section
            Text(
              'Statistics',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF357376),
              ),
            ),
            SizedBox(height: 10),
            Row(
              children: [
                StatCard(
                  title: 'Total Patients',
                  value: '120',
                  icon: Icons.people,
                ),
                SizedBox(width: 10),
                StatCard(
                  title: "Today's Appointments",
                  value: '5',
                  icon: Icons.calendar_today,
                ),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFF357376),
        unselectedItemColor: Colors.grey,
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
                MaterialPageRoute(builder: (context) => VetHomePage()), // Navigate to Vet Home Page
              );
              break;
            case 1:
              // Navigate to Appointments
              break;
            case 2:
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => VetDashboard()), // Navigate to Vet Dashboard
              );
              break;
            case 3:
              // Navigate to Payments
              break;
            case 4:
              // Navigate to Settings
              break;
          }
        },
      ),
    );
  }
}

// Custom Widget: Quick Action Button
class QuickActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  QuickActionButton({required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Color(0xFF6BA8A9),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 32, color: Colors.white),
          ),
          SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              fontFamily: 'Questrial',
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF357376),
            ),
          ),
        ],
      ),
    );
  }
}

// Custom Widget: Appointment Card
class AppointmentCard extends StatelessWidget {
  final String patientName;
  final String time;
  final String date;

  AppointmentCard({required this.patientName, required this.time, required this.date});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(bottom: 10),
      child: ListTile(
        leading: Icon(Icons.pets, color: Color(0xFF357376)),
        title: Text(
          patientName,
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          '$time - $date',
          style: TextStyle(
            fontFamily: 'Questrial',
            fontSize: 14,
          ),
        ),
        trailing: Icon(Icons.arrow_forward, color: Color(0xFF357376)),
      ),
    );
  }
}

// Custom Widget: Stat Card
class StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;

  StatCard({required this.title, required this.value, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, size: 32, color: Color(0xFF357376)),
              SizedBox(height: 10),
              Text(
                value,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                title,
                style: TextStyle(
                  fontFamily: 'Questrial',
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
