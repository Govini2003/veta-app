import 'package:flutter/material.dart';
import 'petO_home_page.dart';
import 'petO_account_page.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class PetOActivitiesPage extends StatefulWidget {
  const PetOActivitiesPage({Key? key}) : super(key: key);

  @override
  _PetOActivitiesPageState createState() => _PetOActivitiesPageState();
}

class _PetOActivitiesPageState extends State<PetOActivitiesPage> {
  int _currentIndex = 0;

  final List<String> _ongoingActivities = [
    'Vaccination Appointment',
    'Grooming Session',
  ];
  final List<String> _completedActivities = [
    'Vet Checkup',
    'Training Class',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
                      color: _currentIndex == 0 ? const Color(0xFF64CCC5) : Colors.grey,
                      decoration: _currentIndex == 0 ? TextDecoration.underline : null,
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
                      color: _currentIndex == 1 ? const Color(0xFF64CCC5) : Colors.grey,
                      decoration: _currentIndex == 1 ? TextDecoration.underline : null,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: _currentIndex == 0
                ? _buildActivityList(_ongoingActivities)
                : _buildActivityList(_completedActivities),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color(0xFF357376),
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white54,
        items: const [
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
        currentIndex: 2,
        onTap: (index) {
          if (index == 0) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => PetOHomePage()),
            );
          } else if (index == 1) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => PetOHomePage()),
            );
          } else if (index == 3) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => PetOAccountPage()),
            );
          }
        },
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
}
