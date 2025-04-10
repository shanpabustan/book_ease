import 'package:flutter/material.dart';
import '../components/sidebar.dart';
import '../components/adminapp_bar.dart';
import '../calendar/calendar_main.dart';
import '../managebook/manage_books.dart';
import '../reservation/reservation_main.dart';
import '../usermanagement/manage_user.dart';
import '../usermanagement/barrowed_book.dart';
import 'stats_section.dart';
import 'analytics.dart';
import 'most_borrowed.dart';

class DashboardTheme {
  static const Color primaryTextColor = Colors.black87;
  static const Color secondaryTextColor = Colors.grey;
  static const Color cardBackground = Colors.white;
  static const Color pageBackground = Color(0xFFFAF7F0);
}

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  _AdminDashboardState createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool isSidebarExpanded = true;
  int _selectedIndex = 0;

  void toggleSidebar() {
    setState(() => isSidebarExpanded = !isSidebarExpanded);
  }

  void _handleNavigation(int index) {
    setState(() => _selectedIndex = index);
  }

  final List<Widget> _screens = [
    DashboardContent(),
    ManageBook(),
    ManageUser(),
    ReservationMain(),
    CalendarMain(),
    BarrowedBook(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: DashboardTheme.pageBackground,
      body: Row(
        children: [
          if (MediaQuery.of(context).size.width > 800)
            Sidebar(
              isExpanded: isSidebarExpanded,
              onToggle: toggleSidebar,
              selectedIndex: _selectedIndex,
              onItemSelected: _handleNavigation,
            ),
          Expanded(child: _screens[_selectedIndex]),
        ],
      ),
    );
  }
}

class DashboardContent extends StatelessWidget {
  const DashboardContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: DashboardTheme.pageBackground,
      child: Column(
        children: [
          AppBarWidget(scaffoldKey: GlobalKey<ScaffoldState>()),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  StatsSection(), // StatsSection widget from the new file
                  Expanded(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(child: AnalyticsScreen()),
                        MostBorrowedBooks(),
                      ],
                    ),
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