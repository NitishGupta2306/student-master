import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:data_table_2/data_table_2.dart';
import '../services/student_provider.dart';
import '../services/student_repository.dart';
import '../services/csv_export_service.dart';
import '../models/student.dart';
import '../widgets/student_detail_dialog.dart';
import '../widgets/student_form_dialog.dart';
import '../utils/test_data_generator.dart';
import 'settings_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Load students on init
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<StudentProvider>().loadStudents();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
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
      body: SafeArea(
        child: Column(
          children: [
            // Search and Action Bar
            Container(
              padding: const EdgeInsets.all(12),
              child: Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      // Mobile layout (portrait)
                      if (constraints.maxWidth < 600) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
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
                                        horizontal: 4,
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
                                        horizontal: 4,
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
                                        horizontal: 4,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            // Search bar with settings button
                            Row(
                              children: [
                                Expanded(
                                  child: TextField(
                                    controller: _searchController,
                                    decoration: InputDecoration(
                                      hintText: 'Search...',
                                      hintStyle: const TextStyle(fontSize: 13),
                                      prefixIcon: const Icon(
                                        Icons.search,
                                        size: 20,
                                      ),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                            vertical: 6,
                                          ),
                                      isDense: true,
                                    ),
                                    style: const TextStyle(fontSize: 13),
                                    onChanged: (value) {
                                      context.read<StudentProvider>().search(
                                        value,
                                      );
                                    },
                                  ),
                                ),
                                const SizedBox(width: 8),
                                IconButton(
                                  icon: const Icon(Icons.settings),
                                  onPressed: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const SettingsScreen(),
                                      ),
                                    );
                                  },
                                  tooltip: 'Settings',
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
                            icon: const Icon(Icons.add, size: 18),
                            label: const Text(
                              'Add',
                              style: TextStyle(fontSize: 12),
                            ),
                          ),
                          const SizedBox(width: 8),
                          ElevatedButton.icon(
                            onPressed: _exportToCSV,
                            icon: const Icon(Icons.download, size: 18),
                            label: const Text(
                              'Export',
                              style: TextStyle(fontSize: 12),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              foregroundColor: Colors.white,
                            ),
                          ),
                          const SizedBox(width: 8),
                          ElevatedButton.icon(
                            onPressed: _generateTestData,
                            icon: const Icon(Icons.science, size: 18),
                            label: const Text(
                              'Test',
                              style: TextStyle(fontSize: 12),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.orange,
                              foregroundColor: Colors.white,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: TextField(
                              controller: _searchController,
                              decoration: InputDecoration(
                                hintText: 'Search...',
                                hintStyle: const TextStyle(fontSize: 13),
                                prefixIcon: const Icon(Icons.search, size: 20),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
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
                          ),
                          const SizedBox(width: 8),
                          IconButton(
                            icon: const Icon(Icons.settings),
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => const SettingsScreen(),
                                ),
                              );
                            },
                            tooltip: 'Settings',
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ),

            // Student Table
            Expanded(
              child: Container(
                color: Colors.grey[50],
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

                    return Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        children: [
                          Expanded(
                            child: Card(
                              elevation: 2,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: NotificationListener<ScrollNotification>(
                                  onNotification: (notification) {
                                    if (notification.metrics.pixels >=
                                        notification.metrics.maxScrollExtent -
                                            200) {
                                      provider.loadMoreStudents();
                                    }
                                    return false;
                                  },
                                  child: DataTable2(
                                    columnSpacing: 40,
                                    headingRowColor: WidgetStateProperty.all(
                                      Colors.grey[200],
                                    ),
                                    horizontalMargin: 12,
                                    minWidth: 600,
                                    columns: [
                                      DataColumn2(
                                        label: _buildSortableHeader(
                                          'Name',
                                          'name',
                                        ),
                                        size: ColumnSize.L,
                                      ),
                                      DataColumn2(
                                        label: _buildSortableHeader(
                                          'Email',
                                          'email',
                                        ),
                                        size: ColumnSize.L,
                                      ),
                                      DataColumn2(
                                        label: _buildSortableHeader(
                                          'Phone',
                                          'phone',
                                        ),
                                        size: ColumnSize.M,
                                      ),
                                    ],
                                    rows: provider.students.map((student) {
                                      return DataRow2(
                                        onTap: () =>
                                            _showStudentDetail(student),
                                        cells: [
                                          DataCell(Text(student.name)),
                                          DataCell(Text(student.email)),
                                          DataCell(Text(student.phone)),
                                        ],
                                      );
                                    }).toList(),
                                  ),
                                ),
                              ),
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
            ),
          ],
        ),
      ),
    );
  }
}
