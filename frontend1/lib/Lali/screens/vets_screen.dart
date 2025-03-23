//veta-app/frontend1/lib/Lali/screens/vets_screen.dart 
import 'package:flutter/material.dart';
import '../widgets/search_bar_widget.dart';
import 'vet_profile_screen.dart';
import 'booking_screen.dart';

class VetsScreen extends StatefulWidget {
  @override
  _VetsScreenState createState() => _VetsScreenState();
}

class _VetsScreenState extends State<VetsScreen> {
  List<Map<String, dynamic>> vets = [
    {
      'name': 'Dr. Sarah Johnson',
      'specialty': 'Small Animals',
      'rating': 4.8,
      'experience': '8 years',
      'image': 'assets/images/vets/dr_sarah.jpg',
      'location': {
        'latitude': 6.9271,
        'longitude': 79.8612,
        'address': 'Colombo 03, Sri Lanka'
      },
    },
    {
      'name': 'Dr. Michael Brown',
      'specialty': 'Surgery Specialist',
      'rating': 4.9,
      'experience': '12 years',
      'image': 'assets/images/vets/dr_michael.jpg',
      'location': {
        'latitude': 6.8995,
        'longitude': 79.8556,
        'address': 'Colombo 04, Sri Lanka'
      },
    },
    {
      'name': 'Dr. Emily Chen',
      'specialty': 'Feline Specialist',
      'rating': 4.7,
      'experience': '6 years',
      'image': 'assets/images/vets/dr_emily.jpg',
      'location': {
        'latitude': 6.9061,
        'longitude': 79.8636,
        'address': 'Colombo 05, Sri Lanka'
      },
    },
    {
      'name': 'Dr. James Wilson',
      'specialty': 'Emergency Care',
      'rating': 4.9,
      'experience': '15 years',
      'image': 'assets/images/vets/dr_james.jpg',
      'location': {
        'latitude': 6.8866,
        'longitude': 79.8599,
        'address': 'Dehiwala, Sri Lanka'
      },
    },
    {
      'name': 'Dr. Maria Garcia',
      'specialty': 'Exotic Pets',
      'rating': 4.8,
      'experience': '10 years',
      'image': 'assets/images/vets/dr_maria.jpg',
      'location': {
        'latitude': 6.9147,
        'longitude': 79.8729,
        'address': 'Kollupitiya, Sri Lanka'
      },
    }
  ];

  List<Map<String, dynamic>> filteredVets = [];

  @override
  void initState() {
    super.initState();
    filteredVets = vets;
  }

  void _handleSearch(String query) {
    setState(() {
      filteredVets = vets
          .where((vet) =>
              vet['name'].toLowerCase().contains(query.toLowerCase()) ||
              vet['specialty'].toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Veterinarians'),
        backgroundColor: const Color(0xFF6BA8A9),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SearchBarWidget(
              onSearch: _handleSearch,
              hintText: 'Search veterinarians...',
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: filteredVets.length,
              itemBuilder: (context, index) {
                final vet = filteredVets[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  elevation: 2,
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => VetProfileScreen(vet: vet),
                        ),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 30,
                            backgroundImage: AssetImage(vet['image']),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  vet['name'],
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(vet['specialty']),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    Icon(Icons.star, color: Colors.amber, size: 18),
                                    Text(' ${vet['rating']} • ${vet['experience']}'),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    Icon(Icons.location_on,
                                        color: Color(0xFF6BA8A9), size: 16),
                                    const SizedBox(width: 4),
                                    Expanded(
                                      child: Text(
                                        vet['location']['address'],
                                        style: TextStyle(
                                          color: Colors.grey[600],
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Column(
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => BookingScreen(vet: vet),
                                    ),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF6BA8A9),
                                ),
                                child: const Text('Book'),
                              ),
                              const SizedBox(height: 8),
                              TextButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          VetProfileScreen(vet: vet),
                                    ),
                                  );
                                },
                                child: const Text('View Profile'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
} 
