//frontend1/lib/services/review_service.dart
import 'api_service.dart';
import 'api_config.dart';

class ReviewService {
  final ApiService _apiService = ApiService();

  // Get reviews for a vet
  Future<List<dynamic>> getVetReviews(String vetId) async {
    try {
      final response = await _apiService.get('${ApiConfig.reviews}/vet/$vetId');
      return response;
    } catch (e) {
      rethrow;
    }
  }

  // Get reviews by a user
  Future<List<dynamic>> getUserReviews(String userId) async {
    try {
      final response =
          await _apiService.get('${ApiConfig.reviews}/user/$userId');
      return response;
    } catch (e) {
      rethrow;
    }
  }

  // Create a new review
  Future<Map<String, dynamic>> createReview(
      Map<String, dynamic> reviewData) async {
    try {
      final response = await _apiService.post(
        ApiConfig.reviews,
        reviewData,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  // Update a review
  Future<Map<String, dynamic>> updateReview(
      String reviewId, Map<String, dynamic> reviewData) async {
    try {
      final response = await _apiService.put(
        '${ApiConfig.reviews}/$reviewId',
        reviewData,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  // Delete a review
  Future<Map<String, dynamic>> deleteReview(String reviewId) async {
    try {
      final response =
          await _apiService.delete('${ApiConfig.reviews}/$reviewId');
      return response;
    } catch (e) {
      rethrow;
    }
  }

  // Get average rating for a vet
  Future<Map<String, dynamic>> getVetRating(String vetId) async {
    try {
      final response =
          await _apiService.get('${ApiConfig.reviews}/rating/$vetId');
      return response;
    } catch (e) {
      rethrow;
    }
  }
}
