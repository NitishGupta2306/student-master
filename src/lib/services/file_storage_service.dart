import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

class FileStorageService {
  static final FileStorageService instance = FileStorageService._init();

  FileStorageService._init();

  /// Get the app's documents directory for storing files
  Future<Directory> get _appDirectory async {
    final appDir = await getApplicationDocumentsDirectory();
    final studentFilesDir = Directory(path.join(appDir.path, 'student_files'));

    // Create directory if it doesn't exist
    if (!await studentFilesDir.exists()) {
      await studentFilesDir.create(recursive: true);
    }

    return studentFilesDir;
  }

  /// Save a photo file and return the path
  Future<String> savePhoto(File sourceFile, String studentId) async {
    final dir = await _appDirectory;
    final extension = path.extension(sourceFile.path);
    final fileName = '${studentId}_photo$extension';
    final targetPath = path.join(dir.path, fileName);

    // Copy file to app directory
    await sourceFile.copy(targetPath);

    return targetPath;
  }

  /// Save a video file and return the path
  Future<String> saveVideo(File sourceFile, String studentId) async {
    final dir = await _appDirectory;
    final extension = path.extension(sourceFile.path);
    final fileName = '${studentId}_video$extension';
    final targetPath = path.join(dir.path, fileName);

    // Copy file to app directory
    await sourceFile.copy(targetPath);

    return targetPath;
  }

  /// Delete a file by path
  Future<void> deleteFile(String? filePath) async {
    if (filePath == null || filePath.isEmpty) return;

    final file = File(filePath);
    if (await file.exists()) {
      await file.delete();
    }
  }

  /// Delete all files associated with a student
  Future<void> deleteStudentFiles({
    String? photoPath,
    String? videoPath,
  }) async {
    await Future.wait([deleteFile(photoPath), deleteFile(videoPath)]);
  }

  /// Check if a file exists
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
