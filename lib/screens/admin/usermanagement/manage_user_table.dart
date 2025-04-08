import 'package:flutter/material.dart';
import 'user_data.dart'; // Reusable user data source
import 'package:book_ease/modals/delete_modal.dart'; // Import DeactivateAccountModal

class UserManagementApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: UserManagementScreen(),
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

  void _showDeleteModal() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return DeleteDataModal(
          onCancel: () => Navigator.pop(context),
          onDelete: () {
            // Perform delete logic here
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Data deleted')),
            );
          },
        );
      },
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
            // Action Buttons
            Row(
              children: [
                _buildActionButton(Icons.picture_as_pdf, 'PDF', Colors.blue,
                    enable: isButtonEnabled),
                const SizedBox(width: 16),
                _buildActionButton(
                    Icons.table_chart, 'Spreadsheet', Colors.green,
                    enable: isButtonEnabled),
                const SizedBox(width: 16),
                _buildActionButton(Icons.delete, 'Delete', Colors.red,
                    onPressed: _showDeleteModal, enable: isButtonEnabled),
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
                      (states) => Colors.grey.shade200),
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
                      label: _buildSortableColumnLabel('Program'),
                      onSort: (i, asc) => _sort((d) => d['program']!, i, asc),
                    ),
                    DataColumn(
                      label: _buildSortableColumnLabel('Year Level'),
                      onSort: (i, asc) => _sort((d) => d['yearLevel']!, i, asc),
                    ),
                    DataColumn(
                      label: _buildSortableColumnLabel('Contact Number'),
                      onSort: (i, asc) =>
                          _sort((d) => d['contactNumber']!, i, asc),
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
                    return DataRow(cells: [
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
                      DataCell(SizedBox(
                        width: 150,
                        child: Text(
                          user['email']!,
                          overflow: TextOverflow.ellipsis,
                          softWrap: false,
                        ),
                      )),
                      DataCell(Text(user['program']!)),
                      DataCell(Text(user['yearLevel']!)),
                      DataCell(Text(user['contactNumber']!)),
                      DataCell(Row(
                        children: [
                          Tooltip(
                            message: 'View User',
                            child: IconButton(
                              icon: const Icon(Icons.remove_red_eye_outlined,
                                  size: 20),
                              onPressed: () {
                                // TODO: Add view logic
                              },
                            ),
                          ),
                          const SizedBox(width: 8),
                          Tooltip(
                            message: 'Edit User',
                            child: IconButton(
                              icon: const Icon(Icons.edit_outlined, size: 20),
                              onPressed: () {
                                // TODO: Add edit logic
                              },
                            ),
                          ),
                          const SizedBox(width: 8),
                          Tooltip(
                            message: 'Delete User',
                            child: IconButton(
                              icon: const Icon(Icons.delete_outline, size: 20),
                              onPressed: _showDeleteModal,
                            ),
                          ),
                        ],
                      )),
                    ]);
                  }),
                ),
              ),
            ),

            // Pagination
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
}
