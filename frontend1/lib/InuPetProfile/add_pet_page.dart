//frontend1/lib/InuPetProfile/add_pet_page.dart 
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'pet_profile_page.dart';//import pet profile
import 'vaccine_page.dart'; // Import Vaccine Page
import 'package:uuid/uuid.dart';  // Add this import at the top of the file

class AddPetPage extends StatefulWidget {
  final Function(Map<String, dynamic>)? onPetAdded;
  
  const AddPetPage({super.key, this.onPetAdded});

  @override
  _AddPetPageState createState() => _AddPetPageState();
}

class _AddPetPageState extends State<AddPetPage> {
  final _formKey = GlobalKey<FormState>();

  String? petId; // Add this line to store unique pet ID
  String? petName;// Add petName
  String? species;// like dog,cat,fish
  String? breed;
  String? gender;
  DateTime? dateOfBirth;
  int? age;
  double? weight;  // Add weight field
  File? petPhoto;
  List<Map<String, dynamic>> vaccines = []; // Store vaccine details

  @override
  void initState() {
    super.initState();
    petId = Uuid().v4(); // Generate a unique ID when the page is first created
  }

  Future<void> _selectDate(BuildContext context) async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );

    if (pickedDate != null) {
      setState(() {
        dateOfBirth = pickedDate;

        // Calculate age in total months
        final now = DateTime.now();
        int totalMonths = (now.year - pickedDate.year) * 12 + (now.month - pickedDate.month);

        // Debug print statements
        print('Current Date: $now');
        print('Birth Date: $pickedDate');
        print('Initial Total Months: $totalMonths');

        // Adjust total months if the day of the month is less than the birth day
        if (now.day < pickedDate.day) {
          totalMonths--;
          print('Adjusted Total Months: $totalMonths');
        }

        age = totalMonths;

        print('Final Age (Months): $age');
      });
    }
  }

  Future<void> _selectImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        petPhoto = File(image.path);
      });
    }
  }

  void _navigateToVaccinePage(BuildContext context) async {
    final vaccine = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => VaccinePage()),
    );

    if (vaccine != null) {
      setState(() {
        // Add petId to the vaccine details
        vaccine['petId'] = petId;
        vaccines.add(vaccine);
      });
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      
      // Create pet data map
      final petData = {
        'id': petId,
        'name': petName,
        'species': species,
        'breed': breed,
        'gender': gender,
        'dateOfBirth': dateOfBirth?.toIso8601String(),
        'age': age,
        'weight': weight,
        'vaccines': vaccines,
        'petPhoto': petPhoto,
      };
      
      // Call onPetAdded callback if provided
      widget.onPetAdded?.call(petData);
      
      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Pet added successfully!')),
      );

      // Navigate back to previous screen
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Veta.lk'),
        backgroundColor: const Color(0xFF1D4D4F),
        foregroundColor: Colors.white,
        elevation: 4,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Text(
                'Add Pet Details',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1D4D4F),
                ),
              ),
              SizedBox(height: 20),
              GestureDetector(
                onTap: _selectImage,
                child: Center(
                  child: petPhoto == null
                      ? Container(
                    width: 120, // Adjust size to fit the avatar
                    height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Color(0xFF6B8A89), width: 1),
                      color: Color(0xFFE9EFEC),
                    ),
                    child: Icon(Icons.add_a_photo, color: Color(0xFF6B8A89)),
                  )

                      : CircleAvatar(
                    radius: 60,
                    backgroundImage: FileImage(petPhoto!),
                  ),
                ),
              ),
              SizedBox(height: 20),
              TextFormField(
                decoration: InputDecoration(
                  labelText: "Pet's Name",
                  labelStyle: TextStyle(
                    color: Color(0xFF1D4D4F),
                  ),
                  filled: true,
                  fillColor: Color(0xFFE9EFEC),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide(color: Color(0xFF6BA8A9)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide(color: Color(0xFF357376), width: 2.0),
                  ),
                ),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
                onSaved: (value) => petName = value,
                validator: (value) =>
                value!.isEmpty ? "Please enter your pet's name" : null,
              ),
              SizedBox(height: 16),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: 'Species',
                  filled: true,
                  fillColor: Color(0xFFE9EFEC),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide(color: Color(0xFF6BA8A9)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide(color: Color(0xFF357376), width: 2.0),
                  ),
                  labelStyle: TextStyle(color: Color(0xFF1D4D4F)),
                ),
                items: ['Dog', 'Cat', 'Bird', 'Fish', 'Other']
                    .map((label) => DropdownMenuItem(
                  child: Text(label),
                  value: label,
                ))
                    .toList(),
                onChanged: (value) => setState(() => species = value),
                validator: (value) =>
                value == null ? "Please select the species" : null,
              ),
              SizedBox(height: 16),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Breed',
                  labelStyle: TextStyle(
                    color: Color(0xFF1D4D4F),
                  ),
                  filled: true,
                  fillColor: Color(0xFFE9EFEC),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide(color: Color(0xFF6BA8A9)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide(color: Color(0xFF357376), width: 2.0),
                  ),
                ),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
                onSaved: (value) => breed = value,
                validator: (value) =>
                value!.isEmpty ? "Please enter the breed" : null,
              ),
              SizedBox(height: 16),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: 'Gender',
                  filled: true,
                  fillColor: Color(0xFFE9EFEC),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide(color: Color(0xFF6BA8A9)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide(color: Color(0xFF357376), width: 2.0),
                  ),
                  labelStyle: TextStyle(color: Color(0xFF1D4D4F)),
                ),
                items: ['Male', 'Female']
                    .map((label) => DropdownMenuItem(
                  child: Text(label),
                  value: label,
                ))
                    .toList(),
                onChanged: (value) => setState(() => gender = value),
                validator: (value) =>
                value == null ? "Please select the gender" : null,
              ),
              SizedBox(height: 16),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Weight (kg)',
                  labelStyle: TextStyle(
                    color: Color(0xFF1D4D4F),
                  ),
                  filled: true,
                  fillColor: Color(0xFFE9EFEC),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide(color: Color(0xFF6BA8A9)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide(color: Color(0xFF357376), width: 2.0),
                  ),
                ),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter pet weight';
                  }
                  // Validate that input is a valid number
                  final parsedWeight = double.tryParse(value);
                  if (parsedWeight == null || parsedWeight <= 0) {
                    return 'Please enter a valid weight';
                  }
                  return null;
                },
                onSaved: (value) => weight = double.parse(value!),
              ),
              SizedBox(height: 16),
              ListTile(
                title: Text(
                  'Date of Birth',
                  style: TextStyle(color: Color(0xFF1D4D4F)),
                ),
                subtitle: Text(
                  dateOfBirth == null
                      ? 'Select Date'
                      : '${dateOfBirth!.toLocal()}'.split(' ')[0],
                  style: TextStyle(
                      fontSize: 16,
                      color: Color(0xFF357376),
                      fontWeight: FontWeight.bold),
                ),
                trailing: Icon(Icons.calendar_today, color: Color(0xFF357376)),
                onTap: () => _selectDate(context),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => _navigateToVaccinePage(context),
                child: Text('Add Vaccination'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.blue,//white
                  backgroundColor: Color(0xFF357376),
                  padding: EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                onPressed: _submitForm,
                child: Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
