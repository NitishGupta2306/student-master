import 'dart:io';
import 'package:csv/csv.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import '../models/student.dart';

class CsvExportService {
  static final CsvExportService instance = CsvExportService._init();

  CsvExportService._init();

  /// Export students to CSV file
  Future<String> exportStudents(List<Student> students) async {
    // Create CSV data
    List<List<dynamic>> rows = [];

    // Add header row
    rows.add([
      'Student ID',
      'Name',
      'Email',
      'Phone',
      'Created At',
      'Updated At',
    ]);

    // Add data rows
    for (final student in students) {
      rows.add([
        student.id,
        student.name,
        student.email,
        student.phone,
        DateFormat('yyyy-MM-dd HH:mm:ss').format(student.createdAt),
        DateFormat('yyyy-MM-dd HH:mm:ss').format(student.updatedAt),
      ]);
    }

    // Convert to CSV string
    String csv = const ListToCsvConverter().convert(rows);

    // Get downloads directory (or documents for mobile)
    final dir = await _getExportDirectory();

    // Generate filename with timestamp
    final timestamp = DateFormat('yyyy-MM-dd_HH-mm-ss').format(DateTime.now());
    final fileName = 'students_export_$timestamp.csv';
    final filePath = path.join(dir.path, fileName);

    // Write to file
    final file = File(filePath);
    await file.writeAsString(csv);

    return filePath;
  }

  /// Get appropriate export directory based on platform
  Future<Directory> _getExportDirectory() async {
    if (Platform.isAndroid || Platform.isIOS) {
      // For mobile, use app's documents directory
      return await getApplicationDocumentsDirectory();
    } else {
      // For desktop, use downloads directory
      try {
        return await getDownloadsDirectory() ??
            await getApplicationDocumentsDirectory();
      } catch (e) {
        return await getApplicationDocumentsDirectory();
      }
    }
  }
}
