import 'package:book_ease/screens/admin/usermanagement/view_user.dart';
import 'package:flutter/material.dart';
import 'user_data.dart'; // Reusable user data source
import 'package:book_ease/modals/unblock_data_modal.dart'; // Import DeactivateAccountModal
import 'package:google_fonts/google_fonts.dart'; // Import Google Fonts package

class UserManagementApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme:
            GoogleFonts.poppinsTextTheme(), // Apply Poppins font globally
      ),
      home: const UserManagementScreen(),
    );
  }
}

class UserManagementScreen extends StatefulWidget {
  const UserManagementScreen({super.key});

  @override
  State<UserManagementScreen> createState() => _UserManagementScreenState();
}

class _UserManagementScreenState extends State<UserManagementScreen> {
  bool ascending = true;
  int? sortColumnIndex;
  bool isAllSelected = false;
  bool isButtonEnabled = false;

  int currentPage = 0;
  int rowsPerPage = 9; // Set to 9

  List<Map<String, String>> users = List.from(userList); // Adjust user data
  List<bool> selectedRows = [];

  @override
  void initState() {
    super.initState();
    selectedRows = List.generate(users.length, (_) => false);
  }

  // Pagination helper: Divide the users into pages
  List<List<Map<String, String>>> get paginatedUsers {
    List<List<Map<String, String>>> chunks = [];
    for (int i = 0; i < users.length; i += rowsPerPage) {
      chunks.add(users.sublist(
          i, i + rowsPerPage > users.length ? users.length : i + rowsPerPage));
    }
    return chunks;
  }

  // Sorting functionality
  void _sort<T>(Comparable<T> Function(Map<String, String> d) getField,
      int columnIndex, bool ascending) {
    users.sort((a, b) {
      final aValue = getField(a);
      final bValue = getField(b);
      return ascending
          ? Comparable.compare(aValue, bValue)
          : Comparable.compare(bValue, aValue);
    });
    setState(() {
      this.ascending = ascending;
      sortColumnIndex = columnIndex;
    });
  }

  // Toggle select all rows
  void _toggleSelectAll(bool? value) {
    setState(() {
      isAllSelected = value ?? false;
      int start = currentPage * rowsPerPage;
      int end = (start + rowsPerPage > users.length)
          ? users.length
          : start + rowsPerPage;
      for (int i = start; i < end; i++) {
        selectedRows[i] = isAllSelected;
      }
      _checkButtonState();
    });
  }

  // Toggle individual row selection
  void _toggleRowSelection(bool? value, int index) {
    setState(() {
      int actualIndex = currentPage * rowsPerPage + index;
      selectedRows[actualIndex] = value ?? false;
      _checkButtonState();
      _checkSelectAllState();
    });
  }

  // Check if any rows are selected to enable action buttons
  void _checkButtonState() {
    isButtonEnabled = selectedRows.any((isSelected) => isSelected);
  }

  // Check if all rows in the current page are selected
  void _checkSelectAllState() {
    int start = currentPage * rowsPerPage;
    int end = (start + rowsPerPage > users.length)
        ? users.length
        : start + rowsPerPage;
    isAllSelected =
        selectedRows.sublist(start, end).every((selected) => selected);
  }

  // Navigate to the next page
  void _nextPage() {
    if (currentPage < paginatedUsers.length - 1) {
      setState(() {
        currentPage++;
        _checkSelectAllState();
        _checkButtonState();
      });
    }
  }

  // Navigate to the previous page
  void _previousPage() {
    if (currentPage > 0) {
      setState(() {
        currentPage--;
        _checkSelectAllState();
        _checkButtonState();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Map<String, String>> currentPageUsers = paginatedUsers[currentPage];
    return Scaffold(
      backgroundColor: const Color(0xFFF3F6F9),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Action Buttons
            Row(
              children: [
                _buildActionButton(Icons.picture_as_pdf, 'PDF', Colors.blue,
                    enable: isButtonEnabled),
                const SizedBox(width: 16),
                _buildActionButton(Icons.file_copy, 'Excel', Colors.green,
                    enable: isButtonEnabled),
                const Spacer(),
              ],
            ),
            const SizedBox(height: 16),

            // DataTable
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  sortColumnIndex: sortColumnIndex,
                  sortAscending: ascending,
                  headingRowColor: MaterialStateColor.resolveWith(
                    (states) => const Color.fromRGBO(212, 236, 234, 1),
                  ),
                  columns: [
                    DataColumn(
                      label: Checkbox(
                        value: isAllSelected,
                        onChanged: _toggleSelectAll,
                      ),
                    ),
                    DataColumn(
                      label: _buildSortableColumnLabel('User ID'),
                      onSort: (i, asc) => _sort((d) => d['userId']!, i, asc),
                    ),
                    DataColumn(
                      label: _buildSortableColumnLabel('Name'),
                      onSort: (i, asc) => _sort((d) => d['name']!, i, asc),
                    ),
                    DataColumn(
                      label: _buildSortableColumnLabel('Email'),
                      onSort: (i, asc) => _sort((d) => d['email']!, i, asc),
                    ),
                    DataColumn(
                      label: _buildSortableColumnLabel('Course'),
                      onSort: (i, asc) => _sort((d) => d['course']!, i, asc),
                    ),
                    DataColumn(
                      label: _buildSortableColumnLabel('Status'),
                      onSort: (i, asc) => _sort((d) => d['status']!, i, asc),
                    ),
                    const DataColumn(
                      label: Text(
                        'Action',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                  rows:
                      List<DataRow>.generate(currentPageUsers.length, (index) {
                    final user = currentPageUsers[index];
                    int actualIndex = currentPage * rowsPerPage + index;

                    final isEvenRow = index % 2 == 0;

                    return DataRow(
                        color: MaterialStateProperty.resolveWith<Color?>(
                          (states) => isEvenRow
                              ? Colors.transparent
                              : Colors.grey.shade100,
                        ),
                        cells: [
                          DataCell(Checkbox(
                            value: selectedRows[actualIndex],
                            onChanged: (val) => _toggleRowSelection(val, index),
                          )),
                          DataCell(Text(user['userId']!)),
                          DataCell(SizedBox(
                            width: 150,
                            child: Text(
                              user['name']!,
                              overflow: TextOverflow.ellipsis,
                              softWrap: false,
                            ),
                          )),
                          DataCell(Text(user['email']!)),
                          DataCell(Text(user['course']!)),
                          DataCell(_buildStatusChip(user['status']!)),
                          DataCell(Row(
                            children: [
                              Tooltip(
                                message: 'View User',
                                child: IconButton(
                                  icon: const Icon(
                                      Icons.remove_red_eye_outlined,
                                      size: 20),
                                  onPressed: () {
                                    // Pass the book data to the ViewBookModal
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return ViewUserModal(user: user);
                                      },
                                    );
                                  },
                                ),
                              ),
                              const SizedBox(width: 8),
                              Tooltip(
                                message: 'Unblock User', // Changed the message
                                child: IconButton(
                                  icon: const Icon(Icons.lock_open,
                                      size: 20), // Changed to unblock icon
                                  onPressed:
                                      _showUnblockModal, // Changed to unblock modal
                                ),
                              ),
                            ],
                          )),
                        ]);
                  }),
                ),
              ),
            ),

            // Pagination controls
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  '${currentPage * rowsPerPage + 1}–${(currentPage * rowsPerPage + paginatedUsers[currentPage].length)} of ${users.length}',
                ),
                IconButton(
                  icon: const Icon(Icons.first_page),
                  onPressed: currentPage > 0
                      ? () => setState(() {
                            currentPage = 0;
                          })
                      : null,
                ),
                IconButton(
                  icon: const Icon(Icons.chevron_left),
                  onPressed: currentPage > 0 ? _previousPage : null,
                ),
                IconButton(
                  icon: const Icon(Icons.chevron_right),
                  onPressed: currentPage < paginatedUsers.length - 1
                      ? _nextPage
                      : null,
                ),
                IconButton(
                  icon: const Icon(Icons.last_page),
                  onPressed: currentPage < paginatedUsers.length - 1
                      ? () => setState(() {
                            currentPage = paginatedUsers.length - 1;
                          })
                      : null,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Show unblock modal for user account unblocking
  void _showUnblockModal() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return UnblockDataModal(
          onCancel: () => Navigator.pop(context),
          onUnblock: () {
            // Perform unblock logic here
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('User unblocked')),
            );
          },
        );
      },
    );
  }

  // Helper function to create Status Chip
  Widget _buildStatusChip(String status) {
    // Green for 'Active' and Red for 'Blocked'
    final color = status == 'Active' ? Colors.green : Colors.red;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2), // Lightened background for readability
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: color, // Text color matches the status color
        ),
      ),
    );
  }

  // Helper function to create action buttons with icons
  Widget _buildActionButton(IconData icon, String label, Color color,
      {VoidCallback? onPressed, bool enable = true}) {
    return OutlinedButton.icon(
      onPressed: enable ? onPressed : null,
      icon: Icon(icon, color: enable ? color : Colors.grey),
      label: Text(
        label,
        style: TextStyle(color: enable ? color : Colors.grey),
      ),
      style: OutlinedButton.styleFrom(
        side: BorderSide(color: enable ? color : Colors.grey),
        backgroundColor: enable ? null : Colors.grey[300],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4), // Reduce border radius
        ),
      ),
    );
  }

  // Helper function to build sortable column labels
  Widget _buildSortableColumnLabel(String label) {
    return Row(
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        const Icon(Icons.unfold_more, size: 16),
      ],
    );
  }
}
