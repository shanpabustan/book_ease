import 'package:flutter/material.dart';
import 'personal_edit.dart'; // Import the edit screen
import 'package:book_ease/data/personal_data.dart';

// Uncomment this when the backend API is ready
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// Future<Map<String, dynamic>> fetchPersonalInfo() async {
//   final response = await http.get(Uri.parse('https://yourapi.com/user-info'));

//   if (response.statusCode == 200) {
//     return json.decode(response.body);
//   } else {
//     throw Exception("Failed to load data");
//   }
// }

class PersonalInfoScreen extends StatelessWidget {
  const PersonalInfoScreen({super.key, required Map<String, dynamic> data});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Personal Information",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontFamily: 'Poppins',
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.teal,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: fetchPersonalInfo(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text("Error loading data"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No data available"));
          }

          final data = snapshot.data!;
          final idNumber = data["id_number"];
          final firstName = data["first_name"];
          final lastName = data["last_name"];
          final suffix = data["suffix"] ?? "";
          final course = data["course"];
          final yearLevel = data["year_level"];

          // Construct full name properly with optional suffix
          final fullName = suffix.isNotEmpty
              ? "$firstName $lastName, $suffix"
              : "$firstName $lastName";

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),

                // Basic Info Section with Edit Button on the Right
                _sectionTitle(
                  "Basic Info",
                  onEditPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            PersonalInfoEditScreen(data: data),
                      ),
                    );
                  },
                ),

                _buildInfoTile(Icons.badge, idNumber, "ID Number"),
                _buildInfoTile(Icons.person, fullName, "Full Name"),
                _buildInfoTile(Icons.school, course, "Course"),
                _buildInfoTile(Icons.grade, yearLevel, "Year Level"),

                const SizedBox(height: 20),

                // Contacts Section
                _sectionTitle("Contacts"),
                _buildInfoTile(Icons.email, data["email"], "Email"),
                _buildInfoTile(Icons.phone, data["phone"], "Phone Number"),
              ],
            ),
          );
        },
      ),
    );
  }

  /// Creates a section title with an optional Edit button aligned to the right.
  Widget _sectionTitle(String title, {VoidCallback? onEditPressed}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            fontFamily: 'Poppins',
          ),
        ),
        if (onEditPressed != null)
          TextButton.icon(
            onPressed: onEditPressed,
            icon: const Icon(Icons.edit, size: 18, color: Colors.teal),
            label: const Text(
              "Edit",
              style: TextStyle(color: Colors.teal, fontFamily: 'Poppins'),
            ),
          ),
      ],
    );
  }

  /// Creates a ListTile for displaying user information
  Widget _buildInfoTile(IconData icon, String title, String subtitle) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: ListTile(
        leading: Icon(icon, color: Colors.teal),
        title: Text(
          title,
          style: const TextStyle(
              fontWeight: FontWeight.bold, fontFamily: 'Poppins'),
        ),
        subtitle: Text(subtitle, style: const TextStyle(fontFamily: 'Poppins')),
      ),
    );
  }
}
