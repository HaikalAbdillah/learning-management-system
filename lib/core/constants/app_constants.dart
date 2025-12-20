class AppConstants {
  static const String appName = 'E-Learning Management System';
  static const String primaryColor = '#DC143C';
  static const String whiteColor = '#FFFFFF';
  static const String blackColor = '#000000';

  // API Constants (for future use)
  static const String baseUrl = 'https://api.elearningms.com';
  static const String apiVersion = 'v1';

  // Storage Keys
  static const String userTokenKey = 'user_token';
  static const String userIdKey = 'user_id';
  static const String userNameKey = 'user_name';
  static const String userEmailKey = 'user_email';

  // Timeouts
  static const int apiTimeout = 30;

  // Pagination
  static const int defaultPageSize = 20;

  // Quiz Constants
  static const String quizPrimaryColor = '#DC143C';
  static const String quizCorrectColor = '#4CAF50';
  static const String quizIncorrectColor = '#F44336';
  static const int quizResultDelaySeconds = 2;
  static const double quizButtonPadding = 15.0;
  static const double quizSpacingMedium = 30.0;
  static const double quizSpacingSmall = 15.0;
}
