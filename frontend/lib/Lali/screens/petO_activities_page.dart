import 'package:flutter/material.dart';
import 'petO_home_page.dart';
import 'petO_account_page.dart';
import 'pet_services_screen.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class PetOActivitiesPage extends StatefulWidget {
  const PetOActivitiesPage({Key? key}) : super(key: key);

  @override
  _PetOActivitiesPageState createState() => _PetOActivitiesPageState();
}

class _PetOActivitiesPageState extends State<PetOActivitiesPage> {
  int _currentIndex = 0;
  int _selectedRating = 0;

  final List<String> _ongoingActivities = [
    'Vaccination Appointment',
    'Grooming Session',
  ];
  final List<String> _completedActivities = [
    'Vet Checkup',
    'Training Class',
  ];

  final List<Map<String, dynamic>> _reviews = [
    {
      'service': 'Vet Checkup',
      'vet': 'Dr. Smith',
      'rating': 4.5,
      'review': 'Great service! Very professional and caring.',
      'date': '2024-02-20',
    },
    {
      'service': 'Vaccination',
      'vet': 'Dr. Johnson',
      'rating': 5.0,
      'review': 'Excellent care for my pet. Highly recommended!',
      'date': '2024-02-15',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: const Text(
          'Your Activities',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.tune),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          // Tab Bar
          Container(
            margin: const EdgeInsets.symmetric(vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _currentIndex = 0;
                    });
                  },
                  child: Text(
                    'Ongoing',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: _currentIndex == 0
                          ? const Color(0xFF64CCC5)
                          : Colors.grey,
                      decoration:
                          _currentIndex == 0 ? TextDecoration.underline : null,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _currentIndex = 1;
                    });
                  },
                  child: Text(
                    'Completed',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: _currentIndex == 1
                          ? const Color(0xFF64CCC5)
                          : Colors.grey,
                      decoration:
                          _currentIndex == 1 ? TextDecoration.underline : null,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _currentIndex = 2;
                    });
                  },
                  child: Text(
                    'Reviews',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: _currentIndex == 2
                          ? const Color(0xFF64CCC5)
                          : Colors.grey,
                      decoration:
                          _currentIndex == 2 ? TextDecoration.underline : null,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: _currentIndex == 0
                ? _buildActivityList(_ongoingActivities)
                : _currentIndex == 1
                    ? _buildActivityList(_completedActivities)
                    : _buildReviewsList(),
          ),
        ],
      ),
      floatingActionButton: _currentIndex == 2
          ? FloatingActionButton(
              onPressed: () {
                _showAddReviewDialog(context);
              },
              backgroundColor: const Color(0xFF64CCC5),
              child: const Icon(Icons.add),
            )
          : null,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Color(0xFF6BA8A9),
        ),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          backgroundColor: Color(0xFF6BA8A9),
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.white.withOpacity(0.7),
          currentIndex: 2,
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
              // Already on Activities page
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

  Widget _buildActivityList(List<String> activities) {
    return ListView.builder(
      itemCount: activities.length,
      itemBuilder: (context, index) {
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              activities[index],
              style: const TextStyle(fontSize: 16),
            ),
          ),
        );
      },
    );
  }

  Widget _buildReviewsList() {
    return ListView.builder(
      itemCount: _reviews.length,
      itemBuilder: (context, index) {
        final review = _reviews[index];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      review['service'],
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      review['date'],
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  review['vet'],
                  style: const TextStyle(
                    fontSize: 16,
                    color: Color(0xFF64CCC5),
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    ...List.generate(
                      5,
                      (i) => Icon(
                        i < review['rating'] ? Icons.star : Icons.star_border,
                        color: Colors.amber,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      review['rating'].toString(),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  review['review'],
                  style: const TextStyle(fontSize: 14),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showAddReviewDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Add Review'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Service',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Veterinarian',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Your Review',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  5,
                  (index) => IconButton(
                    icon: Icon(
                      index < _selectedRating ? Icons.star : Icons.star_border,
                      color: index < _selectedRating ? Colors.amber : Colors.grey,
                    ),
                    onPressed: () {
                      setState(() {
                        _selectedRating = index + 1;
                      });
                    },
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                _selectedRating = 0;
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                _selectedRating = 0;
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF64CCC5),
              ),
              child: const Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}
