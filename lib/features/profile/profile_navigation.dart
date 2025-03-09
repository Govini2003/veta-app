// veta-app/lib/features/profile/profile_navigation.dart
import 'package:flutter/material.dart';
import 'package:veta_1/features/profile/add_owner_details_page.dart';
import 'package:veta_1/features/profile/add_pet_page.dart';
import 'package:veta_1/features/profile/edit_profile_page.dart';
import 'package:veta_1/features/profile/pet_details_page.dart';

class ProfileNavigation {
  static void navigateToAddOwnerDetails(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddOwnerDetailsPage()),
    );
  }

  static void navigateToAddPet(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddPetPage()),
    );
  }

  static void navigateToEditProfile(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => EditProfilePage()),
    );
  }

  static void navigateToPetDetails(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => PetDetailsPage()),
    );
  }
}
