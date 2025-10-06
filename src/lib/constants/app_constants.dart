/// Application-wide constants for configuration and validation.
///
/// This class contains all magic numbers and configuration values used
/// throughout the application to maintain consistency and ease of modification.
class AppConstants {
  /// Maximum allowed file size for photos (5 MB in bytes)
  static const int maxPhotoSizeBytes = 5 * 1024 * 1024;

  /// Maximum allowed file size for videos (50 MB in bytes)
  static const int maxVideoSizeBytes = 50 * 1024 * 1024;

  /// Maximum allowed video duration (60 seconds / 1 minute)
  static const int maxVideoDurationSeconds = 60;

  /// Default number of items to load per page for pagination
  static const int defaultPageSize = 50;

  /// Distance in pixels from bottom of list to trigger loading more items
  static const int loadMoreThreshold = 200;

  /// SQLite database filename
  static const String databaseName = 'students.db';

  /// Current database schema version
  static const int databaseVersion = 1;

  /// Allowed image file extensions for photo uploads
  static const List<String> allowedImageExtensions = ['jpg', 'jpeg', 'png'];

  /// Allowed video file extensions for video uploads
  static const List<String> allowedVideoExtensions = ['mp4', 'mov', 'avi'];

  /// Minimum length for student name
  static const int minNameLength = 2;

  /// Maximum length for student name
  static const int maxNameLength = 100;

  /// Default elevation for cards throughout the app
  static const double defaultCardElevation = 2.0;

  /// Default border radius for rounded corners
  static const double defaultBorderRadius = 12.0;

  /// Default padding value for consistent spacing
  static const double defaultPadding = 12.0;

  /// Default spacing between UI elements
  static const double defaultSpacing = 8.0;

  /// Prefix for student ID (e.g., STU-2024-0001)
  static const String studentIdPrefix = 'STU';

  /// Number of digits for year in student ID
  static const int studentIdYearDigits = 4;

  /// Number of digits for sequence number in student ID
  static const int studentIdSequenceDigits = 4;
}
