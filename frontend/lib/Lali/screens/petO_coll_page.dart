import 'package:flutter/material.dart';
import 'dart:io';
import '../../features/profile/profile_navigation.dart';

class Pet {
  final String name;
  final String breed;
  final String image;

  Pet({
    required this.name,
    required this.breed,
    required this.image,
  });
}

class MyPetsPage extends StatelessWidget {
  // Mock data for demonstration
  final List<Pet> mockPets = [
    Pet(
      name: 'Tobby',
      breed: 'laabrador',
      image: 'assets/images/tobby.jpg',
    ),
    Pet(
      name: 'Rooby',
      breed: 'Cross',
      image: 'assets/images/rooby.jpg',
    ),
    Pet(
      name: 'brown',
      breed: 'sheperd',
      image: 'assets/images/brown.jpg',
    ),
  ];

  final Function(Pet) addPet;
  final Function(int) deletePet;

  MyPetsPage({
    required this.addPet,
    required this.deletePet,
  });

  @override
  Widget build(BuildContext context) {
    // Use mockPets instead of the passed pets parameter
    final pets = mockPets;

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text(
          'Pet Adoption',
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
                            species: 'Dog',
                            breed: pets[index].breed,
                            vaccines: [],
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
                                child: Image.asset(
                                  pets[index].image,
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
                                        pets[index].breed,
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
                              Positioned(
                                top: 8,
                                right: 8,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                  ),
                                  child: IconButton(
                                    icon: Icon(Icons.delete_outline),
                                    onPressed: () {
                                      deletePet(index);
                                    },
                                    color: Colors.grey[600],
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
          ProfileNavigation.navigateToAddPet(context);
        },
        backgroundColor: Color(0xFF357376),
        icon: Icon(Icons.add),
        label: Text('Add Pet', style: TextStyle(fontFamily: 'Poppins')),
      ),
    );
  }
} 