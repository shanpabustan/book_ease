import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:book_ease/screens/auth/login.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';  // Import provider
import 'package:book_ease/provider/user_data.dart';// Import your UserData provider
import 'package:book_ease/screens/admin/dashboard/dashboard_screen.dart';

const Color secondaryColor = Color.fromRGBO(49, 120, 115, 1);
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await requestPermissions(); // Request permissions before running the app

  runApp(const MyApp());
}

Future<void> requestPermissions() async {
  if (kIsWeb) {
    print("Skipping permission requests on web.");
    return;
  }

  await Permission.camera.request();
  await Permission.photos.request();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

 @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => UserData(),  // Set up the provider for UserData
      child: MaterialApp(
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
        home: AdminDashboard(), //LogBookEaseApp(),  //  // Main screen after login or wherever you direct
      ),
    );
  }
}




