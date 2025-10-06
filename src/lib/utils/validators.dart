import '../constants/app_constants.dart';

class Validators {
  /// Validate email format
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

  /// Validate Indian phone number format: +91 XXXXXXXXXX
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

  /// Validate name (not empty)
  static String? validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Name is required';
    }

    if (value.trim().length < AppConstants.minNameLength) {
      return 'Name must be at least ${AppConstants.minNameLength} characters';
    }

    return null;
  }

  /// Format phone number with space after country code
  static String formatPhoneNumber(String phone) {
    final cleaned = phone.replaceAll(' ', '');
    if (cleaned.startsWith('+91') && cleaned.length == 13) {
      return '+91 ${cleaned.substring(3)}';
    }
    return phone;
  }

  /// Validate file size in bytes
  static String? validateFileSize(int bytes, int maxBytes, String fileType) {
    if (bytes > maxBytes) {
      final maxMB = (maxBytes / (1024 * 1024)).toStringAsFixed(1);
      return '$fileType exceeds maximum size of $maxMB MB';
    }
    return null;
  }

  /// Validate video duration in seconds
  static String? validateVideoDuration(int seconds, int maxSeconds) {
    if (seconds > maxSeconds) {
      final maxMinutes = (maxSeconds / 60).round();
      return 'Video exceeds maximum duration of $maxMinutes minutes';
    }
    return null;
  }

  /// Check if file extension is valid
  static bool isValidImageExtension(String filename) {
    final ext = filename.toLowerCase().split('.').last;
    return AppConstants.allowedImageExtensions.contains(ext);
  }

  /// Check if video extension is valid
  static bool isValidVideoExtension(String filename) {
    final ext = filename.toLowerCase().split('.').last;
    return AppConstants.allowedVideoExtensions.contains(ext);
  }
}
