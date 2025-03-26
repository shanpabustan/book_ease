import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'Student/UserDash.dart';

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
          bool isWideScreen = constraints.maxWidth > 600;
          return Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: isWideScreen ? 100 : 30.0),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: isWideScreen ? 500 : constraints.maxWidth * 0.9,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 40),
                      Image.asset(
                        'assets/logo-removebg-preview.png',
                        height: isWideScreen ? 220 : 150,
                      ),
                      const SizedBox(height: 30),
                      TextField(
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp(r'^[0-9-]+$')),
                        ],
                        decoration: InputDecoration(
                          labelText: 'ID Number',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),
                      const PasswordField(),
                      const SizedBox(height: 10),
                      Align(
                        alignment: Alignment.center,
                        child: TextButton(
                          onPressed: () {},
                          child: const Text('Forgot password?'),
                        ),
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const UserDashApp(),
                              ),
                            );
                          },
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
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class PasswordField extends StatefulWidget {
  const PasswordField({super.key});

  @override
  PasswordFieldState createState() => PasswordFieldState();
}

class PasswordFieldState extends State<PasswordField> {
  bool isObscured = true;

  @override
  Widget build(BuildContext context) {
    return TextField(
      obscureText: isObscured,
      decoration: InputDecoration(
        labelText: 'Password',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        suffixIcon: IconButton(
          icon: Icon(
            isObscured ? Icons.visibility : Icons.visibility_off,
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
