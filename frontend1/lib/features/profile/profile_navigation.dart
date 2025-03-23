//frontend1/lib/features/profile/profile_navigation.dart
import 'dart:io';
import 'package:flutter/material.dart';
import '../../InuPetProfile/add_pet_page.dart';
import '../../InuPetProfile/pet_profile_page.dart';
import '../../Lali/screens/petO_activities_page.dart';
import '../../Lali/screens/vet_home_page.dart';

class ProfileNavigation {
  // Navigation to add a new pet
  static void navigateToAddPet(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddPetPage(),
      ),
    );
  }

  // Navigation to view pet details
  static void navigateToPetDetails(
    BuildContext context, {
    String? petId,
    String? petName,
    String? species,
    String? breed,
    String? gender,
    DateTime? dateOfBirth,
    int? age,
    double? weight,
    File? petPhoto,
    List<Map<String, dynamic>>? initialVaccines,
    List<Map<String, dynamic>> vaccines = const [],
    Function()? onDelete,
    Function(File?, double?)? onSave,
  }) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PetProfilePage(
          petId: petId ?? 'unknown',
          petName: petName ?? 'My Pet',
          species: species ?? 'Unknown',
          breed: breed ?? 'Mixed',
          gender: gender,
          dateOfBirth: dateOfBirth,
          age: age,
          weight: weight,
          petPhoto: petPhoto,
          initialVaccines: initialVaccines,
          vaccines: vaccines,
          onDelete: onDelete,
          onSave: onSave,
        ),
      ),
    );
  }

  // Navigation to edit profile
  static void navigateToEditProfile(BuildContext context) {
    // TODO: Implement edit profile navigation
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Edit Profile functionality coming soon')),
    );
  }

  // Navigation to pet activities
  static void navigateToPetActivities(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PetOActivitiesPage(),
      ),
    );
  }

  // Navigation to veterinary services
  static void navigateToVetServices(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => VetHomePage(),
      ),
    );
  }

  // Navigation to add owner details
  static void navigateToAddOwnerDetails(BuildContext context) {
    // TODO: Implement navigation to add owner details page
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Add Owner Details functionality coming soon')),
    );
  }

  // Navigation to change password
  static void navigateToChangePassword(BuildContext context) {
    // TODO: Implement navigation to change password page
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Change Password functionality coming soon')),
    );
  }

  // Show account settings dialog
  static void showAccountSettings(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Account Settings'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.person),
                title: Text('Edit Profile'),
                onTap: () {
                  Navigator.pop(context);
                  navigateToEditProfile(context);
                },
              ),
              ListTile(
                leading: Icon(Icons.security),
                title: Text('Change Password'),
                onTap: () {
                  Navigator.pop(context);
                  navigateToChangePassword(context);
                },
              ),
              ListTile(
                leading: Icon(Icons.logout),
                title: Text('Logout'),
                onTap: () {
                  Navigator.pop(context);
                  // TODO: Implement logout functionality
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Logout functionality coming soon')),
                  );
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }

  // Show help and support dialog
  static void showHelpAndSupport(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Help & Support'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Need assistance? Contact our support team:'),
              SizedBox(height: 10),
              Text('Email: support@vetaapp.com'),
              Text('Phone: +1 (555) 123-4567'),
              SizedBox(height: 10),
              Text('We\'re here to help you and your pets!'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }
}
