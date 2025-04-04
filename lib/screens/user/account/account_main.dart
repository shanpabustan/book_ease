import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:io';
import 'package:book_ease/screens/auth/change-password.dart';
import 'package:book_ease/screens/user/account/personal_view.dart';
import 'package:book_ease/data/personal_data.dart';
import 'change_photo.dart'; // Import the ChangeProfilePhotoScreen
import 'package:book_ease/main.dart'; // ✅ Import main.dart to access secondaryColor

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  _AccountScreenState createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  File? _profileImage; // Stores the selected image file

  // Function to load personal information
  Future<Map<String, dynamic>> _loadPersonalInfo() async {
    return await fetchPersonalInfo(); // Fetch data from personal_data.dart
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 360;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "My Account",
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: secondaryColor, // ✅ Replaced Colors.teal
        elevation: 0,
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _loadPersonalInfo(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return const Center(child: Text('No data available'));
          } else {
            final userData = snapshot.data!;

            return SingleChildScrollView(
              child: Column(
                children: [
                  Stack(
                    clipBehavior: Clip.none,
                    alignment: Alignment.center,
                    children: [
                      Container(
                        color: secondaryColor, // ✅ Replaced Colors.teal
                        height: screenHeight * 0.15,
                      ),
                      Positioned(
                        top: screenHeight * 0.07,
                        child: Stack(
                          alignment: Alignment.bottomRight,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color:
                                      secondaryColor, // ✅ Replaced Colors.teal
                                  width: 6,
                                ),
                              ),
                              child: CircleAvatar(
                                radius: isSmallScreen ? 70 : 80,
                                backgroundColor: Colors.white,
                                backgroundImage: _profileImage != null
                                    ? FileImage(_profileImage!) as ImageProvider
                                    : const NetworkImage(
                                        'https://example.com/default-avatar.png'),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 120),
                  _buildProfileInfo(userData),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      // Show ChangeProfilePhotoScreen as an overlay
                      showModalBottomSheet(
                        context: context,
                        builder: (context) {
                          return ChangeProfilePhotoScreen(
                            onImagePicked: (File? image) {
                              setState(() {
                                _profileImage = image;
                              });
                            },
                          );
                        },
                        isScrollControlled:
                            true, // This allows the sheet to have custom height
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: secondaryColor, // ✅ Replaced Colors.teal
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Change Profile Photo'),
                  ),
                  const SizedBox(height: 20),
                  _buildProfileOptions(context, isSmallScreen, userData),
                ],
              ),
            );
          }
        },
      ),
    );
  }

  Widget _buildProfileInfo(Map<String, dynamic> userData) {
    return Column(
      children: [
        Text(
          '${userData["first_name"]} ${userData["last_name"]}',
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            fontFamily: 'Poppins',
          ),
        ),
      ],
    );
  }

  Widget _buildProfileOptions(
      BuildContext context, bool isSmallScreen, Map<String, dynamic> userData) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: isSmallScreen ? 8.0 : 16.0),
      child: Column(
        children: [
          _buildProfileOption(
            Icons.person,
            'Personal Information',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PersonalInfoScreen(data: userData),
                ),
              );
            },
          ),
          _buildProfileOption(Icons.book, 'Borrowing Details'),
          _buildProfileOption(
            Icons.lock,
            'Change Password',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const CreatePasswordScreen(),
                ),
              );
            },
          ),
          _buildProfileOption(Icons.logout, 'Logout', isLogout: true),
        ],
      ),
    );
  }

  Widget _buildProfileOption(IconData icon, String title,
      {bool isLogout = false, VoidCallback? onTap}) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: ListTile(
        leading: Icon(icon,
            color: isLogout
                ? Colors.red
                : secondaryColor), // ✅ Replaced Colors.teal
        title: Text(
          title,
          style: const TextStyle(fontFamily: 'Poppins'),
        ),
        trailing:
            isLogout ? null : const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      ),
    );
  }
}
