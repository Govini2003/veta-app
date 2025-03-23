// veta-app/frontend1/lib/Lali/screens/chat_list_screen.dart
import 'package:flutter/material.dart';

class ChatListScreen extends StatelessWidget {
  // Mock data for chat list
  final List<Map<String, dynamic>> chats = [
    {
      'id': '1',
      'name': 'Dr. Smith',
      'lastMessage': 'Hello, how can I help?',
      'timestamp': '10:30 AM',
      'unread': true,
    },
    {
      'id': '2',
      'name': 'John Doe',
      'lastMessage': 'Thank you for the consultation!',
      'timestamp': 'Yesterday',
      'unread': false,
    },
    {
      'id': '3',
      'name': 'Sarah Johnson',
      'lastMessage': 'Can we reschedule the appointment?',
      'timestamp': '2 days ago',
      'unread': true,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Messages',
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
        itemCount: chats.length,
        itemBuilder: (context, index) {
          final chat = chats[index];
          return Card(
            margin: EdgeInsets.only(bottom: 16),
            elevation: 2,
            child: ListTile(
              contentPadding: EdgeInsets.all(16),
              leading: CircleAvatar(
                child: Text(chat['name'][0]),
              ),
              title: Text(
                chat['name'],
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
                    chat['lastMessage'],
                    style: TextStyle(
                      fontFamily: 'Questrial',
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    chat['timestamp'],
                    style: TextStyle(
                      fontFamily: 'Questrial',
                      fontSize: 12,
                      color: Colors.grey[500],
                    ),
                  ),
                ],
              ),
              trailing: chat['unread']
                  ? Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        color: Color(0xFF64CCC5), // Greenish color
                        shape: BoxShape.circle,
                      ),
                    )
                  : null,
              onTap: () {
                // Print a message to the console when a chat is tapped
                print('Chat with ${chat['name']} tapped');
              },
            ),
          );
        },
      ),
    );
  }
} 
