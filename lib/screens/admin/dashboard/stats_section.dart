// stats_section.dart
import 'package:flutter/material.dart';
import 'package:book_ease/screens/admin/dashboard/dashboard_screen.dart'; // Adjust this import based on your file structure
import 'package:dio/dio.dart';




class StatsSection extends StatefulWidget {
  @override
  _StatsSectionState createState() => _StatsSectionState();
}

class _StatsSectionState extends State<StatsSection> {
  int studentCount = 0;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadStudentCount();
  }

  Future<void> loadStudentCount() async {
    int count = await fetchStudentCount();
    setState(() {
      studentCount = count;
      isLoading = false;
    });
  }

  Future<int> fetchStudentCount() async {
    try {
      final response = await Dio().get('http://127.0.0.1:5566/admin/count');
      if (response.statusCode == 200 && response.data['retCode'] == "200") {
        return response.data['data']; // Assumes response.data['data'] is an int
      } else {
        throw Exception('Failed to fetch student count');
      }
    } catch (e) {
      print('Error fetching student count: $e');
      return 0;
    }
  }

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
              value: isLoading ? '...' : studentCount.toString(),
              icon: Icons.person,
              borderColor: Colors.blueAccent,
              iconBgColor: Colors.blue[200]!,
            ),
          ),
          SizedBox(width: 10),
          Expanded(
            child: StatCard(
              title: 'Borrowed Books',
              value: 'Pishan', // Placeholder
              icon: Icons.book,
              borderColor: Colors.greenAccent,
              iconBgColor: Colors.green[200]!,
            ),
          ),
          SizedBox(width: 10),
          Expanded(
            child: StatCard(
              title: 'Reservations',
              value: 'Nemeeen', // Placeholder
              icon: Icons.event,
              borderColor: Colors.orangeAccent,
              iconBgColor: Colors.orange[200]!,
            ),
          ),
          SizedBox(width: 10),
          Expanded(
            child: StatCard(
              title: 'Overdue Books',
              value: 'Pishan', // Placeholder
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
            left: BorderSide(color: borderColor, width: 5),
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
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: iconBgColor,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 24, color: Colors.white),
            ),
            SizedBox(width: 15),
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