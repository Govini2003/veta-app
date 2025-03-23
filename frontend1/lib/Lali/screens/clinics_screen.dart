//veta-app/frontend1/lib/Lali/screens/chat_screen.dart
import 'package:flutter/material.dart';
import '../widgets/search_bar_widget.dart';

class ClinicsScreen extends StatefulWidget {
  @override
  _ClinicsScreenState createState() => _ClinicsScreenState();
}

class _ClinicsScreenState extends State<ClinicsScreen> {
  List<Map<String, dynamic>> clinics = [
    {
      'name': 'PetCare Clinic',
      'address': '123 Pet Street, City',
      'rating': 4.7,
      'services': ['Surgery', 'Vaccination', 'Grooming'],
      'image': 'assets/images/clinics/petcare_clinic.jpg',
    },
    {
      'name': 'Animal Health Center',
      'address': '456 Vet Avenue, Town',
      'rating': 4.5,
      'services': ['Emergency Care', 'Dental', 'Laboratory'],
      'image': 'assets/images/clinics/health_center.jpg',
    },
    {
      'name': 'City Veterinary Hospital',
      'address': '789 Main Street, City',
      'rating': 4.8,
      'services': ['24/7 Emergency', 'Surgery', 'Boarding'],
      'image': 'assets/images/clinics/city_vet.jpg',
    },
    {
      'name': 'Happy Paws Clinic',
      'address': '321 Park Road, Town',
      'rating': 4.6,
      'services': ['Wellness Care', 'Grooming', 'Pharmacy'],
      'image': 'assets/images/clinics/happy_paws.jpg',
    },
    {
      'name': 'Modern Pet Hospital',
      'address': '567 Tech Drive, City',
      'rating': 4.9,
      'services': ['Advanced Imaging', 'Surgery', 'Rehabilitation'],
      'image': 'assets/images/clinics/modern_pet.jpg',
    }
  ];

  List<Map<String, dynamic>> filteredClinics = [];

  @override
  void initState() {
    super.initState();
    filteredClinics = clinics;
  }

  void _handleSearch(String query) {
    setState(() {
      filteredClinics = clinics
          .where((clinic) =>
              clinic['name'].toLowerCase().contains(query.toLowerCase()) ||
              clinic['address'].toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Veterinary Clinics'),
        backgroundColor: const Color(0xFF6BA8A9),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SearchBarWidget(
              onSearch: _handleSearch,
              hintText: 'Search clinics...',
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: filteredClinics.length,
              itemBuilder: (context, index) {
                final clinic = filteredClinics[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  elevation: 2,
                  child: Column(
                    children: [
                      Container(
                        height: 150,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage(clinic['image']),
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
                                Text(
                                  clinic['name'],
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                                Row(
                                  children: [
                                    const Icon(Icons.star, color: Colors.amber),
                                    Text(' ${clinic['rating']}'),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                const Icon(Icons.location_on,
                                    color: Color(0xFF6BA8A9), size: 16),
                                const SizedBox(width: 4),
                                Expanded(child: Text(clinic['address'])),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Wrap(
                              spacing: 8,
                              children: (clinic['services'] as List<String>)
                                  .map((service) => Chip(
                                        label: Text(
                                          service,
                                          style: const TextStyle(fontSize: 12),
                                        ),
                                        backgroundColor:
                                            const Color(0xFF6BA8A9).withOpacity(0.1),
                                      ))
                                  .toList(),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                TextButton(
                                  onPressed: () {
                                    // View details logic
                                  },
                                  child: const Text('View Details'),
                                ),
                                const SizedBox(width: 8),
                                ElevatedButton(
                                  onPressed: () {
                                    // Book appointment logic
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF6BA8A9),
                                  ),
                                  child: const Text('Book Appointment'),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
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
