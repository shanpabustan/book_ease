import 'package:flutter/material.dart';
// ignore: unused_import
import 'package:book_ease/widgets/bottomusernav_widget.dart';

class LibraryScreen extends StatelessWidget {
  const LibraryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: const Text("Library"),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          "Library Screen",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
  //       // Already on Library, do nothing
  //       break;
  //     case 2:
  //       Navigator.pushReplacementNamed(context, '/mybooks');
  //       break;
  //     case 3:
  //       Navigator.pushReplacementNamed(context, '/profile');
  //       break;
  //   }
  // }
}
