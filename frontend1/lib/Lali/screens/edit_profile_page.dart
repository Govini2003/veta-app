// veta-app/frontend1/lib/Lali/screens/edit_profile_page.dart

import 'package:flutter/material.dart';

class EditProfilePage extends StatefulWidget {
  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  // Controllers for text fields
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _slvcRegistrationController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _addressController = TextEditingController();
  final _qualificationsController = TextEditingController();
  final _experienceController = TextEditingController();
  final _practiceNameController = TextEditingController();
  final _practiceAddressController = TextEditingController();
  final _servicesController = TextEditingController();
  final _feesController = TextEditingController();
  final _availabilityController = TextEditingController();
  final _paymentMethodsController = TextEditingController();

  @override
  void dispose() {
    // Dispose controllers to avoid memory leaks
    _firstNameController.dispose();
    _lastNameController.dispose();
    _slvcRegistrationController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    _qualificationsController.dispose();
    _experienceController.dispose();
    _practiceNameController.dispose();
    _practiceAddressController.dispose();
    _servicesController.dispose();
    _feesController.dispose();
    _availabilityController.dispose();
    _paymentMethodsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile', style: TextStyle(fontFamily: 'Poppins')),
        backgroundColor: Color(0xFF357376),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _saveProfile,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Profile Picture Section
            _buildProfilePictureSection(),
            SizedBox(height: 20),

            // Personal Details Section
            _buildSection(
              title: 'Personal Details',
              children: [
                _buildTextField('First Name', _firstNameController),
                _buildTextField('Last Name', _lastNameController),
                _buildTextField('SLVC Registration', _slvcRegistrationController),
              ],
            ),
            SizedBox(height: 20),

            // Contact Information Section
            _buildSection(
              title: 'Contact Information',
              children: [
                _buildTextField('Phone', _phoneController),
                _buildTextField('Email', _emailController),
                _buildTextField('Address', _addressController),
              ],
            ),
            SizedBox(height: 20),

            // Professional Credentials Section
            _buildSection(
              title: 'Professional Credentials',
              children: [
                _buildTextField('Qualifications', _qualificationsController),
                _buildTextField('Years of Experience', _experienceController),
              ],
            ),
            SizedBox(height: 20),

            // Practice Information Section
            _buildSection(
              title: 'Practice Information',
              children: [
                _buildTextField('Practice Name', _practiceNameController),
                _buildTextField('Practice Address', _practiceAddressController),
              ],
            ),
            SizedBox(height: 20),

            // Services & Fees Section
            _buildSection(
              title: 'Services & Fees',
              children: [
                _buildTextField('Services Offered', _servicesController),
                _buildTextField('Fees', _feesController),
              ],
            ),
            SizedBox(height: 20),

            // Service Availability Section
            _buildSection(
              title: 'Service Availability',
              children: [
                _buildTextField('Availability', _availabilityController),
              ],
            ),
            SizedBox(height: 20),

            // Payment Methods Accepted Section
            _buildSection(
              title: 'Payment Methods Accepted',
              children: [
                _buildTextField('Payment Methods', _paymentMethodsController),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Build profile picture section
  Widget _buildProfilePictureSection() {
    return Center(
      child: Stack(
        children: [
          CircleAvatar(
            radius: 50,
            backgroundImage: AssetImage('assets/profile_photo.png'), // Placeholder image
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Color(0xFF64CCC5),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.edit,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Build a section with a title and children
  Widget _buildSection({required String title, required List<Widget> children}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF357376),
          ),
        ),
        SizedBox(height: 8),
        ...children,
      ],
    );
  }

  // Build a text field
  Widget _buildTextField(String label, TextEditingController controller) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(fontFamily: 'Questrial'),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }

  // Save profile data
  void _saveProfile() {
    // TODO: Implement save functionality (e.g., save to backend or local storage)
    final updatedProfile = {
      'firstName': _firstNameController.text,
      'lastName': _lastNameController.text,
      'slvcRegistration': _slvcRegistrationController.text,
      'phone': _phoneController.text,
      'email': _emailController.text,
      'address': _addressController.text,
      'qualifications': _qualificationsController.text,
      'experience': _experienceController.text,
      'practiceName': _practiceNameController.text,
      'practiceAddress': _practiceAddressController.text,
      'services': _servicesController.text,
      'fees': _feesController.text,
      'availability': _availabilityController.text,
      'paymentMethods': _paymentMethodsController.text,
    };

    // Show a success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Profile updated successfully!'),
        backgroundColor: Colors.green,
      ),
    );

    // Navigate back to the profile page
    Navigator.pop(context);
  }
} 
