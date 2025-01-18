class ApiConfig {
  static String get baseUrl {
    const environment = String.fromEnvironment('ENVIRONMENT');
    if (environment == 'production') {
      return 'http://13.60.25.33'; // Deployed URL for production
    } else {
      return 'http://127.0.0.1:5000'; // Local backend URL
    }
  }
}
