import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../user/user_dashboard.dart';
import 'signup.dart'; // ✅ Import the SignUp Screen
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const LogBookEaseApp());
}

class LogBookEaseApp extends StatelessWidget {
  const LogBookEaseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const LoginScreen(),
    );
  }
}

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: LayoutBuilder(
          builder: (context, constraints) {
            bool isWideScreen = constraints.maxWidth > 1000;

            return SizedBox(
              height: MediaQuery.of(context).size.height,
              width: double.infinity,
              child: isWideScreen
                  ? Row(
                      children: [
                        // 📌 Left Side: Logo with Full Teal Background
                        Expanded(
                          flex: 1,
                          child: Container(
                            width: double.infinity,
                            height: double.infinity,
                            color: Colors.teal,
                            alignment: Alignment.center,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Image.asset(
                                  'assets/images/admin_logo.png',
                                  width:
                                      constraints.maxWidth > 1200 ? 400 : 350,
                                  height:
                                      constraints.maxWidth > 1200 ? 400 : 350,
                                  fit: BoxFit.contain,
                                ),
                                Transform.translate(
                                  offset: const Offset(0,
                                      -95), // Moves text **UPWARD** by 20 pixels
                                  child: Column(
                                    children: [
                                      Text(
                                        "BOOKEASE",
                                        style: GoogleFonts.poppins(
                                          fontSize: 40,
                                          fontWeight: FontWeight.w800,
                                          color: const Color.fromARGB(
                                              255, 255, 255, 255),
                                        ),
                                      ),
                                      const SizedBox(
                                          height: 2), // Minimal spacing
                                      Text(
                                        "BORROW SMART",
                                        style: GoogleFonts.poppins(
                                          fontSize: 24,
                                          color: const Color.fromARGB(
                                              255, 249, 249, 249),
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        // 📌 Right Side: Login Form
                        Expanded(
                          flex: 1,
                          child: Padding(
                            padding: const EdgeInsets.only(
                              top: 50,
                              left: 50,
                              right: 50,
                            ),
                            child: _buildLoginForm(context, isWideScreen),
                          ),
                        ),
                      ],
                    )
                  : Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(height: 60),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 20),
                            child: Image.asset(
                              'assets/images/logo-removebg-preview.png',
                              height: 150,
                            ),
                          ),
                          const SizedBox(height: 10),
                          _buildLoginForm(context, isWideScreen),
                        ],
                      ),
                    ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildLoginForm(BuildContext context, bool isWideScreen) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ✅ Show "WELCOME BACK ADMIN!" only on large screens
          if (isWideScreen)
            Padding(
              padding: EdgeInsets.only(bottom: 40),
              child: Text(
                "WELCOME BACK ADMIN!",
                style: GoogleFonts.poppins(
                  fontSize: 34, // ✅ Larger Text
                  fontWeight: FontWeight.w900, // ✅ Extra Bold
                  color: Colors.teal,
                ),
                textAlign: TextAlign.center,
              ),
            ),

          // 📌 ID Number Field
          TextField(
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'^[0-9]+$')),
            ],
            style: const TextStyle(color: Colors.black),
            decoration: InputDecoration(
              labelText: 'ID Number',
              labelStyle: const TextStyle(color: Colors.grey),
              floatingLabelStyle: const TextStyle(color: Colors.teal),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.teal, width: 2),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          const SizedBox(height: 15),

          // 📌 Password Field
          const PasswordField(),
          const SizedBox(height: 10),

          // 📌 Forgot Password
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () {},
              child: const Text(
                'Forgot password?',
                style: TextStyle(color: Colors.black),
              ),
            ),
          ),
          const SizedBox(height: 10),

          // 📌 Login Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        const UserDashApp(), // ✅ Navigates to Dashboard
                  ),
                );
              },
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 12),
                child: Text(
                  'Login',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),

          // 📌 Navigate to SignUp Page
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("Don't have an account? "),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          const SignUpScreen(), // ✅ Navigates to Signup
                    ),
                  );
                },
                child: const Text(
                  'Sign Up',
                  style: TextStyle(
                    color: Colors.teal,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

class PasswordField extends StatefulWidget {
  const PasswordField({super.key});

  @override
  _PasswordFieldState createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool isObscured = true;

  @override
  Widget build(BuildContext context) {
    return TextField(
      obscureText: isObscured,
      cursorColor: Colors.teal,
      style: const TextStyle(color: Colors.black),
      decoration: InputDecoration(
        labelText: 'Password',
        labelStyle: const TextStyle(color: Colors.grey),
        floatingLabelStyle: const TextStyle(color: Colors.teal),
        border: OutlineInputBorder(
          borderSide: const BorderSide(
              color: Colors.grey, width: 1.5), // ✅ Fixed border error
          borderRadius: BorderRadius.circular(10), // ✅ Ensure this works
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.teal, width: 2),
          borderRadius: BorderRadius.circular(10),
        ),
        suffixIcon: IconButton(
          icon: Icon(
            isObscured ? Icons.visibility : Icons.visibility_off,
            color: Colors.teal,
          ),
          onPressed: () {
            setState(() {
              isObscured = !isObscured;
            });
          },
        ),
      ),
    );
  }
}
