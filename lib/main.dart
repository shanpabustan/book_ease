import 'package:flutter/material.dart';
// import 'package:book_ease/screens/auth/additional_signup.dart';
import 'package:book_ease/screens/auth/login.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme:
            GoogleFonts.poppinsTextTheme(), // ✅ Set default font to Poppins
      ),
      darkTheme: ThemeData.dark().copyWith(
        textTheme: GoogleFonts.poppinsTextTheme(),
      ),
      home: const LogBookEaseApp(), // ✅ Your main screen
    );
  }
}
