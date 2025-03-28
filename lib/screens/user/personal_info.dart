import 'package:flutter/material.dart';

// Mock backend function (Replace with actual API call)
Future<Map<String, dynamic>> fetchPersonalInfo() async {
  return {
    "id_number": "0345-22-2024",
    "first_name": "Sherlyn",
    "last_name": "Bagaipo",
    "suffix": "", // Optional (can be null or empty)
    "course": "Bachelor of Science in Information System",
    "year_level": "4th Year",
    "email": "shinbagaipo@gmail.com",
    "phone": "09123456789"
  };
}

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
  const PersonalInfoScreen({super.key});

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
          final suffix =
              data["suffix"] ?? ""; // If suffix is null, set empty string

          // ✅ Construct full name properly with optional suffix
          final fullName = suffix.isNotEmpty
              ? "$firstName $lastName, $suffix"
              : "$firstName $lastName";

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                _sectionTitle("Basic Info"),
                _buildInfoTile(
                    Icons.badge, idNumber, "ID Number"), // ✅ Added ID Number
                _buildInfoTile(Icons.person, fullName, "Fullname"),
                _buildInfoTile(Icons.school, data["course"], "Course"),
                _buildInfoTile(Icons.grade, data["year_level"], "Year level"),
                const SizedBox(height: 20),
                _sectionTitle("Contacts"),
                _buildInfoTile(Icons.email, data["email"], "Email"),
                _buildInfoTile(Icons.phone, data["phone"], "Phone number"),
              ],
            ),
          );
        },
      ),
    );
  }

  /// ✅ Extracted reusable section title
  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          fontFamily: 'Poppins',
        ),
      ),
    );
  }

  /// ✅ Reusable info tile widget
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
