import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class AddBookForm extends StatefulWidget {
  const AddBookForm({Key? key}) : super(key: key);

  @override
  _AddBookFormState createState() => _AddBookFormState();
}

class _AddBookFormState extends State<AddBookForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _bookIdController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _authorController = TextEditingController();
  final TextEditingController _isbnController = TextEditingController();
  final TextEditingController _librarySectionController =
      TextEditingController();
  final TextEditingController _shelfLocationController =
      TextEditingController();
  final TextEditingController _totalCopiesController = TextEditingController();
  final TextEditingController _availableCopiesController =
      TextEditingController();

  String? _selectedCategory;
  String? _selectedCondition;
  File? _selectedImage;

  final List<String> _categories = [
    "Information System",
    "Computer Science",
    "Engineering",
    "Mathematics",
    "Literature",
  ];

  final List<String> _conditions = ["New", "Good", "Fair", "Damaged"];

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  void _saveBook() {
    if (_formKey.currentState!.validate()) {
      print("Saving book...");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add New Book"),
        backgroundColor: Colors.blueGrey[700],
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 2,
                      child: Column(
                        children: [
                          GestureDetector(
                            onTap: _pickImage,
                            child: _selectedImage == null
                                ? Container(
                                    width: 150,
                                    height: 200,
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.grey),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: const Center(
                                        child: Text("Upload Image")),
                                  )
                                : Image.file(
                                    _selectedImage!,
                                    width: 150,
                                    height: 200,
                                    fit: BoxFit.cover,
                                  ),
                          ),
                          const SizedBox(height: 20),
                          DropdownButtonFormField<String>(
                            value: _selectedCategory,
                            decoration:
                                const InputDecoration(labelText: "Category"),
                            items: _categories.map((String category) {
                              return DropdownMenuItem(
                                  value: category, child: Text(category));
                            }).toList(),
                            onChanged: (value) =>
                                setState(() => _selectedCategory = value),
                            validator: (value) =>
                                value == null ? "Select a category" : null,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      flex: 3,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextFormField(
                            controller: _bookIdController,
                            decoration:
                                const InputDecoration(labelText: "Book ID"),
                            validator: (value) =>
                                value!.isEmpty ? "Book ID is required" : null,
                          ),
                          TextFormField(
                            controller: _titleController,
                            decoration:
                                const InputDecoration(labelText: "Title"),
                            validator: (value) =>
                                value!.isEmpty ? "Title is required" : null,
                          ),
                          TextFormField(
                            controller: _authorController,
                            decoration:
                                const InputDecoration(labelText: "Author"),
                            validator: (value) =>
                                value!.isEmpty ? "Author is required" : null,
                          ),
                          TextFormField(
                            controller: _isbnController,
                            decoration:
                                const InputDecoration(labelText: "ISBN"),
                            validator: (value) =>
                                value!.isEmpty ? "ISBN is required" : null,
                          ),
                          TextFormField(
                            controller: _librarySectionController,
                            decoration: const InputDecoration(
                                labelText: "Library Section"),
                            validator: (value) => value!.isEmpty
                                ? "Library Section is required"
                                : null,
                          ),
                          TextFormField(
                            controller: _shelfLocationController,
                            decoration: const InputDecoration(
                                labelText: "Shelf Location"),
                            validator: (value) => value!.isEmpty
                                ? "Shelf Location is required"
                                : null,
                          ),
                          TextFormField(
                            controller: _totalCopiesController,
                            decoration: const InputDecoration(
                                labelText: "Total Copies"),
                            keyboardType: TextInputType.number,
                            validator: (value) => value!.isEmpty
                                ? "Total Copies is required"
                                : null,
                          ),
                          TextFormField(
                            controller: _availableCopiesController,
                            decoration: const InputDecoration(
                                labelText: "Available Copies"),
                            keyboardType: TextInputType.number,
                            validator: (value) => value!.isEmpty
                                ? "Available Copies is required"
                                : null,
                          ),
                          DropdownButtonFormField<String>(
                            value: _selectedCondition,
                            decoration:
                                const InputDecoration(labelText: "Condition"),
                            items: _conditions.map((String condition) {
                              return DropdownMenuItem(
                                  value: condition, child: Text(condition));
                            }).toList(),
                            onChanged: (value) =>
                                setState(() => _selectedCondition = value),
                            validator: (value) =>
                                value == null ? "Select a condition" : null,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        _formKey.currentState?.reset();
                        setState(() {
                          _selectedCategory = null;
                          _selectedCondition = null;
                          _selectedImage = null;
                        });
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey),
                      child: const Text("Clear All"),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: _saveBook,
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green),
                      child: const Text("Save"),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
