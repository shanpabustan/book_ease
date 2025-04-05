import 'package:flutter/material.dart';
import '../components/sidebar.dart';
import '../components/adminapp_bar.dart';
import 'analytics.dart'; // Import the new file
import 'most_borrowed.dart'; // Import the separated MostBorrowedBooks component

// 🎨 Global Color Theme for Reusability
class DashboardTheme {
  static const Color primaryTextColor = Colors.black87;
  static const Color secondaryTextColor = Colors.grey;
  static const Color cardBackground = Colors.white;
  static const Color pageBackground = Color(0xFFFAF7F0);
}

class AdminDashboard extends StatefulWidget {
  @override
  _AdminDashboardState createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool isSidebarExpanded = true;

  void toggleSidebar() {
    setState(() {
      isSidebarExpanded = !isSidebarExpanded;
    });
  }

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
            ),
          Expanded(
            child: Container(
              color: DashboardTheme.pageBackground,
              child: Column(
                children: [
                  AppBarWidget(scaffoldKey: _scaffoldKey),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          StatsSection(),
                          Expanded(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(child: AnalyticsScreen()),
                                MostBorrowedBooks(), // Now imported from most_borrowed.dart
                              ],
                            ),
                          ),
                        ],
                      ),
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

class StatsSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: StatCard(
              title: 'Registered Users',
              value: '1030',
              icon: Icons.person,
              borderColor: Colors.blueAccent,
              iconBgColor: Colors.blue[200]!,
            ),
          ),
          SizedBox(width: 10),
          Expanded(
            child: StatCard(
              title: 'Borrowed Books',
              value: '3054',
              icon: Icons.book,
              borderColor: Colors.greenAccent,
              iconBgColor: Colors.green[200]!,
            ),
          ),
          SizedBox(width: 10),
          Expanded(
            child: StatCard(
              title: 'Reservations',
              value: '2051',
              icon: Icons.event,
              borderColor: Colors.orangeAccent,
              iconBgColor: Colors.orange[200]!,
            ),
          ),
          SizedBox(width: 10),
          Expanded(
            child: StatCard(
              title: 'Overdue Books',
              value: '20',
              icon: Icons.warning,
              borderColor: Colors.redAccent,
              iconBgColor: Colors.red[200]!,
            ),
          ),
        ],
      ),
    );
  }
}

// 🏆 Improved StatCard with Left-Aligned Icon & Right-Aligned Text
class StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color borderColor;
  final Color iconBgColor;

  StatCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.borderColor,
    required this.iconBgColor,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        decoration: BoxDecoration(
          color: DashboardTheme.cardBackground,
          borderRadius: BorderRadius.circular(10),
          border: Border(
            left: BorderSide(color: borderColor, width: 5), // Left border
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Circular Icon on the Left
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: iconBgColor,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 24, color: Colors.white),
            ),
            SizedBox(width: 15), // Space between icon and text

            // Text on the Right
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: DashboardTheme.primaryTextColor,
                  ),
                ),
                Text(
                  title,
                  style: TextStyle(
                    color: DashboardTheme.secondaryTextColor,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
