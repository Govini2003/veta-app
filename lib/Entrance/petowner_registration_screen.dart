import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:auth_firebase/Entrance/role_selection_screen.dart';
import 'package:auth_firebase/Lali/screens/petO_home_page.dart';

class PetOwnerRegistrationScreen extends StatefulWidget {
  const PetOwnerRegistrationScreen({super.key});

  @override
  _PetOwnerRegistrationScreenState createState() =>
      _PetOwnerRegistrationScreenState();
}

class _PetOwnerRegistrationScreenState
    extends State<PetOwnerRegistrationScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controllers for text fields
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _bioController = TextEditingController();

  // Profile image variable
  File? _profileImage;

  // Image picker method
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
        title: const Text('Pet Owner Registration'),
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

                // Phone Number Field
                _buildTextField(
                  controller: _phoneController,
                  label: 'Phone Number',
                  keyboardType: TextInputType.phone,
                  validator: (value) =>
                      value!.isEmpty ? 'Please enter your phone number' : null,
                ),

                // Home Address Field
                _buildTextField(
                  controller: _addressController,
                  label: 'Home Address',
                  maxLines: 2,
                  validator: (value) =>
                      value!.isEmpty ? 'Please enter your home address' : null,
                ),

                // Bio Field
                _buildTextField(
                  controller: _bioController,
                  label: 'Bio',
                  maxLines: 3,
                  validator: (value) => value!.isEmpty
                      ? 'Please tell us a bit about yourself'
                      : null,
                ),

                const SizedBox(height: 30),

                // Submit Button
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
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Reusable TextField Builder
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

  // Form Submission Method
  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      // Save user data to Firestore (implement this part)

      // Save user role to SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('user_role', 'pet_owner');

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Registration submitted successfully!')),
      );

      // Navigate to PetOHomePage after successful registration
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => PetOHomePage()),
        (route) => false, // This removes all previous routes
      );
    }
  }

  @override
  void dispose() {
    // Dispose of controllers
    _phoneController.dispose();
    _addressController.dispose();
    _bioController.dispose();
    super.dispose();
  }
}
