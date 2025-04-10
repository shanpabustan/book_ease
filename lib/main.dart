import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:book_ease/screens/admin/dashboard/dashboard_screen.dart';

// ✅ Define the global secondary color
const Color secondaryColor = Color.fromRGBO(49, 120, 115, 1);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await requestPermissions(); // ✅ Request permissions before running the app
  runApp(const MyApp());
}

// ✅ Request relevant permissions based on platform
Future<void> requestPermissions() async {
  if (!kIsWeb &&
      (defaultTargetPlatform == TargetPlatform.android ||
          defaultTargetPlatform == TargetPlatform.iOS)) {
    // ✅ Android 13+ requires separate media permissions
    if (await Permission.photos.isDenied ||
        await Permission.photos.isPermanentlyDenied) {
      await Permission.photos.request();
    }
    if (await Permission.camera.isDenied ||
        await Permission.camera.isPermanentlyDenied) {
      await Permission.camera.request();
    }

    // ✅ Optionally include storage permission for older Android versions
    if (await Permission.storage.isDenied ||
        await Permission.storage.isPermanentlyDenied) {
      await Permission.storage.request();
    }
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
          ThemeData.light().textTheme,
        ),
      ),
      home: AdminDashboard(), // ✅ Set your initial screen here
    );
  }
}
