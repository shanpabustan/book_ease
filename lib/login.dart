import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// ignore: unused_import
import 'student_screens/user_dashboard.dart';

void main() {
  runApp(const BookEaseApp());
}

class BookEaseApp extends StatelessWidget {
  const BookEaseApp({super.key});

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
      body: LayoutBuilder(
        builder: (context, constraints) {
          bool isWideScreen =
              constraints.maxWidth > 1000; // Detect large screens

          return Container(
            height: MediaQuery.of(context).size.height, // Full height
            width: double.infinity, // Full width
            child: isWideScreen
                ? Row(
                    children: [
                      // Left Side: Logo with Full Teal Background
                      Expanded(
                        flex: 1,
                        child: Container(
                          width: double.infinity,
                          height: double.infinity,
                          color: Colors.teal, // Left side background color
                          alignment: Alignment.center,
                          child: Image.asset(
                            'assets/images/logo-removebg-preview.png',
                            width: constraints.maxWidth > 1200 ? 500 : 350,
                            height: constraints.maxWidth > 1200 ? 500 : 350,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),

                      // Right Side: Login Form (No Background Color)
                      Expanded(
                        flex: 1,
                        child: Padding(
                          padding: const EdgeInsets.only(
                            top: 50, // Top padding
                            left: 50, // Left padding
                            right: 50, // Right padding
                          ),
                          child: _buildLoginForm(context, isWideScreen),
                        ),
                      ),
                    ],
                  )
                : Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 18.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(height: 60),
                        Padding(
                          padding: const EdgeInsets.only(
                              bottom: 20), // Bottom padding
                          child: Image.asset(
                            'assets/images/logo-removebg-preview.png',
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
    );
  }

  /// Login Form Widget with **WELCOME BACK ADMIN!** Condition
  Widget _buildLoginForm(BuildContext context, bool isWideScreen) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ✅ Display only if screen is wider than 1000px
          if (isWideScreen)
            const Padding(
              padding: EdgeInsets.only(bottom: 40),
              child: Text(
                "WELCOME BACK ADMIN!",
                style: TextStyle(
                  fontSize: 30, // Slightly larger text
                  fontWeight: FontWeight.bold, // Bold text
                  color: Colors.teal, // Teal color
                  fontFamily: 'Poppins',
                ),
                textAlign: TextAlign.center,
              ),
            ),

          TextField(
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'^[0-9-]+$')),
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
          const PasswordField(),
          const SizedBox(height: 10),
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
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
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
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("Don't have an account? "),
              GestureDetector(
                onTap: () {},
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

/// **PasswordField Widget**
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
          borderRadius: BorderRadius.circular(10),
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
