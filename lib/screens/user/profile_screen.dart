import 'package:flutter/material.dart';
// ignore: unused_import
import 'package:book_ease/screens/user/user_nav.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 360;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize:
            const Size.fromHeight(80), // Increases the app bar height
        child: AppBar(
          title: Padding(
            padding: const EdgeInsets.only(top: 30), // Push title downward
            child: Text(
              'My Profile',
              style: TextStyle(
                fontSize: isSmallScreen ? 98 : 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          centerTitle: true,
          backgroundColor: Colors.teal,
          elevation: 0,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.center,
              children: [
                Container(
                  color: Colors.teal,
                  height: screenHeight * 0.15,
                ),
                Positioned(
                  top: screenHeight * 0.07, // Moves image slightly downward
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                          color: Colors.teal, width: 7), // Teal border
                    ),
                    child: CircleAvatar(
                      radius: isSmallScreen ? 70 : 80, // Same radius as before
                      backgroundColor:
                          Colors.white, // Optional: Ensures no overlap issues
                      backgroundImage:
                          const AssetImage('assets/images/lord_p.png'),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: isSmallScreen ? 80 : 110),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'BOSSING',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: isSmallScreen ? 18 : 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: () {},
              child: Text(
                'Edit Profile',
                style: TextStyle(
                  color: Colors.teal,
                  fontSize: isSmallScreen ? 12 : 13,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding:
                  EdgeInsets.symmetric(horizontal: isSmallScreen ? 8.0 : 16.0),
              child: Column(
                children: [
                  _buildProfileOption(
                      Icons.person, 'Personal Information', isSmallScreen),
                  _buildProfileOption(
                      Icons.book, 'Borrowing Details', isSmallScreen),
                  _buildProfileOption(
                      Icons.settings, 'Account Settings', isSmallScreen),
                  _buildProfileOption(Icons.logout, 'Logout', isSmallScreen,
                      isLogout: true),
                ],
              ),
            ),
            SizedBox(height: screenHeight * 0.05),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileOption(IconData icon, String title, bool isSmallScreen,
      {bool isLogout = false}) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: ListTile(
        leading: Icon(icon, color: isLogout ? Colors.red : Colors.teal),
        title: Text(title, style: TextStyle(fontSize: isSmallScreen ? 14 : 16)),
        trailing:
            isLogout ? null : const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () {},
        contentPadding: EdgeInsets.symmetric(
            horizontal: isSmallScreen ? 12 : 16, vertical: 4),
      ),
    );
  }
}
