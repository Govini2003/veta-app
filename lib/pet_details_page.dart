import 'package:flutter/material.dart';
import 'dart:io';
import 'models/pet_owner.dart';
import 'theme/app_theme.dart';
import 'add_pet_page.dart';

class PetDetailsPage extends StatefulWidget {
  final Pet pet;
  final Function(Pet) onPetUpdated;

  PetDetailsPage({
    required this.pet,
    required this.onPetUpdated,
  });

  @override
  _PetDetailsPageState createState() => _PetDetailsPageState();
}

class _PetDetailsPageState extends State<PetDetailsPage> {
  late Pet _pet;

  @override
  void initState() {
    super.initState();
    _pet = widget.pet;
  }

  void _editPet() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddPetPage(
          initialPet: _pet,
          onPetAdded: (updatedPet) {
            setState(() {
              _pet = updatedPet;
            });
            widget.onPetUpdated(updatedPet);
          },
        ),
      ),
    );
  }

  void _addVaccination() {
    // TODO: Implement vaccination addition
  }

  void _addVetVisit() {
    // TODO: Implement vet visit addition
  }

  void _updateFeedingSchedule() {
    // TODO: Implement feeding schedule update
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_pet.name),
        backgroundColor: AppTheme.primaryColor,
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: _editPet,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Pet Photos
            Container(
              height: 200,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _pet.imagePaths.length,
                itemBuilder: (context, index) {
                  return Container(
                    width: 200,
                    margin: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      image: DecorationImage(
                        image: FileImage(File(_pet.imagePaths[index])),
                        fit: BoxFit.cover,
                      ),
                    ),
                  );
                },
              ),
            ),

            // Basic Information
            Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Basic Information',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  _buildInfoRow('Species', _pet.species),
                  _buildInfoRow('Breed', _pet.breed),
                  _buildInfoRow('Gender', _pet.gender),
                  _buildInfoRow(
                    'Birthday',
                    '${_pet.birthday.year}-${_pet.birthday.month}-${_pet.birthday.day}',
                  ),
                  _buildInfoRow('Weight', '${_pet.weight} kg'),
                  _buildInfoRow('Height', '${_pet.height} cm'),
                ],
              ),
            ),

            // Health Information
            Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Health Information',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: _pet.healthInfo.map((info) {
                      return Chip(
                        label: Text(info),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),

            // Vaccinations
            Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Vaccinations',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.add),
                        onPressed: _addVaccination,
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: _pet.vaccinations.length,
                    itemBuilder: (context, index) {
                      final vaccination = _pet.vaccinations[index];
                      return Card(
                        child: ListTile(
                          title: Text(vaccination.name),
                          subtitle: Text(
                            'Date: ${vaccination.date.year}-${vaccination.date.month}-${vaccination.date.day}\n'
                            'Next Due: ${vaccination.nextDueDate.year}-${vaccination.nextDueDate.month}-${vaccination.nextDueDate.day}',
                          ),
                          trailing: Text(vaccination.veterinarian),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),

            // Vet Visits
            Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Vet Visits',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.add),
                        onPressed: _addVetVisit,
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: _pet.vetVisits.length,
                    itemBuilder: (context, index) {
                      final visit = _pet.vetVisits[index];
                      return Card(
                        child: ListTile(
                          title: Text(visit.reason),
                          subtitle: Text(
                            'Date: ${visit.date.year}-${visit.date.month}-${visit.date.day}\n'
                            'Diagnosis: ${visit.diagnosis}\n'
                            'Prescription: ${visit.prescription}',
                          ),
                          trailing: Text(visit.veterinarian),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),

            // Feeding Schedule
            Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Feeding Schedule',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: _updateFeedingSchedule,
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Text('Diet Preferences: ${_pet.feedingSchedule.dietPreferences}'),
                  SizedBox(height: 8),
                  Text('Allergies:'),
                  Wrap(
                    spacing: 8,
                    children: _pet.feedingSchedule.allergies.map((allergy) {
                      return Chip(
                        label: Text(allergy),
                      );
                    }).toList(),
                  ),
                  SizedBox(height: 8),
                  Text('Meals:'),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: _pet.feedingSchedule.meals.length,
                    itemBuilder: (context, index) {
                      final meal = _pet.feedingSchedule.meals[index];
                      return Card(
                        child: ListTile(
                          title: Text(meal.food),
                          subtitle: Text('Quantity: ${meal.quantity}'),
                          trailing: Text(
                            '${meal.time.hour}:${meal.time.minute.toString().padLeft(2, '0')}',
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text(
            '$label: ',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(value),
        ],
      ),
    );
  }
}
