import 'package:flutter/material.dart';
import 'dart:io';
import 'vaccine_page.dart';
import 'vaccine_details_page.dart'; // Import the VaccineDetailsPage
import 'full_screen_image.dart'; // Import the FullScreenImage
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';
import 'add_pet_page.dart'; // Import the AddPetPage
import 'add_pet_page.dart'; // Import the AddPetPage

class PetProfilePage extends StatefulWidget {
  final String petId; // Add petId as a required parameter
  final String petName;
  final String species;
  final String breed;
  final String? gender;
  final DateTime? dateOfBirth;
  final int? age;
  final double? weight;
  final File? petPhoto; // Change from final to mutable
  final List<Map<String, dynamic>>?
      initialVaccines; // Optional initial vaccines
  final List<Map<String, dynamic>> vaccines;

  const PetProfilePage({
    Key? key,
    required this.petId, // Mark as required
    required this.petName,
    required this.species,
    required this.breed,
    this.gender,
    this.dateOfBirth,
    this.age,
    this.weight,
    this.petPhoto,
    this.initialVaccines,
    required this.vaccines,
  }) : super(key: key);

  @override
  _PetProfilePageState createState() => _PetProfilePageState();
}

class _PetProfilePageState extends State<PetProfilePage> {
  late List<Map<String, dynamic>> _vaccines;
  Map<String, dynamic> _petData = {};
  File? _currentPetPhoto;

  @override
  void initState() {
    super.initState();
    // Filter vaccines specific to this pet using petId
    _vaccines = widget.initialVaccines
            ?.where((vaccine) => vaccine['petId'] == widget.petId)
            .toList() ??
        widget.vaccines;
    _currentPetPhoto = widget.petPhoto;
    _petData = {
      'petName': widget.petName,
      'species': widget.species,
      'breed': widget.breed,
      'age': widget.age,
      'petPhoto': _currentPetPhoto,
      'gender': widget.gender,
      'weight': widget.weight,
      'vaccines': _vaccines,
    };
    _loadData();
  }

  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();

    // Try to load saved photo path
    final savedPhotoPath = prefs.getString('${widget.petId}_photo');
    if (savedPhotoPath != null && File(savedPhotoPath).existsSync()) {
      setState(() {
        _currentPetPhoto = File(savedPhotoPath);
      });
    }

    final savedVaccinesJson = prefs.getString('${widget.petId}_vaccines');

    if (savedVaccinesJson != null) {
      final List<dynamic> savedVaccines = json.decode(savedVaccinesJson);
      setState(() {
        _vaccines =
            savedVaccines.map((v) => Map<String, dynamic>.from(v)).toList();
        _petData['vaccines'] = _vaccines;
      });
    }
  }

  Future<void> _saveData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final vaccinesJson = json.encode(_vaccines);
      await prefs.setString('${widget.petId}_vaccines', vaccinesJson);
      print('Pet vaccines saved successfully');
    } catch (e) {
      print('Error saving pet vaccines: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('')),
      );
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
        vaccine['petId'] = widget.petId;
        _vaccines.add(vaccine);
        _petData['vaccines'] = _vaccines;
        _saveData();
      });
    }
  }

  void _navigateToVaccineDetails(
      BuildContext context, Map<String, dynamic> vaccine, int index) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => VaccineDetailsPage(
          vaccineType: vaccine['vaccineType'] ?? 'Unknown',
          vaccinationDate: vaccine['vaccinationDate'] ?? 'Unknown',
          renewalDate: vaccine['renewalDate'],
          veterinarianName: vaccine['veterinarianName'] ?? '',
          vetRegNo: vaccine['vetRegNo'],
          vaccineLabel: vaccine['vaccineLabel'] as File?,
          vaccineIndex: index,
          description: vaccine['description'],
        ),
      ),
    );

    if (result != null) {
      setState(() {
        if (result['action'] == 'delete') {
          _vaccines.removeAt(result['index']);
          _petData['vaccines'] = _vaccines;
          _saveData();
        } else if (result['action'] == 'update' && result['data'] != null) {
          // Update the vaccine at the specified index
          _vaccines[result['index']] = result['data'];
          _petData['vaccines'] = _vaccines;
          _saveData();
        }
      });
    }
  }

  void _navigateToBookAppointment() {
    // TODO: Implement navigation to appointment booking page
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Appointment booking coming soon!'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _navigateToAddPet() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AddPetPage(),
      ),
    ).then((_) {
      // Refresh the current page or perform any necessary updates
      setState(() {});
    });
  }

  Future<void> _updateProfilePhoto() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      final File newPhotoFile = File(image.path);
      setState(() {
        _currentPetPhoto = newPhotoFile;
      });

      await _saveProfilePhoto(newPhotoFile);
    }
  }

  Future<void> _saveProfilePhoto(File photoFile) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('${widget.petId}_photo', photoFile.path);
      print('Pet photo saved successfully');
    } catch (e) {
      print('Error saving pet photo: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to save profile photo')),
      );
    }
  }

  String _calculateAge() {
    if (widget.dateOfBirth == null) return 'Age unknown';

    final now = DateTime.now();
    final difference = now.difference(widget.dateOfBirth!);
    final months =
        (difference.inDays / 30.44).floor(); // Average days in a month

    if (months < 1) {
      final days = difference.inDays;
      return '$days Day${days != 1 ? 's' : ''}';
    } else if (months < 12) {
      return '$months Month${months != 1 ? 's' : ''}';
    } else {
      final years = (months / 12).floor();
      final remainingMonths = months % 12;
      if (remainingMonths == 0) {
        return '$years Year${years != 1 ? 's' : ''}';
      }
      return '$years Year${years != 1 ? 's' : ''} $remainingMonths Month${remainingMonths != 1 ? 's' : ''}';
    }
  }

  String _formatDate(DateTime? date) {
    if (date == null) return 'Not specified';

    // Add leading zero if day or month is single digit
    String day = date.day.toString().padLeft(2, '0');
    String month = date.month.toString().padLeft(2, '0');

    return '$day/$month/${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Veta.lk',
            style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.2)),
        backgroundColor: const Color(0xFF1D4D4F),
        foregroundColor: Colors.white,
        elevation: 4,
      ),
      body: Container(
        color: Color(0xFFE9EFEC),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            children: [
              Text(
                '${widget.petName}\'s Profile',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1D4D4F),
                  letterSpacing: 0.5,
                ),
              ),
              SizedBox(height: 20),
              Center(
                child: GestureDetector(
                  onTap: () {
                    if (_currentPetPhoto != null) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              FullScreenImage(imageFile: _currentPetPhoto!),
                        ),
                      );
                    }
                  },
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      ClipOval(
                        child: Container(
                          width: 250,
                          height: 250,
                          decoration: BoxDecoration(
                            color: const Color(0xFF6BA8A9),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black26,
                                blurRadius: 10,
                                offset: Offset(0, 4),
                              )
                            ],
                          ),
                          child: _currentPetPhoto != null
                              ? Image.file(
                                  _currentPetPhoto!,
                                  fit: BoxFit.cover,
                                  alignment: Alignment(0, -0.6),
                                  width: 250,
                                  height: 250,
                                )
                              : const Icon(
                                  Icons.pets,
                                  size: 100,
                                  color: Colors.white,
                                ),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: GestureDetector(
                          onTap: _updateProfilePhoto,
                          child: Container(
                            padding: EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Color(0xFF357376),
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black26,
                                  blurRadius: 5,
                                  offset: Offset(0, 2),
                                )
                              ],
                            ),
                            child: Icon(
                              Icons.edit,
                              color: Colors.white,
                              size: 24,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 30),
              _buildDetailSection(),
              const SizedBox(height: 20),
              _buildVaccinationSection(context),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(28),
            child: ElevatedButton.icon(
              onPressed: _navigateToBookAppointment,
              icon: Icon(Icons.calendar_today, color: Colors.white),
              label: Text(
                'Book Appointment',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF357376),
                padding: EdgeInsets.symmetric(vertical: 16, horizontal: 30),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 3,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 28, left: 28, right: 28),
            child: ElevatedButton.icon(
              onPressed: _navigateToAddPet,
              icon: Icon(Icons.add, color: Colors.white),
              label: Text(
                'Add More Pets',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF6BA8A9),
                padding: EdgeInsets.symmetric(vertical: 16, horizontal: 30),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 3,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 2),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    widget.petName,
                    style: TextStyle(
                      fontSize: 23,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1D4D4F),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Icon(
                    widget.gender?.toLowerCase() == 'male'
                        ? Icons.male
                        : Icons.female,
                    color: Color(0xFF6BA8A9),
                    size: 28,
                  ),
                ],
              ),
              Text(
                _calculateAge(),
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Text(
                'Breed: ',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.grey[600],
                ),
              ),
              Text(
                widget.breed,
                style: TextStyle(
                  fontSize: 20,
                  color: Color(0xFF1D4D4F),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Text(
                'Date of Birth: ',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                _formatDate(widget.dateOfBirth),
                style: TextStyle(
                  fontSize: 20,
                  color: Color(0xFF1D4D4F),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.pets,
                    color: Color(0xFF6BA8A9),
                    size: 24,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    widget.species,
                    style: TextStyle(
                      fontSize: 20,
                      color: Color(0xFF1D4D4F),
                    ),
                  ),
                ],
              ),
              Text(
                '${widget.weight?.toStringAsFixed(1) ?? "0"} kg',
                style: TextStyle(
                  fontSize: 20,
                  color: Color(0xFF1D4D4F),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildVaccinationSection(BuildContext context) {
    // Vaccine type to symbol mapping
    final Map<String, String> vaccineSymbols = {
      'Rabies': '💉',
      'Parvovirus': '🦠',
      'Distemper': '🩺',
      'Bordetella': '🐶',
      'Leptospirosis': '🌡️',
      'FVRCP': '🐱',
      'FeLV': '🩸',
      'Other': '❓'
    };

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: 10,
            offset: Offset(0, 5),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  'Vaccination History',
                  style: TextStyle(
                    fontSize: 23,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1D4D4F),
                    overflow: TextOverflow.ellipsis,
                  ),
                  maxLines: 1,
                ),
              ),
              SizedBox(width: 8),
              GestureDetector(
                onTap: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => VaccinePage(),
                    ),
                  );
                  if (result != null) {
                    setState(() {
                      // Add petId to the vaccine details
                      result['petId'] = widget.petId;
                      _vaccines.add(result);
                      _petData['vaccines'] = _vaccines;
                      _saveData();
                    });
                  }
                },
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Color(0xFF357376).withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.add,
                    color: Color(0xFF357376),
                    size: 24,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (_vaccines.isEmpty)
            Center(
              child: Text(
                'No vaccinations added yet.',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                  fontStyle: FontStyle.italic,
                ),
              ),
            )
          else
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: _vaccines.length,
              itemBuilder: (context, index) {
                final vaccine = _vaccines[index];
                final vaccineType = vaccine['vaccineType'] ?? 'Other';
                final symbol = vaccineSymbols[vaccineType] ?? '❓';

                return GestureDetector(
                  onTap: () {
                    _navigateToVaccineDetails(context, vaccine, index);
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.grey.shade300, width: 1),
                    ),
                    child: Row(
                      children: [
                        Text(
                          symbol,
                          style: TextStyle(fontSize: 24),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                vaccine['vaccineType'] ?? 'Unknown Vaccine',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF1D4D4F),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Vaccination Date: ${vaccine['vaccinationDate'] ?? 'Not specified'}',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[700],
                                ),
                              ),
                              if (vaccine['renewalDate'] != null &&
                                  vaccine['renewalDate'].isNotEmpty)
                                Text(
                                  'Renewal Date: ${vaccine['renewalDate']}',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[700],
                                  ),
                                ),
                            ],
                          ),
                        ),
                        Icon(
                          Icons.chevron_right,
                          color: Color(0xFF357376),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }

  String _formatAge(int ageInMonths) {
    final years = ageInMonths ~/ 12;
    final months = ageInMonths % 12;
    if (years > 0 && months > 0) {
      return '$years years $months months';
    } else if (years > 0) {
      return '$years years';
    } else {
      return '$months months';
    }
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[700],
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              color: Color(0xFF1D4D4F),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVaccineCard(Map<String, dynamic> vaccine, int index) {
    String subtitleText =
        'Vaccination Date: ${vaccine['vaccinationDate'] ?? 'Unknown'}';
    if (vaccine['renewalDate'] != null && vaccine['renewalDate'].isNotEmpty) {
      subtitleText += '\nRenewal Date: ${vaccine['renewalDate']}';
    }

    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        title: Text(
          vaccine['vaccineType'] ?? 'Unknown Vaccine',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFF1D4D4F),
          ),
        ),
        subtitle: Text(
          subtitleText,
          style: TextStyle(color: Colors.grey[600]),
        ),
        trailing: IconButton(
          icon: const Icon(Icons.info_outline, color: Color(0xFF357376)),
          onPressed: () => _navigateToVaccineDetails(context, vaccine, index),
        ),
      ),
    );
  }
}
