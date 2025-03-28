import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'personal_info.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  File? _profileImage; // Stores the selected image file

  // Function to pick image from gallery or camera
  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
      });
      // TODO: Send this image to backend for updating user profile picture
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 360;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "My Profile",
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            color: Colors.white, // ✅ White text color
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
                  top: screenHeight * 0.07,
                  child: Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.teal, // ✅ Teal border color
                            width: 6, // ✅ Border width
                          ),
                        ),
                        child: CircleAvatar(
                          radius: isSmallScreen ? 70 : 80,
                          backgroundColor: Colors.white,
                          backgroundImage: _profileImage != null
                              ? FileImage(_profileImage!) as ImageProvider
                              : const AssetImage('assets/images/lord_p.png'),
                        ),
                      ),
                      Positioned(
                        bottom: 5,
                        right: 10,
                        child: GestureDetector(
                          onTap: _showImageSourceDialog,
                          child: Container(
                            padding: const EdgeInsets.all(5),
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.teal,
                            ),
                            child: const Icon(
                              Icons.camera_alt,
                              color: Colors.white,
                              size: 24, // Adjust size if necessary
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 100), // Ensures spacing for UI
            _buildProfileInfo(),
            const SizedBox(height: 20),
            _buildProfileOptions(context, isSmallScreen),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileInfo() {
    return Column(
      children: [
        const Text(
          'BOSSING',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            fontFamily: 'Poppins',
          ),
        ),
        GestureDetector(
          onTap: () {}, // Implement profile edit functionality
          child: const Text(
            'Edit Profile',
            style: TextStyle(
                color: Colors.teal, fontWeight: FontWeight.bold, fontSize: 14),
          ),
        ),
      ],
    );
  }

  Widget _buildProfileOptions(BuildContext context, bool isSmallScreen) {
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
                  builder: (context) =>
                      const PersonalInfoScreen(), // ✅ Navigates to Dashboard
                ),
              );
            },
          ),
          _buildProfileOption(Icons.book, 'Borrowing Details'),
          _buildProfileOption(Icons.settings, 'Account Settings'),
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
        leading: Icon(icon, color: isLogout ? Colors.red : Colors.teal),
        title: Text(
          title,
          style: const TextStyle(fontFamily: 'Poppins'),
        ),
        trailing:
            isLogout ? null : const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap, // ✅ Only "Personal Information" will use this
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      ),
    );
  }

  void _showImageSourceDialog() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.camera, color: Colors.teal),
                title: const Text("Take a photo"),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.camera);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library, color: Colors.teal),
                title: const Text("Choose from gallery"),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.gallery);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
