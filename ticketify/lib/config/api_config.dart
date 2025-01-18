import 'package:flutter/foundation.dart';

class ApiConfig {
  static String get baseUrl {
    if (kReleaseMode) {
      // In release mode (production), use the actual deployed URL
      return 'http://13.60.25.33';
    } else {
      // In debug or development mode, use the local backend URL
      return 'http://127.0.0.1:5000';
    }
  }
}
