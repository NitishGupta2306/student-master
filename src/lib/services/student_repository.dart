import 'package:sqflite/sqflite.dart';
import '../models/student.dart';
import 'database_helper.dart';
import 'file_storage_service.dart';
import '../utils/id_generator.dart';

class StudentRepository {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;
  final FileStorageService _fileStorage = FileStorageService.instance;

  /// Create a new student
  Future<Student> createStudent({
    required String name,
    required String email,
    required String phone,
    String? photoPath,
    String? videoPath,
  }) async {
    final db = await _dbHelper.database;

    // Check for duplicate email
    final emailExists = await _checkEmailExists(email);
    if (emailExists) {
      throw Exception('Email already exists');
    }

    // Check for duplicate phone
    final phoneExists = await _checkPhoneExists(phone);
    if (phoneExists) {
      throw Exception('Phone number already exists');
    }

    // Generate new student ID
    final id = await IdGenerator.generateStudentId(db);
    final now = DateTime.now();

    final student = Student(
      id: id,
      name: name,
      email: email,
      phone: phone,
      photoPath: photoPath,
      videoPath: videoPath,
      createdAt: now,
      updatedAt: now,
    );

    await db.insert('students', student.toMap());

    return student;
  }

  /// Get a student by ID
  Future<Student?> getStudentById(String id) async {
    final db = await _dbHelper.database;
    final maps = await db.query('students', where: 'id = ?', whereArgs: [id]);

    if (maps.isEmpty) return null;
    return Student.fromMap(maps.first);
  }

  /// Get all students with optional search, sorting, and pagination
  Future<List<Student>> getAllStudents({
    String? searchQuery,
    String sortBy = 'name',
    bool ascending = true,
    int? limit,
    int? offset,
  }) async {
    final db = await _dbHelper.database;

    String? where;
    List<dynamic>? whereArgs;

    // Build search query
    if (searchQuery != null && searchQuery.isNotEmpty) {
      where = 'name LIKE ? OR email LIKE ? OR phone LIKE ?';
      final searchPattern = '%$searchQuery%';
      whereArgs = [searchPattern, searchPattern, searchPattern];
    }

    // Build order by clause
    final orderBy = '$sortBy ${ascending ? 'ASC' : 'DESC'}';

    final maps = await db.query(
      'students',
      where: where,
      whereArgs: whereArgs,
      orderBy: orderBy,
      limit: limit,
      offset: offset,
    );

    return maps.map((map) => Student.fromMap(map)).toList();
  }

  /// Get total count of students (for pagination)
  Future<int> getStudentCount({String? searchQuery}) async {
    final db = await _dbHelper.database;

    String? where;
    List<dynamic>? whereArgs;

    if (searchQuery != null && searchQuery.isNotEmpty) {
      where = 'name LIKE ? OR email LIKE ? OR phone LIKE ?';
      final searchPattern = '%$searchQuery%';
      whereArgs = [searchPattern, searchPattern, searchPattern];
    }

    final result = await db.query(
      'students',
      columns: ['COUNT(*) as count'],
      where: where,
      whereArgs: whereArgs,
    );

    return Sqflite.firstIntValue(result) ?? 0;
  }

  /// Update an existing student
  Future<Student> updateStudent({
    required String id,
    String? name,
    String? email,
    String? phone,
    String? photoPath,
    String? videoPath,
  }) async {
    final db = await _dbHelper.database;

    // Get existing student
    final existing = await getStudentById(id);
    if (existing == null) {
      throw Exception('Student not found');
    }

    // Check for duplicate email (excluding current student)
    if (email != null && email != existing.email) {
      final emailExists = await _checkEmailExists(email, excludeId: id);
      if (emailExists) {
        throw Exception('Email already exists');
      }
    }

    // Check for duplicate phone (excluding current student)
    if (phone != null && phone != existing.phone) {
      final phoneExists = await _checkPhoneExists(phone, excludeId: id);
      if (phoneExists) {
        throw Exception('Phone number already exists');
      }
    }

    final updated = existing.copyWith(
      name: name,
      email: email,
      phone: phone,
      photoPath: photoPath,
      videoPath: videoPath,
      updatedAt: DateTime.now(),
    );

    await db.update(
      'students',
      updated.toMap(),
      where: 'id = ?',
      whereArgs: [id],
    );

    return updated;
  }

  /// Delete a student and associated files
  Future<void> deleteStudent(String id) async {
    final db = await _dbHelper.database;

    // Get student to find file paths
    final student = await getStudentById(id);
    if (student == null) {
      throw Exception('Student not found');
    }

    // Delete associated files
    await _fileStorage.deleteStudentFiles(
      photoPath: student.photoPath,
      videoPath: student.videoPath,
    );

    // Delete from database
    await db.delete('students', where: 'id = ?', whereArgs: [id]);
  }

  /// Check if email exists
  Future<bool> _checkEmailExists(String email, {String? excludeId}) async {
    final db = await _dbHelper.database;

    String where = 'email = ?';
    List<dynamic> whereArgs = [email];

    if (excludeId != null) {
      where += ' AND id != ?';
      whereArgs.add(excludeId);
    }

    final result = await db.query(
      'students',
      where: where,
      whereArgs: whereArgs,
      limit: 1,
    );

    return result.isNotEmpty;
  }

  /// Check if phone exists
  Future<bool> _checkPhoneExists(String phone, {String? excludeId}) async {
    final db = await _dbHelper.database;

    String where = 'phone = ?';
    List<dynamic> whereArgs = [phone];

    if (excludeId != null) {
      where += ' AND id != ?';
      whereArgs.add(excludeId);
    }

    final result = await db.query(
      'students',
      where: where,
      whereArgs: whereArgs,
      limit: 1,
    );

    return result.isNotEmpty;
  }

  /// Delete all students (for testing)
  Future<void> deleteAllStudents() async {
    final db = await _dbHelper.database;

    // Get all students to delete their files
    final students = await getAllStudents();
    for (final student in students) {
      await _fileStorage.deleteStudentFiles(
        photoPath: student.photoPath,
        videoPath: student.videoPath,
      );
    }

    await db.delete('students');
  }
}
