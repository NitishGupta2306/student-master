import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../services/student_provider.dart';
import '../services/student_repository.dart';
import '../services/csv_export_service.dart';
import '../models/student.dart';
import '../widgets/student_detail_dialog.dart';
import '../widgets/student_form_dialog.dart';
import '../utils/test_data_generator.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // Load students on init
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<StudentProvider>().loadStudents();
    });

    // Setup infinite scroll listener
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      context.read<StudentProvider>().loadMoreStudents();
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _exportToCSV() async {
    try {
      final provider = context.read<StudentProvider>();
      final filePath = await CsvExportService.instance.exportStudents(
        provider.students,
      );

      Fluttertoast.showToast(
        msg: 'Exported to: $filePath',
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
      );
    } catch (e) {
      Fluttertoast.showToast(
        msg: 'Export failed: $e',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
      );
    }
  }

  Future<void> _showAddStudentDialog() async {
    await showDialog(
      context: context,
      builder: (context) => const StudentFormDialog(),
    );
  }

  Future<void> _showStudentDetail(Student student) async {
    await showDialog(
      context: context,
      builder: (context) => StudentDetailDialog(student: student),
    );
  }

  Future<void> _generateTestData() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Generate Test Data'),
        content: const Text('This will create 30 sample students. Continue?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Generate'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        await TestDataGenerator.generateTestData(
          repository: StudentRepository(),
          count: 30,
        );
        if (mounted) {
          await context.read<StudentProvider>().loadStudents();
          Fluttertoast.showToast(msg: 'Test data generated successfully');
        }
      } catch (e) {
        Fluttertoast.showToast(
          msg: 'Failed to generate test data: $e',
          backgroundColor: Colors.red,
        );
      }
    }
  }

  Widget _buildSortableHeader(String label, String column) {
    final provider = context.watch<StudentProvider>();
    final isActive = provider.sortBy == column;

    return InkWell(
      onTap: () => provider.sort(column),
      child: Row(
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: isActive ? Theme.of(context).primaryColor : null,
            ),
          ),
          if (isActive)
            Icon(
              provider.sortAscending
                  ? Icons.arrow_upward
                  : Icons.arrow_downward,
              size: 16,
              color: Theme.of(context).primaryColor,
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Search and Action Bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            color: Colors.grey[100],
            child: LayoutBuilder(
              builder: (context, constraints) {
                // Mobile layout (portrait)
                if (constraints.maxWidth < 600) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Search bar
                      TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          hintText: 'Search...',
                          hintStyle: const TextStyle(fontSize: 13),
                          prefixIcon: const Icon(Icons.search, size: 20),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 6,
                          ),
                          isDense: true,
                        ),
                        style: const TextStyle(fontSize: 13),
                        onChanged: (value) {
                          context.read<StudentProvider>().search(value);
                        },
                      ),
                      const SizedBox(height: 8),
                      // Action buttons row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: _showAddStudentDialog,
                              icon: const Icon(Icons.add, size: 16),
                              label: const Text(
                                'Add',
                                style: TextStyle(fontSize: 11),
                              ),
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 8,
                                  horizontal: 8,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: _exportToCSV,
                              icon: const Icon(Icons.download, size: 16),
                              label: const Text(
                                'Export',
                                style: TextStyle(fontSize: 11),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 8,
                                  horizontal: 8,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: _generateTestData,
                              icon: const Icon(Icons.science, size: 16),
                              label: const Text(
                                'Test',
                                style: TextStyle(fontSize: 11),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.orange,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 8,
                                  horizontal: 8,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  );
                }

                // Desktop/Tablet layout (landscape or wide screens)
                return Row(
                  children: [
                    ElevatedButton.icon(
                      onPressed: _showAddStudentDialog,
                      icon: const Icon(Icons.add),
                      label: const Text('Add New Student'),
                    ),
                    const SizedBox(width: 16),
                    ElevatedButton.icon(
                      onPressed: _exportToCSV,
                      icon: const Icon(Icons.download),
                      label: const Text('Export CSV'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 16),
                    ElevatedButton.icon(
                      onPressed: _generateTestData,
                      icon: const Icon(Icons.science),
                      label: const Text('Generate Test Data'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        foregroundColor: Colors.white,
                      ),
                    ),
                    const Spacer(),
                    SizedBox(
                      width: 300,
                      child: TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          hintText: 'Search by name, email, or phone...',
                          prefixIcon: const Icon(Icons.search),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 8,
                          ),
                        ),
                        onChanged: (value) {
                          context.read<StudentProvider>().search(value);
                        },
                      ),
                    ),
                  ],
                );
              },
            ),
          ),

          // Student Table
          Expanded(
            child: Consumer<StudentProvider>(
              builder: (context, provider, child) {
                if (provider.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (provider.students.isEmpty) {
                  return const Center(
                    child: Text(
                      'No students found',
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                  );
                }

                return SingleChildScrollView(
                  controller: _scrollController,
                  scrollDirection: Axis.vertical,
                  child: Column(
                    children: [
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: DataTable(
                          columnSpacing: 40,
                          headingRowColor: WidgetStateProperty.all(
                            Colors.grey[200],
                          ),
                          columns: [
                            DataColumn(label: _buildSortableHeader('ID', 'id')),
                            DataColumn(
                              label: _buildSortableHeader('Name', 'name'),
                            ),
                            DataColumn(
                              label: _buildSortableHeader('Email', 'email'),
                            ),
                            DataColumn(
                              label: _buildSortableHeader('Phone', 'phone'),
                            ),
                          ],
                          rows: provider.students.map((student) {
                            return DataRow(
                              onSelectChanged: (_) =>
                                  _showStudentDetail(student),
                              cells: [
                                DataCell(Text(student.id)),
                                DataCell(Text(student.name)),
                                DataCell(Text(student.email)),
                                DataCell(Text(student.phone)),
                              ],
                            );
                          }).toList(),
                        ),
                      ),
                      if (provider.isLoadingMore)
                        const Padding(
                          padding: EdgeInsets.all(16.0),
                          child: CircularProgressIndicator(),
                        ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
