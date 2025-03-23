//veta-app/frontend1/lib/Lali/screens/petO_home_page.dart
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'petO_home_page.dart';

class PetONotificationScreen extends StatelessWidget {
  const PetONotificationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Notifications',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          TextButton(
            onPressed: () {
              // Implement mark all as read functionality
            },
            child: const Text(
              'Mark all as read',
              style: TextStyle(
                color: Color(0xFF64CCC5),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: 5, // Sample data
        itemBuilder: (context, index) {
          return _buildNotificationItem(
            context,
            [
              'Appointment Reminder',
              'New Message',
              'Service Update',
              'Payment Confirmation',
              'Profile Update',
            ][index],
            [
              'Your appointment with Dr. Smith is tomorrow at 2:00 PM',
              'Dr. Johnson sent you a new message',
              'Your grooming service has been confirmed',
              'Payment of \$50 has been processed successfully',
              'Your profile has been updated successfully',
            ][index],
            '2 hours ago',
            index < 2, // First two notifications are unread
          );
        },
      ),
    );
  }

  Widget _buildNotificationItem(
    BuildContext context,
    String title,
    String message,
    String time,
    bool isUnread,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: isUnread ? Colors.blue[50] : Colors.white,
        border: Border(
          bottom: BorderSide(
            color: Colors.grey[200]!,
          ),
        ),
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: const Color(0xFF64CCC5),
          child: Icon(
            _getNotificationIcon(title),
            color: Colors.white,
          ),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              message,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 4),
            Text(
              time,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[500],
              ),
            ),
          ],
        ),
        trailing: isUnread
            ? Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: Color(0xFF64CCC5),
                  shape: BoxShape.circle,
                ),
              )
            : null,
        onTap: () {
          // Handle notification tap
        },
      ),
    );
  }

  IconData _getNotificationIcon(String title) {
    switch (title) {
      case 'Appointment Reminder':
        return Icons.calendar_today;
      case 'New Message':
        return Icons.message;
      case 'Service Update':
        return Icons.medical_services;
      case 'Payment Confirmation':
        return Icons.payment;
      case 'Profile Update':
        return Icons.person;
      default:
        return Icons.notifications;
    }
  }
} 
