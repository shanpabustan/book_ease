import 'package:book_ease/screens/admin/components/search_admin.dart';
import 'package:book_ease/widgets/admin_buttons_widget.dart';
import 'package:flutter/material.dart';
import 'package:book_ease/screens/admin/components/adminapp_bar.dart';
import 'package:book_ease/screens/admin/dashboard/dashboard_screen.dart';
import 'package:book_ease/screens/admin/managebook/book_management_table.dart';
import 'package:book_ease/screens/admin/managebook/add_book_form.dart';
import 'package:book_ease/screens/admin/admin_theme.dart';

class ManageBook extends StatefulWidget {
  const ManageBook({super.key});

  @override
  _ManageBookState createState() => _ManageBookState();
}

class _ManageBookState extends State<ManageBook> {
  // Create a global key for scaffold state to open the drawer.
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey, // Associate the scaffoldKey here
      backgroundColor: DashboardTheme.pageBackground,
      body: Column(
        children: [
          // AppBar with scaffold key
          AppBarWidget(scaffoldKey: _scaffoldKey),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(
                  left: 20.0,
                  top: 20.0,
                  right: 20.0), // Padding for left, top, and right
              child: Container(
                color: Colors.white, // Set background color to white
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
                            fontSize: AdminFontSize.subHeading,
                            fontWeight: FontWeight.bold,
                            color: DashboardTheme.primaryTextColor,
                          ),
                        ),
                        Row(
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(right: 16.0),
                              child: SearchAdmin(
                                hintText: 'Search books...',
                              ),
                            ),
                            CustomButton(
                              text: "Add New Book",
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (context) => const AddBookForm(),
                                );
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Expanded(
                      child: BookManagementApp(), // Your Book Management Table
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
