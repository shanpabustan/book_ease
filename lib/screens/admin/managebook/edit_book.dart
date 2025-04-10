import 'package:flutter/material.dart';

class EditBookModal extends StatefulWidget {
  final Map<String, String> book;
  const EditBookModal({super.key, required this.book});

  @override
  State<EditBookModal> createState() => _EditBookModalState();
}

class _EditBookModalState extends State<EditBookModal> {
  late final TextEditingController _titleController;
  late final TextEditingController _authorController;
  late final TextEditingController _yearController;
  late final TextEditingController _versionController;
  late final TextEditingController _isbnController;
  late final TextEditingController _copiesController;
  late final TextEditingController _sectionController;
  late final TextEditingController _shelfLocationController;
  late final TextEditingController _categoryController;
  late final TextEditingController _conditionController;
  late final TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.book['title']);
    _authorController = TextEditingController(text: widget.book['author']);
    _yearController = TextEditingController(text: widget.book['year']);
    _versionController = TextEditingController(text: widget.book['version']);
    _isbnController = TextEditingController(text: widget.book['isbn']);
    _copiesController = TextEditingController(text: widget.book['copies']);
    _sectionController = TextEditingController(text: widget.book['section']);
    _shelfLocationController =
        TextEditingController(text: widget.book['shelfLocation']);
    _categoryController = TextEditingController(text: widget.book['category']);
    _conditionController =
        TextEditingController(text: widget.book['condition']);
    _descriptionController =
        TextEditingController(text: widget.book['description']);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _authorController.dispose();
    _yearController.dispose();
    _versionController.dispose();
    _isbnController.dispose();
    _copiesController.dispose();
    _sectionController.dispose();
    _shelfLocationController.dispose();
    _categoryController.dispose();
    _conditionController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      backgroundColor: Colors.white,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 800),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Stack(
                  children: [
                    Center(
                      child: Text(
                        'Edit Book Information',
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.blueAccent,
                        ),
                      ),
                    ),
                    Positioned(
                      right: 0,
                      child: IconButton(
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        icon: const CircleAvatar(
                          radius: 14,
                          backgroundColor: Colors.blueAccent,
                          child:
                              Icon(Icons.close, size: 16, color: Colors.white),
                        ),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Left Column
                    Expanded(
                      flex: 2,
                      child: Column(
                        children: [
                          if ((widget.book['image'] ?? '').isNotEmpty)
                            Center(
                              child: Container(
                                height: 200,
                                decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black12,
                                      blurRadius: 10,
                                      offset: Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: Image.asset(
                                  widget.book['image']!,
                                  fit: BoxFit.contain,
                                  errorBuilder: (context, error, stackTrace) =>
                                      const Text("Image not found"),
                                ),
                              ),
                            ),
                          const SizedBox(height: 20),
                          _buildTextField('Category', _categoryController),
                          _buildTextField('Condition', _conditionController),
                          const SizedBox(height: 16),
                          const Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Description:',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          const SizedBox(height: 6),
                          TextFormField(
                            controller: _descriptionController,
                            maxLines: 5,
                            decoration: _inputDecoration(),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 20),

                    // Right Column
                    Expanded(
                      flex: 3,
                      child: Column(
                        children: [
                          _buildTextField('Title', _titleController),
                          _buildTextField('Author', _authorController),
                          Row(
                            children: [
                              Expanded(
                                  child: _buildTextField(
                                      'Year Published', _yearController)),
                              const SizedBox(width: 12),
                              Expanded(
                                  child: _buildTextField(
                                      'Version', _versionController)),
                            ],
                          ),
                          _buildTextField('ISBN', _isbnController),
                          Row(
                            children: [
                              Expanded(
                                  child: _buildTextField(
                                      'Copies', _copiesController)),
                              const SizedBox(width: 12),
                              Expanded(
                                  child: _buildTextField(
                                      'Section', _sectionController)),
                            ],
                          ),
                          _buildTextField(
                              'Shelf Location', _shelfLocationController),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        widget.book['title'] = _titleController.text;
                        widget.book['author'] = _authorController.text;
                        widget.book['year'] = _yearController.text;
                        widget.book['version'] = _versionController.text;
                        widget.book['isbn'] = _isbnController.text;
                        widget.book['copies'] = _copiesController.text;
                        widget.book['section'] = _sectionController.text;
                        widget.book['shelfLocation'] =
                            _shelfLocationController.text;
                        widget.book['category'] = _categoryController.text;
                        widget.book['condition'] = _conditionController.text;
                        widget.book['description'] =
                            _descriptionController.text;
                      });
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 12),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                    child: const Text('Save Changes'),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 6),
          TextFormField(
            controller: controller,
            decoration: _inputDecoration(),
          ),
        ],
      ),
    );
  }

  InputDecoration _inputDecoration() {
    return InputDecoration(
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.grey.shade400),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Colors.blueAccent, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      filled: true,
      fillColor: Colors.grey[200],
    );
  }
}
