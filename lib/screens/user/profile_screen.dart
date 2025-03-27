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
      appBar: AppBar(
        title: Text(
          'My Profile',
          style: TextStyle(
            fontSize: isSmallScreen ? 18 : 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.teal,
        elevation: 0,
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
                  top: screenHeight * 0.075,
                  child: CircleAvatar(
                    radius: isSmallScreen ? 70 : 80,
                    backgroundImage:
                        const AssetImage('assets/images/lord_p.png')
                  ),
                ),
              ],
            ),
            SizedBox(height: isSmallScreen ? 80 : 115),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
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
              padding: EdgeInsets.symmetric(
                horizontal: isSmallScreen ? 8.0 : 16.0,
              ),
              child: Column(
                children: [
                  _buildProfileOption(
                      Icons.person, 'Personal Information', isSmallScreen),
                  _buildProfileOption(
                      Icons.book, 'Borrowing Details', isSmallScreen),
                  _buildProfileOption(
                      Icons.settings, 'Account Settings', isSmallScreen),
                  _buildThemeToggle(isSmallScreen),
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
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        leading: Icon(icon, color: isLogout ? Colors.red : Colors.teal),
        title: Text(
          title,
          style: TextStyle(fontSize: isSmallScreen ? 14 : 16),
        ),
        trailing: isLogout
            ? null
            : const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () {},
        contentPadding: EdgeInsets.symmetric(
          horizontal: isSmallScreen ? 12 : 16,
          vertical: 4,
        ),
      ),
    );
  }

  Widget _buildThemeToggle(bool isSmallScreen) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        leading: const Icon(Icons.nightlight_round, color: Colors.teal),
        title: Text('Theme', style: TextStyle(fontSize: isSmallScreen ? 14 : 16)),
        trailing: Switch(
          value: false,
          onChanged: (bool value) {},
        ),
        contentPadding: EdgeInsets.symmetric(
          horizontal: isSmallScreen ? 12 : 16,
          vertical: 4,
        ),
      ),
    );
  }

  // Function to handle navigation
  // ignore: unused_element
  // void _navigateToScreen(BuildContext context, int index) {
  //   switch (index) {
  //     case 0:
  //       Navigator.pushReplacementNamed(context, '/home');
  //       break;
  //     case 1:
  //       Navigator.pushReplacementNamed(context, '/library');
  //       break;
  //     case 2:
  //       Navigator.pushReplacementNamed(context, '/mybooks');
  //       break;
  //     case 3:
  //       // Already on Profile, do nothing
  //       break;
  //   }
  // }
}
