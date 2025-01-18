class ApiConfig {
  static String get baseUrl {
    final uri = Uri.base;
    if (uri.host == '127.0.0.1' || uri.host == 'localhost') {
      return 'http://127.0.0.1:5000';
    } else {
      return 'http://13.60.25.33';
    }
  }
}
