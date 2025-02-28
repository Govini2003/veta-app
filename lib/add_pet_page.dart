import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'models/pet_owner.dart';
import 'theme/app_theme.dart';

class AddPetPage extends StatefulWidget {
  final Pet? initialPet;
  final Function(Pet) onPetAdded;

  AddPetPage({
    this.initialPet,
    required this.onPetAdded,
  });

  @override
  _AddPetPageState createState() => _AddPetPageState();
}

class _AddPetPageState extends State<AddPetPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _breedController = TextEditingController();
  final _weightController = TextEditingController();
  final _heightController = TextEditingController();
  final _healthInfoController = TextEditingController();

  String _selectedSpecies = 'Dog';
  String _selectedGender = 'Male';
  DateTime _selectedBirthday = DateTime.now();
  List<String> _healthInfo = [];
  List<String> _imagePaths = [];
  List<VaccinationRecord> _vaccinations = [];
  List<VetVisit> _vetVisits = [];
  FeedingSchedule _feedingSchedule = FeedingSchedule(
    meals: [],
    dietPreferences: '',
    allergies: [],
  );

  final List<String> _speciesOptions = ['Dog', 'Cat', 'Bird', 'Other'];
  final List<String> _genderOptions = ['Male', 'Female'];

  @override
  void initState() {
    super.initState();
    if (widget.initialPet != null) {
      _nameController.text = widget.initialPet!.name;
      _breedController.text = widget.initialPet!.breed;
      _weightController.text = widget.initialPet!.weight.toString();
      _heightController.text = widget.initialPet!.height.toString();
      _selectedSpecies = widget.initialPet!.species;
      _selectedGender = widget.initialPet!.gender;
      _selectedBirthday = widget.initialPet!.birthday;
      _healthInfo = List.from(widget.initialPet!.healthInfo);
      _imagePaths = List.from(widget.initialPet!.imagePaths);
      _vaccinations = List.from(widget.initialPet!.vaccinations);
      _vetVisits = List.from(widget.initialPet!.vetVisits);
      _feedingSchedule = widget.initialPet!.feedingSchedule;
    }
  }

  Future<void> _pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    
    if (image != null) {
      setState(() {
        _imagePaths.add(image.path);
      });
    }
  }

  void _addHealthInfo() {
    if (_healthInfoController.text.isNotEmpty) {
      setState(() {
        _healthInfo.add(_healthInfoController.text);
        _healthInfoController.clear();
      });
    }
  }

  Future<void> _selectBirthday() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedBirthday,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _selectedBirthday = picked;
      });
    }
  }

  void _savePet() {
    if (_formKey.currentState!.validate()) {
      final pet = Pet(
        id: widget.initialPet?.id ?? DateTime.now().toString(),
        name: _nameController.text,
        species: _selectedSpecies,
        breed: _breedController.text,
        gender: _selectedGender,
        birthday: _selectedBirthday,
        weight: double.parse(_weightController.text),
        height: double.parse(_heightController.text),
        healthInfo: _healthInfo,
        imagePaths: _imagePaths,
        vaccinations: _vaccinations,
        vetVisits: _vetVisits,
        feedingSchedule: _feedingSchedule,
      );

      widget.onPetAdded(pet);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.initialPet == null ? 'Add New Pet' : 'Edit Pet'),
        backgroundColor: AppTheme.primaryColor,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Pet Photos Section
              Text(
                'Pet Photos',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Container(
                height: 120,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _imagePaths.length + 1,
                  itemBuilder: (context, index) {
                    if (index == _imagePaths.length) {
                      return GestureDetector(
                        onTap: _pickImage,
                        child: Container(
                          width: 120,
                          margin: EdgeInsets.only(right: 8),
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(Icons.add_a_photo, color: Colors.grey[400]),
                        ),
                      );
                    }
                    return Container(
                      width: 120,
                      margin: EdgeInsets.only(right: 8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        image: DecorationImage(
                          image: FileImage(File(_imagePaths[index])),
                          fit: BoxFit.cover,
                        ),
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: 16),

              // Basic Information
              Text(
                'Basic Information',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Pet Name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your pet\'s name';
                  }
                  return null;
                },
              ),
              SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: _selectedSpecies,
                decoration: InputDecoration(
                  labelText: 'Species',
                  border: OutlineInputBorder(),
                ),
                items: _speciesOptions.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    setState(() {
                      _selectedSpecies = newValue;
                    });
                  }
                },
              ),
              SizedBox(height: 8),
              TextFormField(
                controller: _breedController,
                decoration: InputDecoration(
                  labelText: 'Breed',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: _selectedGender,
                decoration: InputDecoration(
                  labelText: 'Gender',
                  border: OutlineInputBorder(),
                ),
                items: _genderOptions.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    setState(() {
                      _selectedGender = newValue;
                    });
                  }
                },
              ),
              SizedBox(height: 8),
              ListTile(
                title: Text('Birthday'),
                subtitle: Text(
                  '${_selectedBirthday.year}-${_selectedBirthday.month}-${_selectedBirthday.day}',
                ),
                trailing: Icon(Icons.calendar_today),
                onTap: _selectBirthday,
              ),
              SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _weightController,
                      decoration: InputDecoration(
                        labelText: 'Weight (kg)',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter weight';
                        }
                        return null;
                      },
                    ),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: TextFormField(
                      controller: _heightController,
                      decoration: InputDecoration(
                        labelText: 'Height (cm)',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter height';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),

              // Health Information
              Text(
                'Health Information',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _healthInfoController,
                      decoration: InputDecoration(
                        labelText: 'Add health info',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: _addHealthInfo,
                    child: Text('Add'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryColor,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: _healthInfo.map((info) {
                  return Chip(
                    label: Text(info),
                    onDeleted: () {
                      setState(() {
                        _healthInfo.remove(info);
                      });
                    },
                  );
                }).toList(),
              ),
              SizedBox(height: 24),

              // Save Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _savePet,
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: Text(
                      widget.initialPet == null ? 'Add Pet' : 'Save Changes',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _breedController.dispose();
    _weightController.dispose();
    _heightController.dispose();
    _healthInfoController.dispose();
    super.dispose();
  }
}
