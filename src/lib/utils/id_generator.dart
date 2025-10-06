import 'package:sqflite/sqflite.dart';

class IdGenerator {
  /// Generate a new student ID in the format STU-YYYY-NNNN
  /// Example: STU-2025-0001
  static Future<String> generateStudentId(Database db) async {
    final now = DateTime.now();
    final year = now.year;

    // Query for the highest sequence number for the current year
    final result = await db.rawQuery('''
      SELECT id FROM students
      WHERE id LIKE 'STU-$year-%'
      ORDER BY id DESC
      LIMIT 1
    ''');

    int nextSequence = 1;

    if (result.isNotEmpty) {
      final lastId = result.first['id'] as String;
      // Extract sequence number from ID (e.g., "STU-2025-0042" -> "0042")
      final parts = lastId.split('-');
      if (parts.length == 3) {
        final lastSequence = int.tryParse(parts[2]) ?? 0;
        nextSequence = lastSequence + 1;
      }
    }

    // Format: STU-YYYY-NNNN (zero-padded to 4 digits)
    final sequenceStr = nextSequence.toString().padLeft(4, '0');
    return 'STU-$year-$sequenceStr';
  }
}
