import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:flutter_image_compress/flutter_image_compress.dart';

/// Service for managing file storage operations for student photos and videos.
///
/// Handles saving, compressing, and deleting student-related media files.
/// Uses singleton pattern to ensure consistent file management.
class FileStorageService {
  /// Singleton instance of [FileStorageService]
  static final FileStorageService instance = FileStorageService._init();

  FileStorageService._init();

  /// Gets the app's documents directory for storing files.
  Future<Directory> get _appDirectory async {
    final appDir = await getApplicationDocumentsDirectory();
    final studentFilesDir = Directory(path.join(appDir.path, 'student_files'));

    // Create directory if it doesn't exist
    if (!await studentFilesDir.exists()) {
      await studentFilesDir.create(recursive: true);
    }

    return studentFilesDir;
  }

  /// Saves a photo file with compression and returns the storage path.
  ///
  /// Images are compressed to JPEG format with max dimensions of 1024x1024
  /// and 85% quality to reduce storage usage while maintaining visual quality.
  Future<String> savePhoto(File sourceFile, String studentId) async {
    final dir = await _appDirectory;
    final fileName = '${studentId}_photo.jpg';
    final targetPath = path.join(dir.path, fileName);

    // Compress and save image
    final compressedBytes = await FlutterImageCompress.compressWithFile(
      sourceFile.absolute.path,
      minWidth: 1024,
      minHeight: 1024,
      quality: 85,
      format: CompressFormat.jpeg,
    );

    if (compressedBytes != null) {
      final targetFile = File(targetPath);
      await targetFile.writeAsBytes(compressedBytes);
    } else {
      // Fallback: copy original if compression fails
      await sourceFile.copy(targetPath);
    }

    return targetPath;
  }

  /// Saves a video file and returns the storage path.
  Future<String> saveVideo(File sourceFile, String studentId) async {
    final dir = await _appDirectory;
    final extension = path.extension(sourceFile.path);
    final fileName = '${studentId}_video$extension';
    final targetPath = path.join(dir.path, fileName);

    // Copy file to app directory
    await sourceFile.copy(targetPath);

    return targetPath;
  }

  /// Deletes a file at the specified path if it exists.
  Future<void> deleteFile(String? filePath) async {
    if (filePath == null || filePath.isEmpty) return;

    final file = File(filePath);
    if (await file.exists()) {
      await file.delete();
    }
  }

  /// Deletes all files (photo and video) associated with a student.
  Future<void> deleteStudentFiles({
    String? photoPath,
    String? videoPath,
  }) async {
    await Future.wait([deleteFile(photoPath), deleteFile(videoPath)]);
  }

  /// Checks if a file exists at the specified path.
  Future<bool> fileExists(String? filePath) async {
    if (filePath == null || filePath.isEmpty) return false;
    return await File(filePath).exists();
  }

  /// Get file size in bytes
  Future<int> getFileSize(File file) async {
    return await file.length();
  }

  /// Get file size from path
  Future<int?> getFileSizeFromPath(String? filePath) async {
    if (filePath == null || filePath.isEmpty) return null;
    final file = File(filePath);
    if (await file.exists()) {
      return await file.length();
    }
    return null;
  }
}
