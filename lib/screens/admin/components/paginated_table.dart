import 'package:flutter/material.dart';

class PaginationWidget extends StatelessWidget {
  final int currentPage;
  final int rowsPerPage;
  final int totalRows;
  final VoidCallback onFirstPage;
  final VoidCallback onPreviousPage;
  final VoidCallback onNextPage;
  final VoidCallback onLastPage;

  const PaginationWidget({
    super.key,
    required this.currentPage,
    required this.rowsPerPage,
    required this.totalRows,
    required this.onFirstPage,
    required this.onPreviousPage,
    required this.onNextPage,
    required this.onLastPage,
  });

  @override
  Widget build(BuildContext context) {
    final totalPages = (totalRows / rowsPerPage).ceil();
    final start = totalRows == 0 ? 0 : (currentPage * rowsPerPage) + 1;
    final end = ((currentPage + 1) * rowsPerPage).clamp(0, totalRows);

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text('$start–$end of $totalRows'),
        IconButton(
          icon: const Icon(Icons.first_page),
          onPressed: currentPage > 0 ? onFirstPage : null,
        ),
        IconButton(
          icon: const Icon(Icons.chevron_left),
          onPressed: currentPage > 0 ? onPreviousPage : null,
        ),
        IconButton(
          icon: const Icon(Icons.chevron_right),
          onPressed: currentPage < totalPages - 1 ? onNextPage : null,
        ),
        IconButton(
          icon: const Icon(Icons.last_page),
          onPressed: currentPage < totalPages - 1 ? onLastPage : null,
        ),
      ],
    );
  }
}

class PaginationController {
  final int rowsPerPage;
  final int totalRows;
  int currentPage;
  final VoidCallback onPageChange;

  PaginationController({
    required this.rowsPerPage,
    required this.totalRows,
    required this.currentPage,
    required this.onPageChange,
  });

  int get totalPages => (totalRows / rowsPerPage).ceil();

  void nextPage() {
    if (currentPage < totalPages - 1) {
      currentPage++;
      onPageChange();
    }
  }

  void previousPage() {
    if (currentPage > 0) {
      currentPage--;
      onPageChange();
    }
  }

  void firstPage() {
    if (currentPage != 0) {
      currentPage = 0;
      onPageChange();
    }
  }

  void lastPage() {
    if (currentPage != totalPages - 1) {
      currentPage = totalPages - 1;
      onPageChange();
    }
  }
}