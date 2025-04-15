
import 'package:flutter/material.dart';

class TableController<T> {
  late PaginationController paginationController;
  int currentPage = 0;
  int rowsPerPage;
  bool ascending = true;
  int? sortColumnIndex;
  bool isAllSelected = false;
  bool isButtonEnabled = false;

  List<T> dataList;
  List<bool> selectedRows = [];

  TableController({
    required this.dataList,
    this.rowsPerPage = 9,
    required VoidCallback onPageChange,
  }) {
    selectedRows = List.generate(dataList.length, (_) => false);
    paginationController = PaginationController(
      rowsPerPage: rowsPerPage,
      totalRows: dataList.length,
      currentPage: currentPage,
      onPageChange: () {
        currentPage = paginationController.currentPage;
        _checkSelectAllState();
        _checkButtonState();
        onPageChange();
      },
    );
  }

  List<T> get currentPageData {
    int start = currentPage * rowsPerPage;
    int end = (start + rowsPerPage > dataList.length)
        ? dataList.length
        : start + rowsPerPage;
    return dataList.sublist(start, end);
  }

  void sort<K>(Comparable<K> Function(T d) getField, int columnIndex, bool asc,
      VoidCallback setState) {
    dataList.sort((a, b) {
      final aValue = getField(a);
      final bValue = getField(b);
      return asc
          ? Comparable.compare(aValue, bValue)
          : Comparable.compare(bValue, aValue);
    });
    ascending = asc;
    sortColumnIndex = columnIndex;
    paginationController.currentPage = 0;
    currentPage = 0;
    _checkButtonState();
    _checkSelectAllState();
    setState();
  }

  void toggleSelectAll(bool? value, VoidCallback setState) {
    isAllSelected = value ?? false;
    int start = currentPage * rowsPerPage;
    int end = (start + rowsPerPage > dataList.length)
        ? dataList.length
        : start + rowsPerPage;
    for (int i = start; i < end; i++) {
      selectedRows[i] = isAllSelected;
    }
    _checkButtonState();
    setState();
  }

  void toggleRowSelection(bool? value, int index, VoidCallback setState) {
    int actualIndex = currentPage * rowsPerPage + index;
    selectedRows[actualIndex] = value ?? false;
    _checkButtonState();
    _checkSelectAllState();
    setState();
  }

  void _checkButtonState() {
    isButtonEnabled = selectedRows.any((isSelected) => isSelected);
  }

  void _checkSelectAllState() {
    int start = currentPage * rowsPerPage;
    int end = (start + rowsPerPage > dataList.length)
        ? dataList.length
        : start + rowsPerPage;
    isAllSelected =
        selectedRows.sublist(start, end).every((selected) => selected);
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

  void firstPage() {
    currentPage = 0;
    onPageChange();
  }

  void previousPage() {
    if (currentPage > 0) {
      currentPage--;
      onPageChange();
    }
  }

  void nextPage() {
    if ((currentPage + 1) * rowsPerPage < totalRows) {
      currentPage++;
      onPageChange();
    }
  }

  void lastPage() {
    currentPage = (totalRows / rowsPerPage).ceil() - 1;
    onPageChange();
  }
}