// Import statements remain the same
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:book_ease/widgets/admin_buttons_widget.dart';
import 'package:book_ease/screens/admin/admin_theme.dart';

class AddBookForm extends StatefulWidget {
  const AddBookForm({Key? key}) : super(key: key);

  @override
  State<AddBookForm> createState() => _AddBookFormState();
}

class _AddBookFormState extends State<AddBookForm> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _bookIdController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _authorController = TextEditingController();
  final TextEditingController _yearController = TextEditingController();
  final TextEditingController _versionController = TextEditingController();
  final TextEditingController _isbnController = TextEditingController();
  final TextEditingController _totalCopiesController = TextEditingController();
  final TextEditingController _sectionController = TextEditingController();
  final TextEditingController _shelfLocationController =
      TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _customCategoryController =
      TextEditingController();

  String? _selectedCategory;
  String? _selectedCondition;
  File? _pickedImage;

  final List<String> _baseCategories = [
    'Information System',
    'Computer Science',
    'Engineering',
    'Mathematics',
    'Others',
  ];
  List<String> _categories = [];

  final List<String> conditions = ['New', 'Old'];

  @override
  void initState() {
    super.initState();
    _categories = List.from(_baseCategories);
  }

  void _pickImage() async {
    if (!kIsWeb) {
      var status = await Permission.photos.request();
      if (!status.isGranted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Photo permission is not granted')),
        );
        return;
      }
    }

    final result = await FilePicker.platform.pickFiles(type: FileType.image);
    if (result != null && result.files.single.path != null) {
      setState(() {
        _pickedImage = File(result.files.single.path!);
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No image selected.')),
      );
    }
  }

  void _clearAll() {
    _formKey.currentState?.reset();
    _bookIdController.clear();
    _titleController.clear();
    _authorController.clear();
    _yearController.clear();
    _versionController.clear();
    _isbnController.clear();
    _totalCopiesController.clear();
    _sectionController.clear();
    _shelfLocationController.clear();
    _descriptionController.clear();
    _customCategoryController.clear();
    _pickedImage = null;
    setState(() {
      _selectedCategory = null;
      _selectedCondition = null;
    });
  }

  void _saveForm() {
    if (_formKey.currentState!.validate()) {
      if (_pickedImage == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please upload an image')),
        );
        return;
      }

      // Handle custom category if "Others" was selected
      if (_selectedCategory == 'Others') {
        final customCategory = _customCategoryController.text.trim();
        if (customCategory.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Please enter a custom category')),
          );
          return;
        }

        if (!_categories.contains(customCategory)) {
          setState(() {
            _categories.insert(
                _categories.length - 1, customCategory); // Before 'Others'
            _selectedCategory = customCategory;
          });
        }
      }

      final bookData = {
        'bookId': _bookIdController.text,
        'title': _titleController.text,
        'author': _authorController.text,
        'year': _yearController.text,
        'version': _versionController.text,
        'isbn': _isbnController.text,
        'copies': _totalCopiesController.text,
        'section': _sectionController.text,
        'shelfLocation': _shelfLocationController.text,
        'category': _selectedCategory,
        'condition': _selectedCondition,
        'description': _descriptionController.text,
        'image': _pickedImage?.path ?? '',
      };

      print("BOOK DATA: $bookData");
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      backgroundColor: Colors.white,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 900, maxHeight: 800),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header / AppBar Style
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: Colors.grey, width: 0.5),
                ),
              ),
              child: Row(
                children: [
                  IconButton(
                    icon: CircleAvatar(
                      backgroundColor: AdminColor.secondaryBackgroundColor,
                      child: const Icon(Icons.close, color: Colors.white),
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const Expanded(
                    child: Center(
                      child: Text(
                        'Add Book',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: AdminFontSize.heading,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                      width: 48), // Placeholder to align the title center
                ],
              ),
            ),

            // Scrollable Content
            Expanded(
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // LEFT COLUMN
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              GestureDetector(
                                onTap: _pickImage,
                                child: Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    border:
                                        Border.all(color: Colors.grey.shade300),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Column(
                                    children: [
                                      const Text('Upload Image'),
                                      const SizedBox(height: 12),
                                      _pickedImage != null
                                          ? ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              child: kIsWeb
                                                  ? Image.network(
                                                      _pickedImage!.path,
                                                      height: 160,
                                                      fit: BoxFit.cover,
                                                    )
                                                  : Image.file(
                                                      _pickedImage!,
                                                      height: 160,
                                                      fit: BoxFit.cover,
                                                    ),
                                            )
                                          : const Icon(Icons.image,
                                              size: 100, color: Colors.grey),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),
                              DropdownButtonFormField<String>(
                                value: _selectedCategory,
                                items: _categories
                                    .map((cat) => DropdownMenuItem(
                                          value: cat,
                                          child: Text(cat),
                                        ))
                                    .toList(),
                                decoration: InputDecoration(
                                  labelText: 'Category',
                                  floatingLabelStyle: const TextStyle(
                                    color: AdminColor.secondaryBackgroundColor,
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color:
                                          AdminColor.secondaryBackgroundColor,
                                    ),
                                  ),
                                  border: const OutlineInputBorder(),
                                ),
                                onChanged: (value) {
                                  setState(() {
                                    _selectedCategory = value;
                                    if (value != 'Others') {
                                      _customCategoryController.clear();
                                    }
                                  });
                                },
                                validator: (value) => value == null
                                    ? 'Category is required'
                                    : null,
                              ),
                              if (_selectedCategory == 'Others') ...[
                                const SizedBox(height: 16),
                                TextFormField(
                                  controller: _customCategoryController,
                                  decoration: InputDecoration(
                                    labelText: 'Enter Custom Category',
                                    floatingLabelStyle: const TextStyle(
                                      color:
                                          AdminColor.secondaryBackgroundColor,
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color:
                                            AdminColor.secondaryBackgroundColor,
                                      ),
                                    ),
                                    border: const OutlineInputBorder(),
                                  ),
                                  validator: (value) {
                                    if (_selectedCategory == 'Others' &&
                                        (value == null ||
                                            value.trim().isEmpty)) {
                                      return 'Please enter a custom category';
                                    }
                                    return null;
                                  },
                                ),
                              ],
                              const SizedBox(height: 16),
                              DropdownButtonFormField<String>(
                                value: _selectedCondition,
                                items: conditions
                                    .map((cond) => DropdownMenuItem(
                                          value: cond,
                                          child: Text(cond),
                                        ))
                                    .toList(),
                                decoration: InputDecoration(
                                  labelText: 'Book Condition',
                                  floatingLabelStyle: const TextStyle(
                                    color: AdminColor.secondaryBackgroundColor,
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color:
                                          AdminColor.secondaryBackgroundColor,
                                    ),
                                  ),
                                  border: const OutlineInputBorder(),
                                ),
                                onChanged: (value) =>
                                    setState(() => _selectedCondition = value),
                                validator: (value) => value == null
                                    ? 'Condition is required'
                                    : null,
                              ),
                              const SizedBox(height: 16),
                              TextFormField(
                                controller: _descriptionController,
                                maxLines:
                                    8, // Increase this value for more height
                                decoration: InputDecoration(
                                  labelText: 'Description',
                                  hintText: 'Write here...',
                                  floatingLabelStyle: const TextStyle(
                                    color: AdminColor.secondaryBackgroundColor,
                                  ),
                                  alignLabelWithHint:
                                      true, // aligns with multi-line
                                  contentPadding: const EdgeInsets.symmetric(
                                    vertical: 43,
                                    horizontal: 16,
                                  ), // Increases internal height
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color:
                                          AdminColor.secondaryBackgroundColor,
                                    ),
                                  ),
                                  border: const OutlineInputBorder(),
                                ),
                                validator: (value) =>
                                    value == null || value.isEmpty
                                        ? 'Description is required'
                                        : null,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 32),

                        // RIGHT COLUMN
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade300),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Information',
                                  style: TextStyle(
                                    fontSize: AdminFontSize.subHeading,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                BookTextField(
                                    label: 'Book ID',
                                    controller: _bookIdController,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.digitsOnly
                                    ]),
                                BookTextField(
                                    label: 'Title',
                                    controller: _titleController),
                                BookTextField(
                                    label: 'Author',
                                    controller: _authorController),
                                Row(
                                  children: [
                                    Expanded(
                                      child: BookTextField(
                                        label: 'Year Published',
                                        controller: _yearController,
                                        inputFormatters: [
                                          FilteringTextInputFormatter.digitsOnly
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: BookTextField(
                                        label: 'Version',
                                        controller: _versionController,
                                        keyboardType: const TextInputType
                                            .numberWithOptions(decimal: true),
                                        inputFormatters: [
                                          FilteringTextInputFormatter.allow(
                                              RegExp(r'^\d*\.?\d{0,2}')),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                BookTextField(
                                    label: 'ISBN', controller: _isbnController),
                                Row(
                                  children: [
                                    Expanded(
                                      child: BookTextField(
                                        label: 'Total Copies',
                                        controller: _totalCopiesController,
                                        inputFormatters: [
                                          FilteringTextInputFormatter
                                              .digitsOnly,
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: BookTextField(
                                        label: 'Library Section',
                                        controller: _sectionController,
                                      ),
                                    ),
                                  ],
                                ),
                                BookTextField(
                                    label: 'Shelf Location',
                                    controller: _shelfLocationController),
                                const SizedBox(height: 24),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    CustomButton(
                                      text: 'Clear All',
                                      onPressed: _clearAll,
                                      backgroundColor: Colors.white,
                                      textColor: Colors.black,
                                    ),
                                    const SizedBox(width: 12),
                                    CustomButton(
                                      text: 'Save',
                                      onPressed: _saveForm,
                                      backgroundColor:
                                          AdminColor.secondaryBackgroundColor,
                                      textColor: Colors.white,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        // CUT HERE
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // Cut Here
          ],
        ),
      ),
    );
  }
}

class BookTextField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final List<TextInputFormatter>? inputFormatters;
  final TextInputType? keyboardType;

  const BookTextField({
    required this.label,
    required this.controller,
    this.inputFormatters,
    super.key,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextFormField(
        controller: controller,
        inputFormatters: inputFormatters,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          floatingLabelStyle:
              const TextStyle(color: AdminColor.secondaryBackgroundColor),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: AdminColor.secondaryBackgroundColor),
          ),
          border: const OutlineInputBorder(),
        ),
        validator: (value) =>
            value == null || value.isEmpty ? '$label is required' : null,
      ),
    );
  }
}
