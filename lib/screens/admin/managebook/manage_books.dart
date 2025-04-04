import 'package:book_ease/screens/admin/components/search_admin.dart';
import 'package:flutter/material.dart';
import 'package:book_ease/screens/admin/components/adminapp_bar.dart';
import 'package:book_ease/screens/admin/dashboard/dashboard_screen.dart';
import 'package:book_ease/screens/admin/managebook/book_management_table.dart';
import 'package:book_ease/screens/admin/managebook/add_book_form.dart'; // Import AddBookForm

class ManageBook extends StatelessWidget {
  const ManageBook({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DashboardTheme.pageBackground,
      body: Column(
        children: [
          AppBarWidget(scaffoldKey: GlobalKey<ScaffoldState>()),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title and Search & Add Book Section
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Book List",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: DashboardTheme.primaryTextColor,
                        ),
                      ),
                      Row(
                        children: [
                          // Reusable Search Field
                          const Padding(
                            padding: EdgeInsets.only(right: 16.0),
                            child: SearchAdmin(
                              hintText: 'Search books...',
                            ),
                          ),
                          // Add Book Button Navigates to AddBookForm
                          ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const AddBookForm(),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 20, // Increased vertical padding
                              ),
                              backgroundColor:
                                  Colors.blueGrey[700], // Button color
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Text(
                              "Add New Book",
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.white, // White text color
                              ),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  // Book Management Table
                  Expanded(
                    child: BookManagementTable(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
