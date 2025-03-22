import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'petO_home_page.dart'; // Import Pet Owner Home Page
import 'petO_account_page.dart'; // Import Pet Owner Account Page
import 'vet_dashboard.dart'; // Import Vet Dashboard
import 'vet_profile.dart'; // Import Vet Profile
import 'vet_appointments_page.dart';
import 'vet_payment_page.dart';
import 'vetside_settings_page.dart';
import 'vet_notification_page.dart';
import 'chat_list_screen.dart';
import 'vetside_review_page.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart'; // For FontAwesomeIcons

class VetHomePage extends StatefulWidget {
  @override
  _VetHomePageState createState() => _VetHomePageState();
}

class _VetHomePageState extends State<VetHomePage> {
  DateTime? _lastBackPressTime;

  Future<bool> _onWillPop() async {
    final now = DateTime.now();
    if (_lastBackPressTime == null ||
        now.difference(_lastBackPressTime!) > const Duration(seconds: 2)) {
      _lastBackPressTime = now;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Press back again to exit'),
          duration: Duration(seconds: 2),
        ),
      );
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor:
            Color(0xFF6BA8A9), // Set the background color to #64CCC5
        appBar: AppBar(
          automaticallyImplyLeading: false, // This will remove the back arrow
          backgroundColor: Colors.white,
          elevation: 0, // Removes shadow
          title: Text(
            'Welcome, Dr. Smith',
            style: TextStyle(color: Colors.black), // Match title color
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.notifications, color: Colors.black),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => VetNotificationsPage()),
                );
              },
            ),
            IconButton(
              icon: Icon(Icons.message, color: Colors.black),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ChatListScreen()),
                );
              },
            ),
            IconButton(
              icon: Icon(Icons.account_circle),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          VetProfile()), // Navigate to Vet Profile
                );
              },
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  mainAxisSpacing: 16.0,
                  crossAxisSpacing: 16.0,
                  children: [
                    _buildCard(
                      'Next Appointment',
                      Icons.calendar_today,
                      '12:30 PM, 25 Feb 2025',
                      'View All',
                      const Color(0xFFF2F2F7),
                    ),
                    _buildCard(
                      'Today\'s Earnings',
                      Icons.attach_money,
                      '\$250',
                      'Monthly: \$5000',
                      const Color(0xFFF2F2F7),
                    ),
                    _buildAvailabilityCard(),
                    _buildCard(
                      'Pending Bookings',
                      Icons.pending_actions,
                      '3 New Requests',
                      'Accept/Reject',
                      const Color(0xFFF2F2F7),
                    ),
                    _buildCard(
                      'Emergency Requests',
                      Icons.warning,
                      '1 Urgent Case',
                      'Respond',
                      const Color(0xFFF2F2F7),
                    ),
                    _buildReviewsAndRatingsCard(),
                  ],
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          selectedItemColor: const Color(0xFF357376),
          unselectedItemColor: Colors.grey,
          currentIndex: 0, // Set to 0 for Home tab
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
                // Already on Home page
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
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => VetsideSettingsPage()),
                );
                break;
            }
          },
        ),
      ),
    );
  }

  Widget _buildCard(
    String title,
    IconData icon,
    String subtitle,
    String actionText,
    Color backgroundColor,
  ) {
    return Card(
      color: backgroundColor,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 32, color: const Color(0xFF357376)),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.bottomRight,
              child: TextButton(
                onPressed: () {
                  if (title == 'Next Appointment') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => VetAppointmentsPage()),
                    );
                  } else if (title == "Today's Earnings") {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => VetPaymentPage()),
                    );
                  }
                },
                child: Text(actionText,
                    style: const TextStyle(color: Color(0xFF357376))),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAvailabilityCard() {
    bool isAvailable = true; // You should manage this state properly

    return Card(
      color: const Color(0xFFF2F2F7),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  isAvailable ? Icons.check_circle : Icons.cancel,
                  size: 32,
                  color: isAvailable ? const Color(0xFF357376) : Colors.red,
                ),
                const SizedBox(width: 12),
                Text(
                  'Availability',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: isAvailable ? const Color(0xFF357376) : Colors.red,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              isAvailable ? 'Available' : 'Not Available',
              style: TextStyle(
                fontSize: 14,
                color: isAvailable ? Colors.green : Colors.red,
              ),
            ),
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.bottomRight,
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    isAvailable = !isAvailable;
                  });
                  // Here you should also update the availability status in your backend
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: isAvailable ? Colors.red : const Color(0xFF357376),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                ),
                child: Text(
                  isAvailable ? 'Set Unavailable' : 'Set Available',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReviewsAndRatingsCard() {
    return Card(
      color: const Color(0xFFF2F2F7),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => VetsideReviewPage()),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.star,
                    size: 28,
                    color: const Color(0xFF357376),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Reviews',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF357376),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Text(
                    '4.8',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF357376),
                    ),
                  ),
                  const SizedBox(width: 4),
                  Row(
                    children: List.generate(
                      5,
                      (index) => const Icon(
                        Icons.star,
                        size: 14,
                        color: Colors.amber,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                '150 reviews',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
