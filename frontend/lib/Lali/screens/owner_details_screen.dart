import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class OwnerDetailsScreen extends StatefulWidget {
  @override
  _OwnerDetailsScreenState createState() => _OwnerDetailsScreenState();
}

class _OwnerDetailsScreenState extends State<OwnerDetailsScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  String _ownerName = '';
  String _ownerEmail = '';
  String _ownerLocation = '';
  List<Map<String, dynamic>> _pets = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadOwnerDetails();
  }

  Future<void> _loadOwnerDetails() async {
    setState(() => _isLoading = true);
    
    try {
      // Get current user
      final User? user = _auth.currentUser;
      if (user != null) {
        // Load owner details from SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        String name = prefs.getString('ownerName') ?? '';
        String location = prefs.getString('ownerLocation') ?? '';

        // Load pets from Firestore
        final petsSnapshot = await _firestore
            .collection('users')
            .doc(user.uid)
            .collection('pets')
            .get();

        List<Map<String, dynamic>> pets = [];
        for (var doc in petsSnapshot.docs) {
          pets.add({
            'id': doc.id,
            ...doc.data(),
          });
        }

        setState(() {
          _ownerName = name;
          _ownerEmail = user.email ?? '';
          _ownerLocation = location;
          _pets = pets;
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Error loading owner details: $e');
      setState(() => _isLoading = false);
    }
  }

  Widget _buildPetCard(Map<String, dynamic> pet) {
    return Card(
      elevation: 4,
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      child: Container(
        decoration: BoxDecoration(
          color: Color(0xFF6BA8A9).withOpacity(0.9),
          borderRadius: BorderRadius.circular(4),
        ),
        child: ListTile(
          contentPadding: EdgeInsets.all(16),
          title: Text(
            pet['name'] ?? 'Unnamed Pet',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
              fontFamily: 'Poppins',
            ),
          ),
          subtitle: Text(
            pet['breed'] ?? 'Not specified',
            style: TextStyle(
              color: Colors.white.withOpacity(0.9),
              fontSize: 14,
              fontFamily: 'Poppins',
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Owner Details'),
        backgroundColor: Color(0xFF357376),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Owner Information Card
                  Card(
                    elevation: 4,
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Personal Information',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Poppins',
                            ),
                          ),
                          SizedBox(height: 16),
                          ListTile(
                            leading: Icon(Icons.person, color: Color(0xFF357376)),
                            title: Text('Full Name'),
                            subtitle: Text(_ownerName),
                          ),
                          ListTile(
                            leading: Icon(Icons.email, color: Color(0xFF357376)),
                            title: Text('Email'),
                            subtitle: Text(_ownerEmail),
                          ),
                          if (_ownerLocation.isNotEmpty)
                            ListTile(
                              leading: Icon(Icons.location_on, color: Color(0xFF357376)),
                              title: Text('Location'),
                              subtitle: Text(_ownerLocation),
                            ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 24),
                  // Pets Section
                  Text(
                    'My Pets',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Poppins',
                    ),
                  ),
                  SizedBox(height: 8),
                  if (_pets.isEmpty)
                    Card(
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: Center(
                          child: Text(
                            'No pets added yet',
                            style: TextStyle(
                              color: Colors.grey[600],
                            ),
                          ),
                        ),
                      ),
                    )
                  else
                    ..._pets.map(_buildPetCard).toList(),
                ],
              ),
            ),
    );
  }
} 