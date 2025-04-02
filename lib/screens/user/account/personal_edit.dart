import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:book_ease/data/course_data.dart'; // Import your courses data here

class PersonalInfoEditScreen extends StatefulWidget {
  const PersonalInfoEditScreen({super.key, required this.data});

  final Map<String, dynamic> data;

  @override
  _PersonalInfoEditScreenState createState() => _PersonalInfoEditScreenState();
}

class _PersonalInfoEditScreenState extends State<PersonalInfoEditScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _middleNameController = TextEditingController();
  final TextEditingController _suffixController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _studentIdController = TextEditingController();

  // Dropdown values
  String? _selectedCourse;
  String? _selectedYearLevel;

  final List<String> _yearLevels = [
    '1st Year',
    '2nd Year',
    '3rd Year',
    '4th Year'
  ];

  @override
  void initState() {
    super.initState();
    // Initialize data using the passed-in 'data'
    _lastNameController.text = widget.data["last_name"];
    _firstNameController.text = widget.data["first_name"];
    _middleNameController.text = widget.data["middle_name"] ?? "";
    _suffixController.text = widget.data["suffix"] ?? "";
    _emailController.text = widget.data["email"];
    _phoneController.text = widget.data["phone"];
    _studentIdController.text = widget.data["id_number"];
    _selectedCourse = widget.data["course"];
    _selectedYearLevel = widget.data["year_level"];
  }

  void _saveChanges() {
    if (_formKey.currentState!.validate()) {
      // Perform saving changes (implement API call if needed)
      print("Personal info updated successfully!");
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Edit Personal Information",
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'Poppins', // Apply Poppins font
            fontWeight: FontWeight.bold, // Optional: Adjust weight
          ),
        ),
        backgroundColor: Colors.teal,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  const SizedBox(height: 50),

                  // Non-editable fields
                  _buildDisabledField("Last Name", _lastNameController),
                  const SizedBox(height: 10),
                  _buildDisabledField("First Name", _firstNameController),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                          child: _buildDisabledField(
                              "Middle Name", _middleNameController)),
                      const SizedBox(width: 10),
                      SizedBox(
                          width: 80,
                          child:
                              _buildDisabledField("Suffix", _suffixController)),
                    ],
                  ),
                  const SizedBox(height: 10),

                  // Editable fields
                  _buildTextField(
                    "Phone Number",
                    _phoneController,
                    validator: _validatePhone,
                    keyboardType: TextInputType.phone,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  ),
                  const SizedBox(height: 10),
                  _buildDisabledField("Email", _emailController),
                  const SizedBox(height: 10),
                  _buildTextField("Student ID", _studentIdController),
                  const SizedBox(height: 15),

                  // Dropdowns
                  _buildDropdownField(
                    "Course",
                    _selectedCourse,
                    CourseData.courses,
                    (value) => setState(() => _selectedCourse = value),
                  ),
                  const SizedBox(height: 15),
                  _buildDropdownField(
                    "Year Level",
                    _selectedYearLevel,
                    _yearLevels,
                    (value) => setState(() => _selectedYearLevel = value),
                  ),
                  const SizedBox(height: 30),

                  _saveButton(),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Non-editable (Disabled) Fields
  Widget _buildDisabledField(String label, TextEditingController controller) {
    return TextFormField(
      controller: controller,
      enabled: false,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.grey),
        floatingLabelStyle: const TextStyle(color: Colors.teal),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        filled: true,
        fillColor: Colors.grey[200], // Grey background to indicate disabled
        disabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.grey),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  // Editable Text Fields
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
      validator: validator ?? (value) => _validateField(value, label),
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

  // Dropdown Fields (Now Removing Duplicates)
  Widget _buildDropdownField(
    String label,
    String? value,
    List<String> items,
    void Function(String?) onChanged,
  ) {
    items = items.toSet().toList(); // Remove duplicates

    return LayoutBuilder(builder: (context, constraints) {
      return ConstrainedBox(
        constraints: BoxConstraints(maxWidth: constraints.maxWidth),
        child: DropdownButtonFormField<String>(
          value: value,
          validator: (val) => val == null ? '$label is required' : null,
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
          items: items
              .map((item) => DropdownMenuItem(value: item, child: Text(item)))
              .toList(),
          onChanged: onChanged,
          dropdownColor: Colors.white,
        ),
      );
    });
  }

  // Save Button
  Widget _saveButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _saveChanges,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.teal,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
        child: const Padding(
          padding: EdgeInsets.symmetric(vertical: 12),
          child: Text("Save Changes",
              style: TextStyle(fontSize: 16, color: Colors.white)),
        ),
      ),
    );
  }

  // Field Validation
  String? _validateField(String? value, String fieldName) {
    if (value == null || value.isEmpty) return '$fieldName is required';
    return null;
  }

  String? _validatePhone(String? value) {
    if (value == null || value.isEmpty) return 'Phone number is required';
    if (!RegExp(r'^\d+$').hasMatch(value)) return 'Only numbers are allowed';
    if (!RegExp(r'^(09\d{9}|\+639\d{9})$').hasMatch(value)) {
      return 'Enter a valid PH phone number (e.g., 09123456789)';
    }
    return null;
  }
}
