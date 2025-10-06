import '../constants/app_constants.dart';

/// Utility class for validating user input throughout the application.
///
/// Provides static methods for validating emails, phone numbers, names,
/// file sizes, and file extensions.
class Validators {
  /// Validates email format using RFC 5322 compliant regex.
  ///
  /// Returns an error message if invalid, null if valid.
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }

    // RFC 5322 compliant email regex (simplified)
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );

    if (!emailRegex.hasMatch(value)) {
      return 'Please enter a valid email';
    }

    return null;
  }

  /// Validates Indian phone number format: +91 XXXXXXXXXX.
  ///
  /// Returns an error message if invalid, null if valid.
  static String? validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Phone number is required';
    }

    // Remove spaces for validation
    final cleaned = value.replaceAll(' ', '');

    // Match +91 followed by exactly 10 digits
    final phoneRegex = RegExp(r'^\+91\d{10}$');

    if (!phoneRegex.hasMatch(cleaned)) {
      return 'Phone must be in format: +91 XXXXXXXXXX';
    }

    return null;
  }

  /// Validates student name is not empty and meets minimum length.
  ///
  /// Returns an error message if invalid, null if valid.
  static String? validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Name is required';
    }

    if (value.trim().length < AppConstants.minNameLength) {
      return 'Name must be at least ${AppConstants.minNameLength} characters';
    }

    return null;
  }

  /// Formats phone number with space after country code (+91 XXXXXXXXXX).
  static String formatPhoneNumber(String phone) {
    final cleaned = phone.replaceAll(' ', '');
    if (cleaned.startsWith('+91') && cleaned.length == 13) {
      return '+91 ${cleaned.substring(3)}';
    }
    return phone;
  }

  /// Validates file size is within allowed limit.
  ///
  /// Returns an error message if file exceeds [maxBytes], null if valid.
  static String? validateFileSize(int bytes, int maxBytes, String fileType) {
    if (bytes > maxBytes) {
      final maxMB = (maxBytes / (1024 * 1024)).toStringAsFixed(1);
      return '$fileType exceeds maximum size of $maxMB MB';
    }
    return null;
  }

  /// Validates video duration is within allowed limit.
  ///
  /// Returns an error message if video exceeds [maxSeconds], null if valid.
  static String? validateVideoDuration(int seconds, int maxSeconds) {
    if (seconds > maxSeconds) {
      final maxMinutes = (maxSeconds / 60).round();
      return 'Video exceeds maximum duration of $maxMinutes minutes';
    }
    return null;
  }

  /// Checks if the file has a valid image extension (jpg, jpeg, png).
  static bool isValidImageExtension(String filename) {
    final ext = filename.toLowerCase().split('.').last;
    return AppConstants.allowedImageExtensions.contains(ext);
  }

  /// Checks if the file has a valid video extension (mp4, mov, avi).
  static bool isValidVideoExtension(String filename) {
    final ext = filename.toLowerCase().split('.').last;
    return AppConstants.allowedVideoExtensions.contains(ext);
  }
}
