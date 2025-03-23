//frontend1/lib/services/api_config.dart
import 'dart:io';

enum Environment { development, staging, production }

class ApiConfig {
  static Environment environment = Environment.development;

  // Base URLs for different environments
  static const Map<Environment, String> _baseUrls = {
    Environment.development: 'http://10.0.2.2:3000/api', // Android emulator
    Environment.staging: 'https://staging-api.veta-app.com/api',
    Environment.production: 'https://api.veta-app.com/api',
  };

  // Platform-specific development URLs
  static const String _devAndroidUrl = 'http://10.0.2.2:3000/api';
  static const String _devIosUrl = 'http://localhost:3000/api';

  // Get the appropriate base URL
  static String get baseUrl {
    if (environment == Environment.development) {
      return Platform.isAndroid ? _devAndroidUrl : _devIosUrl;
    }
    return _baseUrls[environment]!;
  }

  // API Endpoints
  static String get users => '$baseUrl/users';
  static String get pets => '$baseUrl/pets';
  static String get appointments => '$baseUrl/appointments';
  static String get reviews => '$baseUrl/reviews';
  static String get health => '$baseUrl/health'; // Health check endpoint

  // Timeout configurations
  static const Duration connectionTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);

  // SSL/TLS Configuration
  static bool get useHttps => environment != Environment.development;

  // Headers
  static Map<String, String> get headers => {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        if (environment != Environment.development)
          'X-Environment': environment.toString().split('.').last,
      };

  // Initialize configuration for the current environment
  static void initConfig(Environment env) {
    environment = env;
    print(
        'API Configuration initialized for: ${env.toString().split('.').last}');
    print('Base URL: $baseUrl');
    print('Using HTTPS: $useHttps');
  }
}
