import 'package:flutter/material.dart';
import 'dart:io';
import '../../features/profile/profile_navigation.dart';
import '../../InuPetProfile/add_pet_page.dart';

class Pet {
  final String name;
  final String breed;
  final String species;
  final String? gender;
  final double? weight;
  final DateTime? dateOfBirth;
  final File? photo;
  final List<Map<String, dynamic>> vaccines;

  Pet({
    required this.name,
    required this.breed,
    required this.species,
    this.gender,
    this.weight,
    this.dateOfBirth,
    this.photo,
    required this.vaccines,
  });
}

class MyPetsPage extends StatefulWidget {
  @override
  _MyPetsPageState createState() => _MyPetsPageState();
}

class _MyPetsPageState extends State<MyPetsPage> {
  List<Pet> pets = [];

  void _addPet(Map<String, dynamic> petData) {
    setState(() {
      pets.add(Pet(
        name: petData['name'] ?? '',
        breed: petData['breed'] ?? '',
        species: petData['species'] ?? 'Unknown',
        gender: petData['gender'],
        weight: petData['weight'],
        dateOfBirth: petData['dateOfBirth'] != null 
          ? DateTime.parse(petData['dateOfBirth']) 
          : null,
        photo: petData['petPhoto'],
        vaccines: List<Map<String, dynamic>>.from(petData['vaccines'] ?? []),
      ));
    });
  }

  void _deletePet(int index) {
    setState(() {
      pets.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text(
          'My Pets',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          Container(
            color: Colors.white,
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundColor: Colors.grey[300],
                      child: Icon(Icons.person, color: Colors.grey[600]),
                    ),
                    SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Hi, There',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Poppins',
                          ),
                        ),
                        Row(
                          children: [
                            Icon(Icons.location_on, size: 16, color: Colors.grey),
                            Text(
                              'New York, USA',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 14,
                                fontFamily: 'Questrial',
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 20),
                TextField(
                  decoration: InputDecoration(
                    hintText: 'Search your favorite pet',
                    hintStyle: TextStyle(fontFamily: 'Questrial'),
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.grey[100],
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'My Pets',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Poppins',
                      ),
                    ),
                    TextButton(
                      onPressed: () {},
                      child: Text(
                        'See More',
                        style: TextStyle(
                          color: Color(0xFF357376),
                          fontFamily: 'Questrial',
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: pets.isEmpty
                ? Center(
                    child: Text(
                      'No pets added yet',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[600],
                        fontFamily: 'Questrial',
                      ),
                    ),
                  )
                : GridView.builder(
                    padding: EdgeInsets.all(16),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 1,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                    ),
                    itemCount: pets.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          ProfileNavigation.navigateToPetDetails(
                            context,
                            petId: pets[index].name,
                            petName: pets[index].name,
                            species: pets[index].species,
                            breed: pets[index].breed,
                            gender: pets[index].gender,
                            dateOfBirth: pets[index].dateOfBirth,
                            weight: pets[index].weight,
                            petPhoto: pets[index].photo,
                            vaccines: pets[index].vaccines,
                            onDelete: () {
                              setState(() {
                                pets.removeAt(index);
                              });
                            },
                            onSave: (File? newPhoto, double? newWeight) {
                              setState(() {
                                pets[index] = Pet(
                                  name: pets[index].name,
                                  breed: pets[index].breed,
                                  species: pets[index].species,
                                  gender: pets[index].gender,
                                  dateOfBirth: pets[index].dateOfBirth,
                                  weight: newWeight,
                                  photo: newPhoto,
                                  vaccines: pets[index].vaccines,
                                );
                              });
                            },
                          );
                        },
                        child: Card(
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Stack(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(16),
                                child: pets[index].photo != null
                                  ? Image.file(
                                      pets[index].photo!,
                                      fit: BoxFit.cover,
                                      width: double.infinity,
                                      height: double.infinity,
                                    )
                                  : Image.asset(
                                      'assets/images/default_pet.jpg',
                                      fit: BoxFit.cover,
                                      width: double.infinity,
                                      height: double.infinity,
                                    ),
                              ),
                              Positioned(
                                bottom: 0,
                                left: 0,
                                right: 0,
                                child: Container(
                                  padding: EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: Colors.black.withOpacity(0.6),
                                    borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(16),
                                      bottomRight: Radius.circular(16),
                                    ),
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        pets[index].name,
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                          fontFamily: 'Poppins',
                                        ),
                                      ),
                                      Text(
                                        '${pets[index].species} • ${pets[index].breed}',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 14,
                                          fontFamily: 'Questrial',
                                        ),
                                      ),
                                    ],
                                  ),
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
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddPetPage(
                onPetAdded: _addPet,
              ),
            ),
          );
        },
        backgroundColor: Color(0xFF357376),
        icon: Icon(Icons.add),
        label: Text('Add Pet', style: TextStyle(fontFamily: 'Poppins')),
      ),
    );
  }
} 