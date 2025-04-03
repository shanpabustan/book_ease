import 'package:flutter/material.dart';
import 'dashboard_screen.dart'; // Import the theme from the existing file

class MostBorrowedBooks extends StatelessWidget {
  final List<String> books = [
    'Intermediate Accounting',
    'JAVA Programming',
    'The Business of Tourism',
    'Python Programming',
    'Artificial Intelligence Basics',
    'Data Structures & Algorithms',
    'Marketing Strategies',
    'Modern Web Development',
    'Database Management Systems',
    'Cybersecurity Fundamentals',
  ];

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      color: DashboardTheme.cardBackground,
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Most Borrowed Books',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: DashboardTheme.primaryTextColor,
              ),
            ),
            SizedBox(height: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: books
                  .asMap()
                  .entries
                  .map((entry) => Padding(
                        padding: EdgeInsets.symmetric(vertical: 5),
                        child: Text(
                          '${entry.key + 1}. ${entry.value}', // Auto-numbering
                          style: TextStyle(
                            fontSize: 16,
                            color: DashboardTheme.secondaryTextColor,
                          ),
                        ),
                      ))
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}
