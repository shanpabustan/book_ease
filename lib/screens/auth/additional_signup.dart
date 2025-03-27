import 'package:book_ease/screens/auth/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AdditionalSignUpScreen extends StatefulWidget {
  const AdditionalSignUpScreen({super.key});

  @override
  _AdditionalSignUpScreenState createState() => _AdditionalSignUpScreenState();
}

class _AdditionalSignUpScreenState extends State<AdditionalSignUpScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final TextEditingController _studentIdController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  // State for password visibility
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  // Dropdown values
  String? _selectedCourse;
  String? _selectedYearLevel;

  final List<String> _courses = [
    'Computer Science',
    'Information Technology',
    'Business Administration',
    'Engineering',
    'Education',
  ];

  final List<String> _yearLevels = [
    '1st Year',
    '2nd Year',
    '3rd Year',
    '4th Year',
  ];

  // Validation functions
  String? _validateField(String? value) {
    if (value == null || value.isEmpty) {
      return 'This field is required';
    }
    return null;
  }

  String? _validateStudentId(String? value) {
    if (value == null || value.isEmpty) {
      return 'Student ID is required';
    }
    final RegExp studentIdRegex = RegExp(r'^[0-9-]+$');
    if (!studentIdRegex.hasMatch(value)) {
      return 'Only numbers and dashes (-) are allowed';
    }
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Confirm Password is required';
    }
    if (value != _passwordController.text) {
      return 'Passwords do not match';
    }
    return null;
  }

  // ignore: unused_element
  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final formData = {
        "student_id": _studentIdController.text.trim(),
        "course": _selectedCourse,
        "year_level": _selectedYearLevel,
        "password": _passwordController.text.trim(),
      };
      print("Form Data: $formData");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 30),

                  // Back Button
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                  ),

                  // Logo
                  Image.asset(
                    'assets/images/logo-removebg-preview.png',
                    width: 250,
                    height: 250,
                  ),
                  const SizedBox(height: 5),

                  const SizedBox(height: 20),

                  // Student ID
                  _buildTextField(
                    "Student ID",
                    _studentIdController,
                    validator: _validateStudentId,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'^[0-9-]+$')),
                    ],
                  ),

                  const SizedBox(height: 15),

                  // Course Dropdown
                  _buildDropdownField(
                    label: "Course",
                    value: _selectedCourse,
                    items: _courses,
                    onChanged: (value) {
                      setState(() {
                        _selectedCourse = value;
                      });
                    },
                  ),

                  const SizedBox(height: 15),

                  // Year Level Dropdown
                  _buildDropdownField(
                    label: "Year level",
                    value: _selectedYearLevel,
                    items: _yearLevels,
                    onChanged: (value) {
                      setState(() {
                        _selectedYearLevel = value;
                      });
                    },
                  ),

                  const SizedBox(height: 15),

                  // Password
                  _buildPasswordField(
                    "Password",
                    _passwordController,
                    _obscurePassword,
                    () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  ),

                  const SizedBox(height: 15),

                  // Confirm Password
                  _buildPasswordField(
                    "Confirm Password",
                    _confirmPasswordController,
                    _obscureConfirmPassword,
                    () {
                      setState(() {
                        _obscureConfirmPassword = !_obscureConfirmPassword;
                      });
                    },
                    validator:
                        _validateConfirmPassword, // ✅ Password validation
                  ),

                  const SizedBox(height: 40),

                  // Sign Up Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          // Ensure form validation before navigating
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  LogBookEaseApp(), // ✅ Navigate to LogBookEaseApp
                            ),
                          );
                        }
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
                          'Sign Up',
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Already have an account? Sign In
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Already have an account? "),
                      GestureDetector(
                        onTap: () {},
                        child: const Text(
                          "Sign In",
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
      ),
    );
  }

  // Text Field Widget
  Widget _buildTextField(
    String label,
    TextEditingController controller, {
    String? Function(String?)? validator,
    TextInputType keyboardType = TextInputType.text,
    List<TextInputFormatter>? inputFormatters,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: validator,
      inputFormatters: inputFormatters,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.grey),
        floatingLabelStyle: const TextStyle(color: Colors.teal),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.teal, width: 2),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  // Password Field Widget
// Password Field Widget (Matches Design of Other Fields)
  Widget _buildPasswordField(
    String label,
    TextEditingController controller,
    bool obscureText,
    VoidCallback onToggle, {
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.grey),
        floatingLabelStyle: const TextStyle(color: Colors.teal),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.teal, width: 2),
          borderRadius: BorderRadius.circular(10),
        ),
        suffixIcon: IconButton(
          icon: Icon(
            obscureText ? Icons.visibility_off : Icons.visibility,
            color: Colors.teal,
          ),
          onPressed: onToggle,
        ),
      ),
    );
  }

  // Dropdown Field Widget
  Widget _buildDropdownField({
    required String label,
    required String? value,
    required List<String> items,
    required void Function(String?) onChanged,
  }) {
    return DropdownButtonFormField<String>(
      value: value,
      validator: _validateField,
      decoration: InputDecoration(
        labelStyle: const TextStyle(color: Colors.grey),
        floatingLabelStyle: const TextStyle(color: Colors.teal),
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.teal, width: 2),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      items: items.map((String item) {
        return DropdownMenuItem<String>(
          value: item,
          child: Text(item),
        );
      }).toList(),
      onChanged: onChanged,
    );
  }
}
