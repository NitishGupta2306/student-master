import 'package:flutter/foundation.dart';
import '../models/student.dart';
import 'student_repository.dart';
import '../utils/test_data_generator.dart';

class StudentProvider extends ChangeNotifier {
  final StudentRepository _repository = StudentRepository();

  List<Student> _students = [];
  bool _isLoading = false;
  bool _isLoadingMore = false;
  String _searchQuery = '';
  String _sortBy = 'name';
  bool _sortAscending = true;
  int _currentPage = 0;
  final int _pageSize = 20;
  int _totalCount = 0;
  bool _hasMore = true;

  List<Student> get students => _students;
  bool get isLoading => _isLoading;
  bool get isLoadingMore => _isLoadingMore;
  String get searchQuery => _searchQuery;
  String get sortBy => _sortBy;
  bool get sortAscending => _sortAscending;
  int get currentPage => _currentPage;
  int get pageSize => _pageSize;
  int get totalCount => _totalCount;
  int get totalPages => (_totalCount / _pageSize).ceil();
  bool get hasMore => _hasMore;

  /// Load students with current filters (initial load)
  Future<void> loadStudents() async {
    _isLoading = true;
    _currentPage = 0;
    _hasMore = true;
    notifyListeners();

    try {
      // Get total count
      _totalCount = await _repository.getStudentCount(
        searchQuery: _searchQuery,
      );

      // Get first page of students
      _students = await _repository.getAllStudents(
        searchQuery: _searchQuery,
        sortBy: _sortBy,
        ascending: _sortAscending,
        limit: _pageSize,
        offset: 0,
      );

      _hasMore = _students.length >= _pageSize;
    } catch (e) {
      debugPrint('Error loading students: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Load more students for infinite scroll
  Future<void> loadMoreStudents() async {
    if (_isLoadingMore || !_hasMore) return;

    _isLoadingMore = true;
    notifyListeners();

    try {
      _currentPage++;

      final moreStudents = await _repository.getAllStudents(
        searchQuery: _searchQuery,
        sortBy: _sortBy,
        ascending: _sortAscending,
        limit: _pageSize,
        offset: _currentPage * _pageSize,
      );

      _students.addAll(moreStudents);
      _hasMore = moreStudents.length >= _pageSize;
    } catch (e) {
      debugPrint('Error loading more students: $e');
      _currentPage--; // Revert page increment on error
    } finally {
      _isLoadingMore = false;
      notifyListeners();
    }
  }

  /// Search students
  void search(String query) {
    _searchQuery = query;
    _currentPage = 0; // Reset to first page on search
    loadStudents();
  }

  /// Sort students by column
  void sort(String column) {
    if (_sortBy == column) {
      _sortAscending = !_sortAscending;
    } else {
      _sortBy = column;
      _sortAscending = true;
    }
    loadStudents();
  }

  /// Go to next page
  void nextPage() {
    if (_currentPage < totalPages - 1) {
      _currentPage++;
      loadStudents();
    }
  }

  /// Go to previous page
  void previousPage() {
    if (_currentPage > 0) {
      _currentPage--;
      loadStudents();
    }
  }

  /// Go to specific page
  void goToPage(int page) {
    if (page >= 0 && page < totalPages) {
      _currentPage = page;
      loadStudents();
    }
  }

  /// Create a new student
  Future<Student> createStudent({
    required String name,
    required String email,
    required String phone,
    String? photoPath,
    String? videoPath,
  }) async {
    final student = await _repository.createStudent(
      name: name,
      email: email,
      phone: phone,
      photoPath: photoPath,
      videoPath: videoPath,
    );

    await loadStudents(); // Reload list
    return student;
  }

  /// Update a student
  Future<Student> updateStudent({
    required String id,
    String? name,
    String? email,
    String? phone,
    String? photoPath,
    String? videoPath,
  }) async {
    final student = await _repository.updateStudent(
      id: id,
      name: name,
      email: email,
      phone: phone,
      photoPath: photoPath,
      videoPath: videoPath,
    );

    await loadStudents(); // Reload list
    return student;
  }

  /// Delete a student
  Future<void> deleteStudent(String id) async {
    await _repository.deleteStudent(id);
    await loadStudents(); // Reload list
  }

  /// Get a single student by ID
  Future<Student?> getStudentById(String id) async {
    return await _repository.getStudentById(id);
  }

  /// Refresh students list
  Future<void> refresh() async {
    await loadStudents();
  }

  /// Generate test data
  Future<void> generateTestData({int count = 50}) async {
    await TestDataGenerator.generateTestData(
      repository: _repository,
      count: count,
    );
    await loadStudents();
  }

  /// Delete all students
  Future<void> deleteAllStudents() async {
    for (final student in _students) {
      await _repository.deleteStudent(student.id);
    }
    await loadStudents();
  }
}
