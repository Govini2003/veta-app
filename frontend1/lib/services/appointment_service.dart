//frontend1/lib/services/appointment_service.dart
import 'api_service.dart';
import 'api_config.dart';

class AppointmentService {
  final ApiService _apiService = ApiService();

  // Get appointments for a user (pet owner or vet)
  Future<List<dynamic>> getUserAppointments(String userId,
      {String? role}) async {
    try {
      String endpoint = '${ApiConfig.appointments}/user/$userId';
      if (role != null) {
        endpoint += '?role=$role';
      }
      final response = await _apiService.get(endpoint);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  // Get specific appointment details
  Future<Map<String, dynamic>> getAppointmentDetails(
      String appointmentId) async {
    try {
      final response =
          await _apiService.get('${ApiConfig.appointments}/$appointmentId');
      return response;
    } catch (e) {
      rethrow;
    }
  }

  // Create a new appointment
  Future<Map<String, dynamic>> createAppointment(
      Map<String, dynamic> appointmentData) async {
    try {
      final response = await _apiService.post(
        ApiConfig.appointments,
        appointmentData,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  // Update appointment details
  Future<Map<String, dynamic>> updateAppointment(
      String appointmentId, Map<String, dynamic> appointmentData) async {
    try {
      final response = await _apiService.put(
        '${ApiConfig.appointments}/$appointmentId',
        appointmentData,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  // Cancel appointment
  Future<Map<String, dynamic>> cancelAppointment(String appointmentId) async {
    try {
      final response = await _apiService.put(
        '${ApiConfig.appointments}/$appointmentId/cancel',
        {},
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  // Complete appointment
  Future<Map<String, dynamic>> completeAppointment(
      String appointmentId, Map<String, dynamic> notes) async {
    try {
      final response = await _apiService.put(
        '${ApiConfig.appointments}/$appointmentId/complete',
        notes,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }


  Future<List<dynamic>> getVetAvailability(String vetId, String date) async {
    try {
      final response = await _apiService
          .get('${ApiConfig.appointments}/availability/$vetId?date=$date');
      return response;
    } catch (e) {
      rethrow;
    }
  }
}
