import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:book_ease/screens/admin/dashboard/dashboard_screen.dart';

// ✅ Define the global secondary color
const Color secondaryColor = Color.fromRGBO(49, 120, 115, 1);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await requestPermissions(); // Request permissions before running the app

  runApp(const MyApp());
}

Future<void> requestPermissions() async {
  // Avoid permission requests on the web
  if (!kIsWeb) {
    // If not running on web
    await Permission.camera.request();
    await Permission.photos.request();
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: secondaryColor,
        textTheme: GoogleFonts.poppinsTextTheme(
          ThemeData.light()
              .textTheme, // ✅ Explicitly merging with default text theme
        ),
      ),
      darkTheme: ThemeData.dark().copyWith(
        textTheme: GoogleFonts.poppinsTextTheme(
          ThemeData.dark()
              .textTheme, // ✅ Merge with dark theme to avoid conflict
        ),
      ),
      // home: LogBookEaseApp(), // To Login Page
      home: AdminDashboard(), // The main admin dashboard
    );
  }
}
