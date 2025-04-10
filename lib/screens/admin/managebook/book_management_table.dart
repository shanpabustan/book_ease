import 'package:book_ease/screens/admin/managebook/edit_book.dart';
import 'package:book_ease/screens/admin/managebook/view_book.dart';
import 'package:flutter/material.dart';
import 'book_data.dart'; // Reusable book data source
import 'package:book_ease/modals/delete_modal.dart'; // Import DeactivateAccountModal

class BookManagementApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: BookManagementScreen(),
    );
  }
}

class BookManagementScreen extends StatefulWidget {
  const BookManagementScreen({super.key});

  @override
  State<BookManagementScreen> createState() => _BookManagementScreenState();
}

class _BookManagementScreenState extends State<BookManagementScreen> {
  bool ascending = true;
  int? sortColumnIndex;
  bool isAllSelected = false;
  bool isButtonEnabled = false;

  int currentPage = 0;
  int rowsPerPage = 9; // Set to 9

  List<Map<String, String>> books = List.from(bookList);
  List<bool> selectedRows = [];

  @override
  void initState() {
    super.initState();
    selectedRows = List.generate(books.length, (_) => false);
  }

  List<List<Map<String, String>>> get paginatedBooks {
    List<List<Map<String, String>>> chunks = [];
    for (int i = 0; i < books.length; i += rowsPerPage) {
      chunks.add(books.sublist(
          i, i + rowsPerPage > books.length ? books.length : i + rowsPerPage));
    }
    return chunks;
  }

  void _sort<T>(Comparable<T> Function(Map<String, String> d) getField,
      int columnIndex, bool ascending) {
    books.sort((a, b) {
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
      int end = (start + rowsPerPage > books.length)
          ? books.length
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
    int end = (start + rowsPerPage > books.length)
        ? books.length
        : start + rowsPerPage;
    isAllSelected =
        selectedRows.sublist(start, end).every((selected) => selected);
  }

  void _nextPage() {
    if (currentPage < paginatedBooks.length - 1) {
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
    List<Map<String, String>> currentPageBooks = paginatedBooks[currentPage];
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
                _buildActionButton(Icons.file_copy, 'Excel',
                    Colors.green, // Change icon to Excel
                    enable: isButtonEnabled), // Change label to 'Excel'
                const SizedBox(width: 16),
                _buildActionButton(Icons.delete, 'Delete', Colors.red,
                    onPressed: _showDeleteModal, enable: isButtonEnabled),
                const Spacer(),
              ],
            ),

            const SizedBox(height: 16),

            // DataTable with improvements
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  sortColumnIndex: sortColumnIndex,
                  sortAscending: ascending,
                  headingRowColor: MaterialStateColor.resolveWith(
                    (states) => const Color.fromRGBO(212, 236, 234, 1),
                  ),

                  dataRowColor: MaterialStateColor.resolveWith(
                    (states) => Colors.transparent, // Remove default row color
                  ),
                  dividerThickness:
                      0.5, // Reduce the thickness of the horizontal lines
                  columns: [
                    DataColumn(
                      label: Checkbox(
                        value: isAllSelected,
                        onChanged: _toggleSelectAll,
                      ),
                    ),
                    DataColumn(
                      label: _buildSortableColumnLabel('Book ID'),
                      onSort: (i, asc) =>
                          _sort((d) => int.parse(d['bookId']!), i, asc),
                    ),
                    DataColumn(
                      label: _buildSortableColumnLabel('Title'),
                      onSort: (i, asc) => _sort((d) => d['title']!, i, asc),
                    ),
                    DataColumn(
                      label: _buildSortableColumnLabel('Author'),
                      onSort: (i, asc) => _sort((d) => d['author']!, i, asc),
                    ),
                    DataColumn(
                      label: _buildSortableColumnLabel('Year'),
                      onSort: (i, asc) => _sort((d) => d['year']!, i, asc),
                    ),
                    DataColumn(
                      label: _buildSortableColumnLabel('Category'),
                      onSort: (i, asc) => _sort((d) => d['category']!, i, asc),
                    ),
                    DataColumn(
                      label: _buildSortableColumnLabel('Condition'),
                      onSort: (i, asc) => _sort((d) => d['condition']!, i, asc),
                    ),
                    const DataColumn(
                      label: Text(
                        'Action',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                  rows:
                      List<DataRow>.generate(currentPageBooks.length, (index) {
                    final book = currentPageBooks[index];
                    int actualIndex = currentPage * rowsPerPage + index;

                    // Alternate row background color
                    final isEvenRow = index % 2 == 0;

                    return DataRow(
                      color: MaterialStateProperty.resolveWith<Color?>(
                        (states) => isEvenRow
                            ? Colors.transparent
                            : Colors
                                .grey.shade100, // Light background for odd rows
                      ),
                      cells: [
                        DataCell(Checkbox(
                          value: selectedRows[actualIndex],
                          onChanged: (val) => _toggleRowSelection(val, index),
                        )),
                        DataCell(Text(book['bookId']!)),
                        DataCell(SizedBox(
                          width: 150,
                          child: Text(
                            book['title']!,
                            overflow: TextOverflow.ellipsis,
                            softWrap: false,
                          ),
                        )),
                        DataCell(SizedBox(
                          width: 120,
                          child: Text(
                            book['author']!,
                            overflow: TextOverflow.ellipsis,
                            softWrap: false,
                          ),
                        )),
                        DataCell(Text(book['year']!)),
                        DataCell(Text(book['category']!)),
                        DataCell(_buildStatusChip(book['condition']!)),
                        DataCell(Row(
                          children: [
                            Tooltip(
                              message: 'View Book',
                              child: IconButton(
                                icon: const Icon(Icons.remove_red_eye_outlined,
                                    size: 20),
                                onPressed: () {
                                  // Pass the book data to the ViewBookModal
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return ViewBookModal(book: book);
                                    },
                                  );
                                },
                              ),
                            ),
                            const SizedBox(width: 8),
                            Tooltip(
                              message: 'Edit Book',
                              child: IconButton(
                                icon: const Icon(Icons.edit_outlined, size: 20),
                                onPressed: () {
                                  // Pass the book data to the EditBookModal
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return EditBookModal(book: book);
                                    },
                                  );
                                },
                              ),
                            ),
                            const SizedBox(width: 8),
                            Tooltip(
                              message: 'Delete Book',
                              child: IconButton(
                                icon:
                                    const Icon(Icons.delete_outline, size: 20),
                                onPressed: _showDeleteModal,
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

            // Pagination
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  '${currentPage * rowsPerPage + 1}–${(currentPage * rowsPerPage + paginatedBooks[currentPage].length)} of ${books.length}',
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
                  onPressed: currentPage < paginatedBooks.length - 1
                      ? _nextPage
                      : null,
                ),
                IconButton(
                  icon: const Icon(Icons.last_page),
                  onPressed: currentPage < paginatedBooks.length - 1
                      ? () => setState(() {
                            currentPage = paginatedBooks.length - 1;
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
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4), // Reduce border radius
        ),
      ),
    );
  }

  Widget _buildStatusChip(String status) {
    final color = status == 'New' ? Colors.green : Colors.orange;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(status, style: TextStyle(color: color)),
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
