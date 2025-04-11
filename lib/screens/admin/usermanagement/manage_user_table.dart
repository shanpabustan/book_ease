import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:book_ease/screens/admin/usermanagement/view_user.dart';
import 'package:book_ease/utils/snackbar_util.dart';
import 'package:book_ease/modals/unblock_data_modal.dart';
import 'user_data.dart';

class UserManagementApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: GoogleFonts.poppinsTextTheme(),
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
  int rowsPerPage = 8;

  List<Map<String, String>> users = List.from(userList);
  List<bool> selectedRows = [];

  @override
  void initState() {
    super.initState();
    selectedRows = List.generate(users.length, (_) => false);
  }

  List<List<Map<String, String>>> get paginatedUsers {
    List<List<Map<String, String>>> chunks = [];
    for (int i = 0; i < users.length; i += rowsPerPage) {
      chunks.add(users.sublist(
          i, i + rowsPerPage > users.length ? users.length : i + rowsPerPage));
    }
    return chunks;
  }

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

  void _toggleRowSelection(bool? value, int index) {
    setState(() {
      int actualIndex = currentPage * rowsPerPage + index;
      selectedRows[actualIndex] = value ?? false;
      _checkButtonState();
      _checkSelectAllState();
    });
  }

  void _checkButtonState() {
    isButtonEnabled = selectedRows.any((isSelected) => isSelected);
  }

  void _checkSelectAllState() {
    int start = currentPage * rowsPerPage;
    int end = (start + rowsPerPage > users.length)
        ? users.length
        : start + rowsPerPage;
    isAllSelected =
        selectedRows.sublist(start, end).every((selected) => selected);
  }

  void _nextPage() {
    if (currentPage < paginatedUsers.length - 1) {
      setState(() {
        currentPage++;
        _checkSelectAllState();
        _checkButtonState();
      });
    }
  }

  void _previousPage() {
    if (currentPage > 0) {
      setState(() {
        currentPage--;
        _checkSelectAllState();
        _checkButtonState();
      });
    }
  }

  void _showUnblockModal() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return UnblockDataModal(
          onCancel: () => Navigator.pop(context),
          onUnblock: () {
            showCustomSnackBar(
              context,
              message: 'User unblocked',
              backgroundColor: Colors.green,
              icon: Icons.check_circle,
            );
          },
        );
      },
    );
  }

  Widget _buildStatusChip(String status) {
    final color = status == 'Active' ? Colors.green : Colors.red;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(status, style: TextStyle(color: color)),
    );
  }

  Widget _buildActionButton(
      IconData icon, String label, Color color, VoidCallback? onPressed) {
    return OutlinedButton.icon(
      onPressed: isButtonEnabled ? onPressed : null,
      icon: Icon(icon, color: isButtonEnabled ? color : Colors.grey),
      label: Text(
        label,
        style: TextStyle(color: isButtonEnabled ? color : Colors.grey),
      ),
      style: OutlinedButton.styleFrom(
        side: BorderSide(color: isButtonEnabled ? color : Colors.grey),
        backgroundColor: isButtonEnabled ? null : Colors.grey[300],
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      ),
    );
  }

  Widget _buildSortableColumnLabel(String label) {
    return Row(
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        const Icon(Icons.unfold_more, size: 16),
      ],
    );
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
            // Header Actions
            Row(
              children: [
                _buildActionButton(
                    Icons.picture_as_pdf, 'PDF', Colors.blue, () {}),
                const SizedBox(width: 16),
                _buildActionButton(
                    Icons.file_copy, 'Excel', Colors.green, () {}),
                const Spacer(),
              ],
            ),
            const SizedBox(height: 16),

            // DataTable with full-width and horizontal scroll
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return ConstrainedBox(
                    constraints: BoxConstraints(minWidth: constraints.maxWidth),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: ConstrainedBox(
                        constraints:
                            BoxConstraints(minWidth: constraints.maxWidth),
                        child: DataTable(
                          sortColumnIndex: sortColumnIndex,
                          sortAscending: ascending,
                          headingRowColor: MaterialStateColor.resolveWith(
                            (states) => const Color(0xFFD4ECEA),
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
                              onSort: (i, asc) =>
                                  _sort((d) => d['userId']!, i, asc),
                            ),
                            DataColumn(
                              label: _buildSortableColumnLabel('Name'),
                              onSort: (i, asc) =>
                                  _sort((d) => d['name']!, i, asc),
                            ),
                            DataColumn(
                              label: _buildSortableColumnLabel('Email'),
                              onSort: (i, asc) =>
                                  _sort((d) => d['email']!, i, asc),
                            ),
                            DataColumn(
                              label: _buildSortableColumnLabel('Course'),
                              onSort: (i, asc) =>
                                  _sort((d) => d['course']!, i, asc),
                            ),
                            DataColumn(
                              label: _buildSortableColumnLabel('Status'),
                              onSort: (i, asc) =>
                                  _sort((d) => d['status']!, i, asc),
                            ),
                            const DataColumn(
                              label: Text('Action',
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                            ),
                          ],
                          rows: List.generate(currentPageUsers.length, (index) {
                            final user = currentPageUsers[index];
                            final actualIndex =
                                currentPage * rowsPerPage + index;
                            return DataRow(
                              color: MaterialStateColor.resolveWith((states) =>
                                  index.isEven
                                      ? Colors.transparent
                                      : Colors.grey.shade100),
                              cells: [
                                DataCell(Checkbox(
                                  value: selectedRows[actualIndex],
                                  onChanged: (val) =>
                                      _toggleRowSelection(val, index),
                                )),
                                DataCell(Text(user['userId']!)),
                                DataCell(SizedBox(
                                  width: 150,
                                  child: Text(user['name']!,
                                      overflow: TextOverflow.ellipsis),
                                )),
                                DataCell(Text(user['email']!)),
                                DataCell(Text(user['course']!)),
                                DataCell(_buildStatusChip(user['status']!)),
                                DataCell(Row(
                                  children: [
                                    Tooltip(
                                      message: 'View User',
                                      child: IconButton(
                                        icon: const Icon(Icons.remove_red_eye,
                                            size: 20),
                                        onPressed: () => showDialog(
                                          context: context,
                                          builder: (context) =>
                                              ViewUserModal(user: user),
                                        ),
                                      ),
                                    ),
                                    Tooltip(
                                      message: 'Unblock User',
                                      child: IconButton(
                                        icon: const Icon(Icons.lock_open,
                                            size: 20),
                                        onPressed: _showUnblockModal,
                                      ),
                                    ),
                                  ],
                                )),
                              ],
                            );
                          }),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            // Pagination Controls
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  '${currentPage * rowsPerPage + 1}–${(currentPage * rowsPerPage + paginatedUsers[currentPage].length)} of ${users.length}',
                ),
                IconButton(
                  icon: const Icon(Icons.first_page),
                  onPressed: currentPage > 0
                      ? () => setState(() => currentPage = 0)
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
                      ? () => setState(
                          () => currentPage = paginatedUsers.length - 1)
                      : null,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
