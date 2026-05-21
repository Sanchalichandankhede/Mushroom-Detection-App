import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiConfig {
  /// Returns the base URL for the backend API.
  /// Handles platform-specific differences (Android Emulator vs iOS/Web).
  static String get baseUrl {
    // 1. Try to get from .env
    final envUrl = dotenv.env['BACKEND_URL'];
    if (envUrl != null && envUrl.isNotEmpty) {
      return envUrl;
    }

    // 2. Fallback logic if .env is missing or incorrectly loaded
    if (kIsWeb) {
      return 'http://localhost:8000';
    } else if (Platform.isAndroid) {
      // 10.0.2.2 is the special gateway to the host machine's localhost from Android Emulator
      return 'http://10.0.2.2:8000';
    } else {
      // iOS Simulator or real device (real device would need the host's actual IP)
      return 'http://localhost:8000';
    }
  }

  /// Helper to generate full API URLs
  static String getUrl(String endpoint) {
    if (endpoint.startsWith('http://') || endpoint.startsWith('https://')) {
      return endpoint;
    }
    // Ensure endpoint doesn't have double slashes
    final cleanEndpoint = endpoint.startsWith('/') ? endpoint : '/$endpoint';
    return '$baseUrl$cleanEndpoint';
  }
}
