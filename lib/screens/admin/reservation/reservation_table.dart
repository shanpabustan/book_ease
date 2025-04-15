import 'package:book_ease/screens/admin/components/paginated_table.dart';
import 'package:book_ease/screens/admin/components/action_buttons.dart';
import 'package:book_ease/screens/admin/components/table_controller.dart';
import 'package:book_ease/screens/admin/reservation/reservation_data.dart';
import 'package:book_ease/utils/snackbar_util.dart';
import 'package:book_ease/modals/unblock_data_modal.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:dio/dio.dart';
import 'dart:convert';


class ReservationTable extends StatelessWidget {
  const ReservationTable({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(textTheme: GoogleFonts.poppinsTextTheme()),
      home: const ReservationScreen(),
    );
  }
}

class ReservationScreen extends StatefulWidget {
  const ReservationScreen({super.key});

  @override
  State<ReservationScreen> createState() => _ReservationScreenState();
}

class _ReservationScreenState extends State<ReservationScreen> {
  late TableController<Map<String, String>> controller;
@override
void initState() {
  super.initState();
  fetchReservations();
}

Future<void> fetchReservations() async {
  try {
    final response = await Dio().get('http://127.0.0.1:5566/admin/get-reservations'); // Update with your real API URL
    final List<dynamic> data = response.data;

    final List<Map<String, String>> parsedList = data.map((json) {
      final reservation = Reservation.fromJson(json);
      return {
        'reservationId': reservation.reservationId.toString(),
        'userName': reservation.fullName,
        'bookTitle': reservation.bookTitle,
        'reservationDate': reservation.createdAt.toIso8601String().split('T').first,
        'status': reservation.status,
      };
    }).toList();

    setState(() {
      controller = TableController<Map<String, String>>(
        dataList: parsedList,
        onPageChange: () => setState(() {}),
      );
    });
  } catch (e) {
    print('Error fetching reservations: $e');
  }
}

  void _showUnblockModal() {
    showDialog(
      context: context,
      builder: (context) => UnblockDataModal(
        onCancel: () => Navigator.pop(context),
        onUnblock: () {
          showCustomSnackBar(
            context,
            message: 'User unblocked',
            backgroundColor: Colors.green,
            icon: Icons.check_circle,
          );
        },
      ),
    );
  }

  Widget _buildStatusChip(String status) {
    final color = status == 'Approved'
        ? Colors.green
        : status == 'Pending'
            ? Colors.orange
            : Colors.red;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(status,
          style: TextStyle(color: color, fontWeight: FontWeight.w500)),
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
    return Scaffold(
      backgroundColor: const Color(0xFFF3F6F9),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            ActionButtonRow(
              isButtonEnabled: controller.isButtonEnabled,
              onPdfPressed: () {
                // PDF Logic
              },
              onExcelPressed: () {
                // Excel Logic
              },
            ),
            const SizedBox(height: 20),
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: ConstrainedBox(
                      constraints:
                          BoxConstraints(minWidth: constraints.maxWidth),
                      child: DataTable(
                        sortColumnIndex: controller.sortColumnIndex,
                        sortAscending: controller.ascending,
                        headingRowColor: MaterialStateColor.resolveWith(
                            (_) => const Color(0xFFD4ECEA)),
                        columns: [
                          DataColumn(
                            label: Checkbox(
                              value: controller.isAllSelected,
                              onChanged: (value) => controller.toggleSelectAll(
                                  value, () => setState(() {})),
                            ),
                          ),
                          DataColumn(
                            label: _buildSortableColumnLabel('Reservation ID'),
                            onSort: (i, asc) => controller.sort(
                                (d) => d['reservationId']!,
                                i,
                                asc,
                                () => setState(() {})),
                          ),
                          DataColumn(
                            label: _buildSortableColumnLabel('User Name'),
                            onSort: (i, asc) => controller.sort(
                                (d) => d['userName']!,
                                i,
                                asc,
                                () => setState(() {})),
                          ),
                          DataColumn(
                            label: _buildSortableColumnLabel('Book Title'),
                            onSort: (i, asc) => controller.sort(
                                (d) => d['bookTitle']!,
                                i,
                                asc,
                                () => setState(() {})),
                          ),
                          DataColumn(
                            label:
                                _buildSortableColumnLabel('Reservation Date'),
                            onSort: (i, asc) => controller.sort(
                                (d) => d['reservationDate']!,
                                i,
                                asc,
                                () => setState(() {})),
                          ),
                          DataColumn(
                            label: _buildSortableColumnLabel('Status'),
                            onSort: (i, asc) => controller.sort(
                                (d) => d['status']!,
                                i,
                                asc,
                                () => setState(() {})),
                          ),
                          const DataColumn(
                            label: Text('Action',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                          ),
                        ],
                        rows: List.generate(controller.currentPageData.length,
                            (index) {
                          final reservation = controller.currentPageData[index];
                          final actualIndex =
                              controller.currentPage * controller.rowsPerPage +
                                  index;
                          return DataRow(
                            color: MaterialStateColor.resolveWith(
                              (states) => index.isEven
                                  ? Colors.transparent
                                  : Colors.grey.shade100,
                            ),
                            cells: [
                              DataCell(Checkbox(
                                value: controller.selectedRows[actualIndex],
                                onChanged: (val) =>
                                    controller.toggleRowSelection(
                                        val, index, () => setState(() {})),
                              )),
                              DataCell(Text(reservation['reservationId']!)),
                              DataCell(SizedBox(
                                width: 150,
                                child: Text(reservation['userName']!,
                                    overflow: TextOverflow.ellipsis),
                              )),
                              DataCell(Text(reservation['bookTitle']!)),
                              DataCell(Text(reservation['reservationDate']!)),
                              DataCell(
                                  _buildStatusChip(reservation['status']!)),
                              DataCell(Row(
                                children: [
                                  Tooltip(
                                    message: 'View',
                                    child: IconButton(
                                      icon: const Icon(Icons.remove_red_eye,
                                          size: 20),
                                      onPressed: () {},
                                    ),
                                  ),
                                  Tooltip(
                                    message: 'Unblock',
                                    child: IconButton(
                                      icon:
                                          const Icon(Icons.lock_open, size: 20),
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
                  );
                },
              ),
            ),
            PaginationWidget(
              currentPage: controller.currentPage,
              rowsPerPage: controller.rowsPerPage,
              totalRows: controller.dataList.length,
              onFirstPage: controller.paginationController.firstPage,
              onPreviousPage: controller.paginationController.previousPage,
              onNextPage: controller.paginationController.nextPage,
              onLastPage: controller.paginationController.lastPage,
            ),
          ],
        ),
      ),
    );
  }
}