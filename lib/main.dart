import 'package:flutter/material.dart';
// import 'package:book_ease/screens/auth/additional_signup.dart';
import 'package:book_ease/screens/auth/login.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BookEase',
      theme: ThemeData(
        primarySwatch: Colors.teal,
        textTheme: GoogleFonts.poppinsTextTheme(), // Apply Poppins globally
      ),
      home: const LogBookEaseApp(),
    );
  }
}
