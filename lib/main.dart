import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:book_ease/screens/auth/login.dart';
import 'package:google_fonts/google_fonts.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await requestPermissions(); // Request permissions before running the app

  runApp(const MyApp());
}

Future<void> requestPermissions() async {
  await Permission.camera.request();
  await Permission.photos.request();
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
