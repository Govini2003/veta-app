//veta-app/frontend1/lib/Entrance/vet_registration_screen.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:auth_firebase/Entrance/role_selection_screen.dart';
import 'package:auth_firebase/Lali/screens/vet_home_page.dart';

class VetRegistrationScreen extends StatefulWidget {
  const VetRegistrationScreen({super.key});

  @override
  _VetRegistrationScreenState createState() => _VetRegistrationScreenState();
}

class _VetRegistrationScreenState extends State<VetRegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  final _nicController = TextEditingController();
  final _slvcController = TextEditingController();
  final _clinicController = TextEditingController();
  final _collegeController = TextEditingController();
  final _practiceInfoController = TextEditingController();
  final _servicesFeesController = TextEditingController();

  File? _profileImage;
  List<String> _paymentMethods = [];

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (_) => const RoleSelectionScreen()),
            );
          },
        ),
        title: const Text('Veterinarian Registration'),
        backgroundColor: Colors.teal,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Profile Picture
                Center(
                  child: GestureDetector(
                    onTap: _pickImage,
                    child: CircleAvatar(
                      radius: 60,
                      backgroundColor: Colors.teal[100],
                      backgroundImage: _profileImage != null
                          ? FileImage(_profileImage!)
                          : null,
                      child: _profileImage == null
                          ? const Icon(Icons.camera_alt,
                              size: 50, color: Colors.teal)
                          : null,
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Phone Number
                _buildTextField(
                  controller: _phoneController,
                  label: 'Phone Number',
                  keyboardType: TextInputType.phone,
                  validator: (value) =>
                      value!.isEmpty ? 'Please enter your phone number' : null,
                ),

                // NIC
                _buildTextField(
                  controller: _nicController,
                  label: 'National Identity Card Number',
                  validator: (value) =>
                      value!.isEmpty ? 'Please enter your NIC number' : null,
                ),

                // SLVC Number
                _buildTextField(
                  controller: _slvcController,
                  label: 'SLVC Registration Number',
                  validator: (value) =>
                      value!.isEmpty ? 'Please enter SLVC number' : null,
                ),

                // Clinic/Practice Station
                _buildTextField(
                  controller: _clinicController,
                  label: 'Clinic/Practice Station',
                  validator: (value) => value!.isEmpty
                      ? 'Please enter clinic/practice location'
                      : null,
                ),

                // Veterinary College/University
                _buildTextField(
                  controller: _collegeController,
                  label: 'Veterinary College/University',
                  validator: (value) => value!.isEmpty
                      ? 'Please enter your educational institution'
                      : null,
                ),

                // Practice Info
                _buildTextField(
                  controller: _practiceInfoController,
                  label: 'Practice Information',
                  maxLines: 3,
                ),

                // Services and Fees
                _buildTextField(
                  controller: _servicesFeesController,
                  label: 'Services and Fees',
                  maxLines: 3,
                ),

                // Payment Methods
                const Text(
                  'Payment Methods',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                _buildPaymentMethodsCheckbox(),

                const SizedBox(height: 15),

                ElevatedButton(
                  onPressed: _submitForm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                  ),
                  child: const Text(
                    'Complete Registration',
                    style: TextStyle(fontSize: 18),
                  ),
                ),

                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
    int maxLines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        keyboardType: keyboardType,
        validator: validator,
        maxLines: maxLines,
      ),
    );
  }

  Widget _buildPaymentMethodsCheckbox() {
    final paymentOptions = [
      'Cash',
      'Card Payments',
      'Bank Transfer',
    ];

    return Column(
      children: paymentOptions.map((method) {
        return CheckboxListTile(
          title: Text(method),
          value: _paymentMethods.contains(method),
          onChanged: (bool? value) {
            setState(() {
              if (value == true) {
                _paymentMethods.add(method);
              } else {
                _paymentMethods.remove(method);
              }
            });
          },
        );
      }).toList(),
    );
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      // Save user data to Firestore (implement this part)

      // Save user role to SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('user_role', 'vet');

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Registration submitted successfully!')),
      );

      // Navigate to VetHomePage after successful registration
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => VetHomePage()),
        (route) => false, // This removes all previous routes
      );
    }
  }

  @override
  void dispose() {
    // Dispose of controllers
    _phoneController.dispose();
    _nicController.dispose();
    _slvcController.dispose();
    _clinicController.dispose();
    _collegeController.dispose();
    _practiceInfoController.dispose();
    _servicesFeesController.dispose();
    super.dispose();
  }
}
