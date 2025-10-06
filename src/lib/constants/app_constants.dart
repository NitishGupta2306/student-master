/// Application-wide constants
class AppConstants {
  // File size limits (in bytes)
  static const int maxPhotoSizeBytes = 5 * 1024 * 1024; // 5 MB
  static const int maxVideoSizeBytes = 50 * 1024 * 1024; // 50 MB

  // Video constraints
  static const int maxVideoDurationSeconds = 60; // 1 minute

  // Pagination
  static const int defaultPageSize = 50;
  static const int loadMoreThreshold = 200; // pixels from bottom

  // Database
  static const String databaseName = 'students.db';
  static const int databaseVersion = 1;

  // File extensions
  static const List<String> allowedImageExtensions = ['jpg', 'jpeg', 'png'];
  static const List<String> allowedVideoExtensions = ['mp4', 'mov', 'avi'];

  // Validation
  static const int minNameLength = 2;
  static const int maxNameLength = 100;

  // UI
  static const double defaultCardElevation = 2.0;
  static const double defaultBorderRadius = 12.0;
  static const double defaultPadding = 12.0;
  static const double defaultSpacing = 8.0;

  // Student ID format
  static const String studentIdPrefix = 'STU';
  static const int studentIdYearDigits = 4;
  static const int studentIdSequenceDigits = 4;
}
