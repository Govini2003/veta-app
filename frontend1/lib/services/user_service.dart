//frontend1/lib/services/user_service.dart
import 'api_service.dart';
import 'api_config.dart';

class UserService {
  final ApiService _apiService = ApiService();

  // Register a new user
  Future<Map<String, dynamic>> registerUser(
      Map<String, dynamic> userData) async {
    try {
      final response = await _apiService.post(
        '${ApiConfig.users}/register',
        userData,
        requiresAuth: false, // Registration doesn't require auth
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  // Get user profile
  Future<Map<String, dynamic>> getUserProfile(String userId) async {
    try {
      final response =
          await _apiService.get('${ApiConfig.users}/profile/$userId');
      return response;
    } catch (e) {
      rethrow;
    }
  }

  // Update user profile
  Future<Map<String, dynamic>> updateUserProfile(
      String userId, Map<String, dynamic> userData) async {
    try {
      final response = await _apiService.put(
        '${ApiConfig.users}/profile/$userId',
        userData,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  // Sync Firebase user with backend
  Future<Map<String, dynamic>> syncUserWithBackend(
      Map<String, dynamic> userData) async {
    try {
      final response = await _apiService.post(
        '${ApiConfig.users}/sync',
        userData,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }
}
