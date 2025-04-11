import 'dart:io';
import 'package:book_ease/utils/snackbar_util.dart';
import 'package:book_ease/widgets/admin_buttons_widget.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:book_ease/screens/admin/admin_theme.dart';

class EditBookForm extends StatefulWidget {
  final Map<String, dynamic> initialBookData; // Receiving initial data

  const EditBookForm({Key? key, required this.initialBookData})
      : super(key: key);

  @override
  State<EditBookForm> createState() => _EditBookFormState();
}

class _EditBookFormState extends State<EditBookForm> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _bookIdController;
  late TextEditingController _titleController;
  late TextEditingController _authorController;
  late TextEditingController _yearController;
  late TextEditingController _versionController;
  late TextEditingController _isbnController;
  late TextEditingController _totalCopiesController;
  late TextEditingController _sectionController;
  late TextEditingController _shelfLocationController;
  late TextEditingController _descriptionController;
  late TextEditingController _customCategoryController;

  String? _selectedCategory;
  String? _selectedCondition;
  File? _pickedImage;

  final List<String> _baseCategories = [
    'Programming',
    'Fiction',
    'Non Fiction',
    'Data Science',
    'Machine Learning',
    'Others',
  ];
  List<String> _categories = [];

  final List<String> conditions = ['New', 'Used'];

  @override
  void initState() {
    super.initState();
    _categories = List.from(_baseCategories);

    // Initialize controllers with data passed from the parent widget
    _bookIdController =
        TextEditingController(text: widget.initialBookData['bookId']);
    _titleController =
        TextEditingController(text: widget.initialBookData['title']);
    _authorController =
        TextEditingController(text: widget.initialBookData['author']);
    _yearController =
        TextEditingController(text: widget.initialBookData['year']);
    _versionController =
        TextEditingController(text: widget.initialBookData['version']);
    _isbnController =
        TextEditingController(text: widget.initialBookData['isbn']);
    _totalCopiesController =
        TextEditingController(text: widget.initialBookData['copies']);
    _sectionController =
        TextEditingController(text: widget.initialBookData['section']);
    _shelfLocationController =
        TextEditingController(text: widget.initialBookData['shelfLocation']);
    _descriptionController =
        TextEditingController(text: widget.initialBookData['description']);
    _customCategoryController = TextEditingController();

    _selectedCategory = widget.initialBookData['category'];
    _selectedCondition = widget.initialBookData['condition'];
    if (widget.initialBookData['image'] != null) {
      _pickedImage = File(widget.initialBookData['image']);
    }
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
            _categories.insert(_categories.length - 1, customCategory);
            _selectedCategory = customCategory;
          });
        }
      }

      // ✅ Debug print here
      print('Selected Condition: $_selectedCondition');

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

      print("Updated Book Data: $bookData");

      showCustomSnackBar(
        context,
        message: 'Book updated successfully!',
        backgroundColor: Colors.green,
        icon: Icons.check_circle,
      );

      // ✅ Then close the modal/dialog
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
                        'Edit Book',
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
                                    ? 'Please select a category'
                                    : null,
                              ),
                              const SizedBox(height: 16),
                              if (_selectedCategory == 'Others')
                                CustomTextFormField(
                                  controller: _customCategoryController,
                                  label: 'Enter Custom Category',
                                ),
                              const SizedBox(height: 16),
                              DropdownButtonFormField<String>(
                                value: _selectedCondition,
                                items: conditions
                                    .map(
                                        (condition) => DropdownMenuItem<String>(
                                              value: condition,
                                              child: Text(condition),
                                            ))
                                    .toList(),
                                decoration: InputDecoration(
                                  labelText: 'Condition',
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
                                    _selectedCondition = value;
                                  });
                                },
                                validator: (value) => value == null
                                    ? 'Please select a condition'
                                    : null,
                              ),
                              const SizedBox(height: 16),
                              TextFormField(
                                controller: _descriptionController,
                                maxLines:
                                    5, // Increase this value for more height
                                decoration: InputDecoration(
                                  labelText: 'Description',
                                  hintText: 'Write here...',
                                  floatingLabelStyle: const TextStyle(
                                    color: AdminColor.secondaryBackgroundColor,
                                  ),
                                  alignLabelWithHint:
                                      true, // aligns with multi-line
                                  contentPadding: const EdgeInsets.symmetric(
                                    vertical: 42,
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

                        // RIGHT COLUMN
                        const SizedBox(width: 16),
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
                                CustomTextFormField(
                                    controller: _bookIdController,
                                    label: 'Book ID',
                                    inputFormatters: [
                                      FilteringTextInputFormatter.digitsOnly
                                    ]),
                                CustomTextFormField(
                                  controller: _titleController,
                                  label: 'Title',
                                ),
                                CustomTextFormField(
                                  controller: _authorController,
                                  label: 'Author',
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: CustomTextFormField(
                                          controller: _yearController,
                                          label: 'Year of Publication',
                                          inputFormatters: [
                                            FilteringTextInputFormatter
                                                .digitsOnly
                                          ]),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: CustomTextFormField(
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
                                CustomTextFormField(
                                  controller: _isbnController,
                                  label: 'ISBN',
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: CustomTextFormField(
                                          controller: _totalCopiesController,
                                          label: 'Total Copies',
                                          inputFormatters: [
                                            FilteringTextInputFormatter
                                                .digitsOnly
                                          ]),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: CustomTextFormField(
                                        controller: _sectionController,
                                        label: 'Section',
                                      ),
                                    ),
                                  ],
                                ),
                                CustomTextFormField(
                                  controller: _shelfLocationController,
                                  label: 'Shelf Location',
                                ),
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

                        // CUT THIS
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomTextFormField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final List<TextInputFormatter>? inputFormatters;
  final TextInputType? keyboardType;

  const CustomTextFormField({
    super.key,
    required this.controller,
    required this.label,
    this.inputFormatters,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        inputFormatters: inputFormatters,
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
