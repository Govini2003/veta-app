import 'api_service.dart';
import 'api_config.dart';

class PetService {
  final ApiService _apiService = ApiService();

  // Get all pets for a user
  Future<List<dynamic>> getUserPets(String userId) async {
    try {
      final response = await _apiService.get('${ApiConfig.pets}/user/$userId');
      return response;
    } catch (e) {
      rethrow;
    }
  }

  // Get specific pet details
  Future<Map<String, dynamic>> getPetDetails(String petId) async {
    try {
      final response = await _apiService.get('${ApiConfig.pets}/$petId');
      return response;
    } catch (e) {
      rethrow;
    }
  }

  // Create a new pet
  Future<Map<String, dynamic>> createPet(Map<String, dynamic> petData) async {
    try {
      final response = await _apiService.post(
        ApiConfig.pets,
        petData,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  // Update pet details
  Future<Map<String, dynamic>> updatePet(
      String petId, Map<String, dynamic> petData) async {
    try {
      final response = await _apiService.put(
        '${ApiConfig.pets}/$petId',
        petData,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  // Add medical history
  Future<Map<String, dynamic>> addMedicalHistory(
      String petId, Map<String, dynamic> medicalData) async {
    try {
      final response = await _apiService.post(
        '${ApiConfig.pets}/$petId/medical-history',
        medicalData,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  // Add vaccination
  Future<Map<String, dynamic>> addVaccination(
      String petId, Map<String, dynamic> vaccinationData) async {
    try {
      final response = await _apiService.post(
        '${ApiConfig.pets}/$petId/vaccination',
        vaccinationData,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }
}
