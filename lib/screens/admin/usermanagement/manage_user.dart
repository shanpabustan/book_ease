import 'package:flutter/material.dart';
import 'package:book_ease/screens/admin/components/search_admin.dart';
// ignore: unused_import
import 'package:book_ease/widgets/admin_buttons_widget.dart';
import 'package:book_ease/screens/admin/components/adminapp_bar.dart';
import 'package:book_ease/screens/admin/dashboard/dashboard_screen.dart';
import 'package:book_ease/screens/admin/admin_theme.dart';
import 'package:book_ease/screens/admin/usermanagement/manage_user_table.dart';

class ManageUser extends StatefulWidget {
  const ManageUser({super.key});

  @override
  _ManageUserState createState() => _ManageUserState();
}

class _ManageUserState extends State<ManageUser> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: DashboardTheme.pageBackground,
      body: Column(
        children: [
          AppBarWidget(scaffoldKey: _scaffoldKey),
          Expanded(
            child: Padding(
              padding:
                  const EdgeInsets.only(left: 20.0, top: 20.0, right: 20.0),
              child: Container(
                color: Colors.white,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title and Search
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "User List",
                          style: TextStyle(
                            fontSize: AdminFontSize.subHeading,
                            fontWeight: FontWeight.bold,
                            color: DashboardTheme.primaryTextColor,
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.only(right: 16.0),
                          child: SearchAdmin(hintText: 'Search users...'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Replace this with User Table later
                    Expanded(
                      child: UserManagementApp(), // TEMPORARY TABLE FOR NOW
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
