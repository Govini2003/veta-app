//veta-app/frontend1/lib/Lali/screens/pharmacies_screen.dart
import 'package:flutter/material.dart';
import '../widgets/search_bar_widget.dart';

class PharmaciesScreen extends StatefulWidget {
  @override
  _PharmaciesScreenState createState() => _PharmaciesScreenState();
}

class _PharmaciesScreenState extends State<PharmaciesScreen> {
  List<Map<String, dynamic>> pharmacies = [
    {
      'name': 'PetMed Pharmacy',
      'address': '789 Health Street, City',
      'rating': 4.6,
      'openHours': '8:00 AM - 10:00 PM',
      'image': 'assets/images/pharmacies/petmed.jpg',
    },
    {
      'name': 'VetCare Pharmacy',
      'address': '321 Medicine Road, Town',
      'rating': 4.8,
      'openHours': '24 Hours',
      'image': 'assets/images/pharmacies/vetcare.jpg',
    },
    {
      'name': 'Pet Wellness Pharmacy',
      'address': '456 Health Avenue, City',
      'rating': 4.7,
      'openHours': '9:00 AM - 9:00 PM',
      'image': 'assets/images/pharmacies/wellness.jpg',
    },
    {
      'name': 'Animal Meds Plus',
      'address': '123 Care Street, Town',
      'rating': 4.5,
      'openHours': '8:00 AM - 8:00 PM',
      'image': 'assets/images/pharmacies/meds_plus.jpg',
    },
    {
      'name': '24/7 Pet Pharmacy',
      'address': '789 Emergency Road, City',
      'rating': 4.9,
      'openHours': '24 Hours',
      'image': 'assets/images/pharmacies/emergency.jpg',
    }
  ];

  List<Map<String, dynamic>> filteredPharmacies = [];

  @override
  void initState() {
    super.initState();
    filteredPharmacies = pharmacies;
  }

  void _handleSearch(String query) {
    setState(() {
      filteredPharmacies = pharmacies
          .where((pharmacy) =>
              pharmacy['name'].toLowerCase().contains(query.toLowerCase()) ||
              pharmacy['address'].toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pet Pharmacies'),
        backgroundColor: const Color(0xFF6BA8A9),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SearchBarWidget(
              onSearch: _handleSearch,
              hintText: 'Search pharmacies...',
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: filteredPharmacies.length,
              itemBuilder: (context, index) {
                final pharmacy = filteredPharmacies[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  elevation: 2,
                  child: InkWell(
                    onTap: () {
                      // Navigate to pharmacy details
                    },
                    child: Column(
                      children: [
                        Container(
                          height: 120,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage(pharmacy['image']),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      pharmacy['name'],
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF6BA8A9).withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Row(
                                      children: [
                                        const Icon(
                                          Icons.star,
                                          size: 16,
                                          color: Color(0xFF6BA8A9),
                                        ),
                                        Text(
                                          ' ${pharmacy['rating']}',
                                          style: const TextStyle(
                                            color: Color(0xFF6BA8A9),
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.location_on,
                                    color: Color(0xFF6BA8A9),
                                    size: 16,
                                  ),
                                  const SizedBox(width: 4),
                                  Expanded(
                                    child: Text(
                                      pharmacy['address'],
                                      style: TextStyle(
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.access_time,
                                    color: Color(0xFF6BA8A9),
                                    size: 16,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    pharmacy['openHours'],
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  TextButton.icon(
                                    onPressed: () {
                                      // Call pharmacy logic
                                    },
                                    icon: const Icon(Icons.phone),
                                    label: const Text('Call'),
                                  ),
                                  const SizedBox(width: 8),
                                  TextButton.icon(
                                    onPressed: () {
                                      // Navigate to directions
                                    },
                                    icon: const Icon(Icons.directions),
                                    label: const Text('Directions'),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
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
