import 'package:book_ease/screens/admin/managebook/edit_book.dart';
import 'package:book_ease/screens/admin/managebook/view_book.dart';
import 'package:flutter/material.dart';
import 'book_data.dart'; // Reusable book data source
import 'package:book_ease/modals/delete_modal.dart'; // Import Delete Modal


class BookManagementApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: const TextTheme(
          bodyMedium: TextStyle(color: Colors.black),
        ),
      ),
      home: const BookManagementScreen(),
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
  int rowsPerPage = 8;

 late Future<List<Map<String, String>>> futureBooks;
 List<Map<String, String>> books = []; // <--- Store resolved data here

  List<bool> selectedRows = [];


@override
void initState() {
  super.initState();
  futureBooks = fetchBookList();
  futureBooks.then((data) {
    setState(() {
      books = data;
      selectedRows = List.filled(books.length, false); // initialize selection states
    });
  });
}


  List<List<Map<String, String>>> get paginatedBooks {
  List<List<Map<String, String>>> chunks = [];
  for (int i = 0; i < books.length; i += rowsPerPage) {
    chunks.add(books.sublist(
      i, i + rowsPerPage > books.length ? books.length : i + rowsPerPage
    ));
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
  return FutureBuilder<List<Map<String, String>>>(
    future: futureBooks,
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        Future.delayed(const Duration(seconds: 4), () {
          setState(() {});
        });
        return const Center(child: CircularProgressIndicator());
      } else if (snapshot.hasError) {
        return Center(child: Text('Error: ${snapshot.error}'));
      } else {
        // Assign snapshot data to books and sync selection list
        List<Map<String, String>> books = snapshot.data!;
        selectedRows = List<bool>.filled(books.length, false);

        // Calculate pagination chunks
        List<List<Map<String, String>>> paginatedBooks = [];
        for (int i = 0; i < books.length; i += rowsPerPage) {
          paginatedBooks.add(books.sublist(
              i, i + rowsPerPage > books.length ? books.length : i + rowsPerPage));
        }

        List<Map<String, String>> currentPageBooks = paginatedBooks[currentPage];

        return Scaffold(
          backgroundColor: const Color(0xFFF3F6F9),
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _buildActionButtons(),
                const SizedBox(height: 16),
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
      (states) => const Color(0xFFD4ECEA)),
  columns: _buildTableColumns(),
  rows: List.generate(currentPageBooks.length, (index) {
    final book = currentPageBooks[index];
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
        DataCell(Text(book['bookId'] ?? 'N/A',
            style: const TextStyle(color: Colors.black))),
        DataCell(Text(book['title'] ?? '',
            style: const TextStyle(color: Colors.black))),
        DataCell(Text(book['author'] ?? '',
            style: const TextStyle(color: Colors.black))),
        DataCell(Text(book['year'] ?? '',
            style: const TextStyle(color: Colors.black))),
        DataCell(Text(book['category'] ?? '',
            style: const TextStyle(color: Colors.black))),
        DataCell(_buildStatusChip(book['condition'] ?? '')),
        DataCell(_buildActionIcons(book)),
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      '${currentPage * rowsPerPage + 1}–${(currentPage * rowsPerPage + currentPageBooks.length)} of ${books.length}',
                      style: const TextStyle(color: Colors.black),
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
                      onPressed: currentPage < paginatedBooks.length - 1
                          ? _nextPage
                          : null,
                    ),
                    IconButton(
                      icon: const Icon(Icons.last_page),
                      onPressed: currentPage < paginatedBooks.length - 1
                          ? () => setState(() => currentPage = paginatedBooks.length - 1)
                          : null,
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      }
    },
  );
}


  Widget _buildActionButtons() {
    return Row(
      children: [
        _buildActionButton(Icons.picture_as_pdf, 'PDF', Colors.blue, () {}),
        const SizedBox(width: 16),
        _buildActionButton(Icons.file_copy, 'Excel', Colors.green, () {}),
        const SizedBox(width: 16),
        _buildActionButton(Icons.delete, 'Delete', Colors.red, () {}),
        const Spacer(),
      ],
    );
  }

  List<DataColumn> _buildTableColumns() {
    return [
      DataColumn(
        label: Checkbox(
          value: isAllSelected,
          onChanged: _toggleSelectAll,
        ),
      ),
      DataColumn(
        label: _buildSortableColumnLabel('Book ID'),
        onSort: (i, asc) =>
            _sort((d) => int.tryParse(d['bookId'] ?? '0') ?? 0, i, asc),
      ),
      DataColumn(
        label: _buildSortableColumnLabel('Title'),
        onSort: (i, asc) => _sort((d) => d['title'] ?? '', i, asc),
      ),
      DataColumn(
        label: _buildSortableColumnLabel('Author'),
        onSort: (i, asc) => _sort((d) => d['author'] ?? '', i, asc),
      ),
      DataColumn(
        label: _buildSortableColumnLabel('Year'),
        onSort: (i, asc) => _sort((d) => d['year'] ?? '', i, asc),
      ),
      DataColumn(
        label: _buildSortableColumnLabel('Category'),
        onSort: (i, asc) => _sort((d) => d['category'] ?? '', i, asc),
      ),
      DataColumn(
        label: _buildSortableColumnLabel('Condition'),
        onSort: (i, asc) => _sort((d) => d['condition'] ?? '', i, asc),
      ),
      const DataColumn(
  label: Text(
    'Action',
    style: TextStyle(
      fontWeight: FontWeight.bold,
      color: Colors.black, // 👈 Force black text
    ),
  ),
),
    ];
  }

Widget _buildActionIcons(Map<String, String> book) {
  return Row(
    children: [
      Tooltip(
        message: 'View Book',
        child: IconButton(
          icon: const Icon(Icons.remove_red_eye_outlined, size: 20, color: Colors.black),
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) => ViewBookModal(book: book),
            );
          },
        ),
      ),
      const SizedBox(width: 8),
      Tooltip(
        message: 'Edit Book',
        child: IconButton(
          icon: const Icon(Icons.edit_outlined, size: 20, color: Colors.black),
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) => EditBookForm(book: book),
            );
          },
        ),
      ),
      const SizedBox(width: 8),
      Tooltip(
        message: 'Delete Book',
        child: IconButton(
          icon: const Icon(Icons.delete_outline, size: 20, color: Colors.black),
          onPressed: _showDeleteModal,
        ),
      ),
    ],
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
  return Text(
    label,
    style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
  );
}

  Widget _buildStatusChip(String status) {
    final color = status == 'New'
        ? Colors.green
        : const Color.fromARGB(255, 244, 168, 54);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(status, style: TextStyle(color: color)),
    );
  }
}