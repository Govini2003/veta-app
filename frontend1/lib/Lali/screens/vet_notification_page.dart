//veta-app/frontend1/lib/Lali/screens/vet_notification_page.dart
import 'package:flutter/material.dart';

class VetNotificationsPage extends StatelessWidget {
  // Mock data for notifications
  final List<Map<String, String>> notifications = [
    {
      'title': 'New Appointment Request',
      'message': 'John Doe has requested an appointment for Max (Dog).',
      'time': '10:30 AM',
    },
    {
      'title': 'Payment Received',
      'message': 'Payment of \$150 received for vaccination services.',
      'time': 'Yesterday',
    },
    {
      'title': 'Appointment Reminder',
      'message': 'You have an appointment with Sarah Johnson at 2:00 PM today.',
      'time': '9:00 AM',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Notifications',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black), // Back button color
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          final notification = notifications[index];
          return Card(
            margin: EdgeInsets.only(bottom: 16),
            elevation: 2,
            child: ListTile(
              contentPadding: EdgeInsets.all(16),
              leading: Icon(
                Icons.notifications,
                color: Color(0xFF357376), // Primary color
              ),
              title: Text(
                notification['title']!,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 4),
                  Text(
                    notification['message']!,
                    style: TextStyle(
                      fontFamily: 'Questrial',
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    notification['time']!,
                    style: TextStyle(
                      fontFamily: 'Questrial',
                      fontSize: 12,
                      color: Colors.grey[500],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
} 
