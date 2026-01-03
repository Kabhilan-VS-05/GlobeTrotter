class AppConstants {
  // App Info
  static const String appName = 'GlobeTrotter';
  static const String appVersion = '1.0.0';
  
  // API
  static const String baseUrl = 'https://api.globetrotter.com';
  static const Duration apiTimeout = Duration(seconds: 30);
  
  // Storage
  static const String userPrefsKey = 'user_preferences';
  static const String authTokenKey = 'auth_token';
  
  // UI
  static const double defaultPadding = 16.0;
  static const double cardRadius = 12.0;
  static const double buttonRadius = 8.0;
  
  // Validation
  static const int minPasswordLength = 6;
  static const int maxTripNameLength = 50;
  
  // Pagination
  static const int defaultPageSize = 20;
  
  // Budget
  static const double defaultBudget = 1000.0;
  static const String defaultCurrency = 'USD';
}
