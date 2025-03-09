// veta-app/lib/features/profile/add_owner_details_page.dart

import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'models/pet_owner.dart';
import 'services/pet_owner_service.dart';
import 'theme/app_theme.dart';
import 'edit_profile_page.dart';
import 'friends_page.dart';
import 'services_page.dart';
import 'pet_details_page.dart';

class AddOwnerDetailsPage extends StatefulWidget {
  final PetOwner? initialOwner;
  final Function(PetOwner)? onOwnerUpdated;
  final bool isEditing;

  const AddOwnerDetailsPage({
    Key? key,
    this.initialOwner,
    this.onOwnerUpdated,
    this.isEditing = false,
  }) : super(key: key);

  @override
  _AddOwnerDetailsPageState createState() => _AddOwnerDetailsPageState();
}

class _AddOwnerDetailsPageState extends State<AddOwnerDetailsPage> {
  final _petOwnerService = PetOwnerService();
  
  String _name = '';
  String _email = '';
  String _phone = '';
  String _bio = '';
  String _location = '';
  File? _image;
  bool _isEditing = false;
  
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  bool _isEditingName = false;
  bool _isEditingBio = false;
  bool _isEditingLocation = false;

  @override
  void initState() {
    super.initState();
    _isEditing = widget.isEditing;
    if (widget.initialOwner != null) {
      _name = widget.initialOwner!.name;
      _email = widget.initialOwner!.email;
      _phone = widget.initialOwner!.phone;
      _bio = widget.initialOwner!.bio ?? '';
      _location = widget.initialOwner!.address ?? '';
      if (widget.initialOwner!.imagePath != null) {
        _image = File(widget.initialOwner!.imagePath!);
      }
    }
    _nameController.text = _name;
    _bioController.text = _bio;
    _locationController.text = _location;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _bioController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildTopSection(),
              _buildMainContent(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopSection() {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.primaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: Column(
        children: [
          _buildProfileHeader(),
          SizedBox(height: 20),
          _buildContactInfo(),
        ],
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Column(
      children: [
        GestureDetector(
          onTap: _pickImage,
          child: Stack(
            children: [
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: AppTheme.primaryColor, width: 3),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.primaryColor.withOpacity(0.2),
                      blurRadius: 15,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(60),
                  child: _image != null
                      ? Image.file(_image!, fit: BoxFit.cover)
                      : Icon(Icons.person, size: 60, color: AppTheme.primaryColor),
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppTheme.accentColor,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.camera_alt, size: 20, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 16),
        GestureDetector(
          onTap: () {
            setState(() {
              _isEditingName = true;
              _nameController.text = _name;
            });
          },
          child: _isEditingName
              ? Container(
                  width: 200,
                  child: TextField(
                    controller: _nameController,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textColor,
                    ),
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(color: AppTheme.primaryColor),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(color: AppTheme.primaryColor, width: 2),
                      ),
                    ),
                    onSubmitted: (value) {
                      setState(() {
                        _name = value;
                        _isEditingName = false;
                      });
                    },
                  ),
                )
              : Text(
                  _name.isEmpty ? 'Add Your Name' : _name,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textColor,
                  ),
                ),
        ),
        SizedBox(height: 8),
        GestureDetector(
          onTap: () {
            setState(() {
              _isEditingBio = true;
              _bioController.text = _bio;
            });
          },
          child: _isEditingBio
              ? Container(
                  width: 200,
                  child: TextField(
                    controller: _bioController,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: AppTheme.secondaryTextColor,
                    ),
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(color: AppTheme.primaryColor),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(color: AppTheme.primaryColor, width: 2),
                      ),
                    ),
                    onSubmitted: (value) {
                      setState(() {
                        _bio = value;
                        _isEditingBio = false;
                      });
                    },
                  ),
                )
              : Text(
                  _bio,
                  style: TextStyle(
                    fontSize: 16,
                    color: AppTheme.secondaryTextColor,
                  ),
                ),
        ),
        if (_isEditing)
          Container(
            margin: EdgeInsets.only(top: 8),
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: AppTheme.accentColor.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.star, size: 16, color: AppTheme.accentColor),
                SizedBox(width: 4),
                Text(
                  'Editing Profile',
                  style: TextStyle(
                    color: AppTheme.accentColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildContactInfo() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_email.isNotEmpty)
              _buildInfoChip(Icons.email, _email),
            if (_email.isNotEmpty && _phone.isNotEmpty)
              SizedBox(width: 12),
            if (_phone.isNotEmpty)
              _buildInfoChip(Icons.phone, _phone),
          ],
        ),
        SizedBox(height: 12),
        GestureDetector(
          onTap: () {
            setState(() {
              _isEditingLocation = true;
              _locationController.text = _location;
            });
          },
          child: _isEditingLocation
              ? Container(
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: TextField(
                    controller: _locationController,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: AppTheme.secondaryTextColor,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Enter your location',
                      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(color: AppTheme.primaryColor),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(color: AppTheme.primaryColor, width: 2),
                      ),
                    ),
                    onSubmitted: (value) {
                      setState(() {
                        _location = value;
                        _isEditingLocation = false;
                      });
                    },
                  ),
                )
              : _location.isNotEmpty
                  ? _buildInfoChip(Icons.location_on, _location)
                  : Text(
                      'Add Location',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppTheme.secondaryTextColor,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
        ),
      ],
    );
  }

  Widget _buildInfoChip(IconData icon, String text) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryColor.withOpacity(0.1),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: AppTheme.primaryColor),
          SizedBox(width: 8),
          Text(
            text,
            style: TextStyle(
              color: AppTheme.textColor,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMainContent() {
    return Padding(
      padding: EdgeInsets.all(20),
      child: Column(
        children: [
          _buildQuickAccessSection(),
          SizedBox(height: 24),
          _buildPetSection(),
          SizedBox(height: 24),
          _buildSettingsSection(),
        ],
      ),
    );
  }

  Widget _buildQuickAccessSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Access',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppTheme.textColor,
          ),
        ),
        SizedBox(height: 16),
        GridView.count(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          childAspectRatio: 1.5,
          children: [
            _buildQuickAccessCard(
              'My Pets',
              Icons.pets,
              'Manage pet profiles',
              () {
                if (widget.initialOwner?.pets.isNotEmpty ?? false) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PetDetailsPage(
                        pet: widget.initialOwner!.pets[0],
                        onPetUpdated: (updatedPet) {
                          // TODO: Update pet in owner's pets list
                        },
                      ),
                    ),
                  );
                }
              },
            ),
            _buildQuickAccessCard(
              'Find Friends',
              Icons.people_outline,
              'Connect with pet owners',
              () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FriendsPage(),
                  ),
                );
              },
            ),
            _buildQuickAccessCard(
              'Pet Services',
              Icons.local_hospital,
              'Book appointments',
              () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ServicesPage(
                      bookings: widget.initialOwner?.serviceBookings ?? [],
                      onBookingAdded: (booking) {
                        // TODO: Add booking to owner's bookings list
                      },
                    ),
                  ),
                );
              },
            ),
            _buildQuickAccessCard(
              'My Account',
              Icons.person_outline,
              'Edit profile details',
              () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditProfilePage(
                      initialName: _name,
                      initialEmail: _email,
                      initialPhone: _phone,
                      initialBio: _bio,
                      initialImage: _image,
                    ),
                  ),
                );
                
                if (result != null) {
                  setState(() {
                    _name = result['name'];
                    _email = result['email'];
                    _phone = result['phone'];
                    _bio = result['bio'];
                    _image = result['image'];
                  });
                  await _saveProfile();
                }
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildQuickAccessCard(
    String title,
    IconData icon,
    String subtitle,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: AppTheme.primaryColor.withOpacity(0.1),
              blurRadius: 10,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: AppTheme.primaryColor, size: 24),
            SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppTheme.textColor,
              ),
            ),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 12,
                color: AppTheme.secondaryTextColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPetSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'My Pets',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppTheme.textColor,
              ),
            ),
            TextButton(
              onPressed: () {},
              child: Text(
                'View All',
                style: TextStyle(
                  color: AppTheme.primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 16),
        Container(
          height: 100,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 1, 
            itemBuilder: (context, index) {
              return _buildAddPetButton();
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSettingsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Settings',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppTheme.textColor,
          ),
        ),
        SizedBox(height: 16),
        _buildSettingItem(
          'Notifications',
          Icons.notifications_outlined,
          'Manage your alerts',
          () {},
        ),
        _buildSettingItem(
          'Language',
          Icons.language_outlined,
          'Change app language',
          () {},
        ),
        _buildSettingItem(
          'Dark Mode',
          Icons.dark_mode_outlined,
          'Toggle theme',
          () {},
        ),
      ],
    );
  }

  Widget _buildSettingItem(
    String title,
    IconData icon,
    String subtitle,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 16),
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: AppTheme.primaryColor.withOpacity(0.1),
              blurRadius: 10,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppTheme.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: AppTheme.primaryColor),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textColor,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 14,
                      color: AppTheme.secondaryTextColor,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: AppTheme.secondaryTextColor,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPetAvatar(Pet pet) {
    return Padding(
      padding: EdgeInsets.only(right: 16),
      child: Column(
        children: [
          Container(
            width: AppTheme.avatarSize,
            height: AppTheme.avatarSize,
            decoration: AppTheme.avatarDecoration(),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(AppTheme.avatarSize / 2),
              child: pet.imageUrl != null
                  ? Image.network(pet.imageUrl!, fit: BoxFit.cover)
                  : Icon(Icons.pets, size: 30, color: AppTheme.primaryColor),
            ),
          ),
          SizedBox(height: 8),
          Text(
            pet.name,
            style: TextStyle(
              fontSize: 14,
              color: AppTheme.textColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddPetButton() {
    return Padding(
      padding: EdgeInsets.only(right: 16),
      child: Column(
        children: [
          Container(
            width: AppTheme.avatarSize,
            height: AppTheme.avatarSize,
            decoration: AppTheme.neumorphicDecoration(radius: AppTheme.avatarSize / 2),
            child: Icon(Icons.add, color: AppTheme.primaryColor),
          ),
          SizedBox(height: 8),
          Text(
            'Add Pet',
            style: TextStyle(
              fontSize: 14,
              color: AppTheme.textColor,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<void> _saveProfile() async {
    if (_name.isNotEmpty) {
      final updatedOwner = PetOwner(
        name: _name,
        email: _email,
        phone: _phone,
        address: _location, 
        imagePath: _image?.path,
        bio: _bio,
        createdAt: DateTime.now(),
      );
      await _petOwnerService.updatePetOwner(updatedOwner);
      
      if (widget.onOwnerUpdated != null) {
        widget.onOwnerUpdated!(updatedOwner);
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Profile updated successfully')),
      );
    }
  }
}

class Pet {
  final String name;
  final String? imageUrl;
  final String? lastCheckup;

  Pet({
    required this.name,
    this.imageUrl,
    this.lastCheckup,
  });
}
