//frontend1/lib/services/api_service.dart
import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'api_config.dart';

class ApiException implements Exception {
  final String message;
  final int? statusCode;

  ApiException(this.message, {this.statusCode});

  @override
  String toString() => 'ApiException: $message (Status code: $statusCode)';
}

class ApiService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Get the current user's ID token for authentication
  Future<String?> _getIdToken() async {
    final User? user = _auth.currentUser;
    if (user != null) {
      return await user.getIdToken();
    }
    return null;
  }

  // Add auth headers to requests
  Future<Map<String, String>> _getHeaders({bool requiresAuth = true}) async {
    Map<String, String> headers = {
      'Content-Type': 'application/json',
    };

    if (requiresAuth) {
      final String? token = await _getIdToken();
      if (token != null) {
        headers['Authorization'] = 'Bearer $token';
      }
    }

    return headers;
  }

  // Handle API errors
  void _handleError(http.Response response) {
    if (response.statusCode >= 400) {
      final body = json.decode(response.body);
      throw ApiException(body['message'] ?? 'Unknown error occurred');
    }
  }

  // Retry mechanism for failed requests
  Future<T> withRetry<T>(Future<T> Function() operation,
      {int maxAttempts = 3}) async {
    int attempts = 0;
    while (attempts < maxAttempts) {
      try {
        return await operation();
      } catch (e) {
        attempts++;
        if (attempts == maxAttempts) rethrow;
        await Future.delayed(Duration(seconds: attempts));
      }
    }
    throw ApiException('Max retry attempts reached');
  }

  // GET request
  Future<dynamic> get(String endpoint, {bool requiresAuth = true}) async {
    return withRetry(() async {
      try {
        final headers = await _getHeaders(requiresAuth: requiresAuth);
        final response = await http
            .get(
              Uri.parse(endpoint),
              headers: headers,
            )
            .timeout(ApiConfig.connectionTimeout);

        _handleError(response);
        return json.decode(response.body);
      } on SocketException {
        throw ApiException('No internet connection');
      } on FormatException {
        throw ApiException('Invalid response format');
      } on http.ClientException {
        throw ApiException('Connection error');
      } on TimeoutException {
        throw ApiException('Request timed out');
      }
    });
  }

  // POST request
  Future<dynamic> post(String endpoint, dynamic data,
      {bool requiresAuth = true}) async {
    return withRetry(() async {
      try {
        final headers = await _getHeaders(requiresAuth: requiresAuth);
        final response = await http
            .post(
              Uri.parse(endpoint),
              headers: headers,
              body: json.encode(data),
            )
            .timeout(ApiConfig.connectionTimeout);

        _handleError(response);
        return json.decode(response.body);
      } on SocketException {
        throw ApiException('No internet connection');
      } on FormatException {
        throw ApiException('Invalid response format');
      } on http.ClientException {
        throw ApiException('Connection error');
      } on TimeoutException {
        throw ApiException('Request timed out');
      }
    });
  }

  // PUT request
  Future<dynamic> put(String endpoint, dynamic data,
      {bool requiresAuth = true}) async {
    return withRetry(() async {
      try {
        final headers = await _getHeaders(requiresAuth: requiresAuth);
        final response = await http
            .put(
              Uri.parse(endpoint),
              headers: headers,
              body: json.encode(data),
            )
            .timeout(ApiConfig.connectionTimeout);

        _handleError(response);
        return json.decode(response.body);
      } on SocketException {
        throw ApiException('No internet connection');
      } on FormatException {
        throw ApiException('Invalid response format');
      } on http.ClientException {
        throw ApiException('Connection error');
      } on TimeoutException {
        throw ApiException('Request timed out');
      }
    });
  }

  // DELETE request
  Future<dynamic> delete(String endpoint, {bool requiresAuth = true}) async {
    return withRetry(() async {
      try {
        final headers = await _getHeaders(requiresAuth: requiresAuth);
        final response = await http
            .delete(
              Uri.parse(endpoint),
              headers: headers,
            )
            .timeout(ApiConfig.connectionTimeout);

        _handleError(response);
        return json.decode(response.body);
      } on SocketException {
        throw ApiException('No internet connection');
      } on FormatException {
        throw ApiException('Invalid response format');
      } on http.ClientException {
        throw ApiException('Connection error');
      } on TimeoutException {
        throw ApiException('Request timed out');
      }
    });
  }

  // Health check
  Future<bool> checkHealth() async {
    try {
      final response = await get(ApiConfig.health, requiresAuth: false);
      return response['status'] == 'OK';
    } catch (e) {
      print('Health check failed: $e');
      return false;
    }
  }
}
