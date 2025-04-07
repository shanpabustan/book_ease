import 'package:flutter/material.dart';
import 'book_data.dart'; // Reusable book data source

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
  int rowsPerPage = 10; // ✅ Removed 'final' to allow mutation

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
                _buildActionButton(Icons.picture_as_pdf, 'PDF', Colors.blue),
                const SizedBox(width: 16),
                _buildActionButton(
                    Icons.table_chart, 'Spreadsheet', Colors.green),
                const SizedBox(width: 16),
                _buildActionButton(Icons.delete, 'Delete', Colors.red),
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
                      label: _buildSortableColumnLabel('Book ID'),
                      onSort: (i, asc) => _sort((d) => d['bookId']!, i, asc),
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
                      label: _buildSortableColumnLabel('Copies'),
                      onSort: (i, asc) =>
                          _sort((d) => int.parse(d['copies']!), i, asc),
                    ),
                    DataColumn(
                      label: _buildSortableColumnLabel('Category'),
                      onSort: (i, asc) => _sort((d) => d['category']!, i, asc),
                    ),
                    DataColumn(
                      label: _buildSortableColumnLabel('Condition'),
                      onSort: (i, asc) => _sort((d) => d['condition']!, i, asc),
                    ),
                    const DataColumn(label: Text('Action')),
                  ],
                  rows:
                      List<DataRow>.generate(currentPageBooks.length, (index) {
                    final book = currentPageBooks[index];
                    int actualIndex = currentPage * rowsPerPage + index;
                    return DataRow(cells: [
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
                      DataCell(Text(book['copies']!)),
                      DataCell(Text(book['category']!)),
                      DataCell(_buildStatusChip(book['condition']!)),
                      DataCell(Row(
                        children: const [
                          Icon(Icons.remove_red_eye_outlined, size: 20),
                          SizedBox(width: 8),
                          Icon(Icons.edit_outlined, size: 20),
                          SizedBox(width: 8),
                          Icon(Icons.delete_outline, size: 20),
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
                const Text('Rows per page:'),
                const SizedBox(width: 8),
                DropdownButton<int>(
                  value: rowsPerPage,
                  items: [4, 10, 20, 50]
                      .map((rows) => DropdownMenuItem<int>(
                            value: rows,
                            child: Text('$rows'),
                          ))
                      .toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        currentPage = 0;
                        rowsPerPage = value; // ✅ Now mutable
                      });
                    }
                  },
                ),
                const SizedBox(width: 16),
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

  Widget _buildActionButton(IconData icon, String label, Color color) {
    return OutlinedButton.icon(
      onPressed: isButtonEnabled ? () {} : null,
      icon: Icon(icon, color: color),
      label: Text(label, style: TextStyle(color: color)),
      style: OutlinedButton.styleFrom(
        side: BorderSide(color: isButtonEnabled ? color : Colors.grey),
        backgroundColor: isButtonEnabled ? null : Colors.grey[300],
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
