import 'package:flutter/material.dart';
import 'package:book_ease/screens/admin/admin_theme.dart';

class ViewBookModal extends StatelessWidget {
  final Map<String, String> book;
  const ViewBookModal({super.key, required this.book});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      backgroundColor: Colors.white,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 800),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with Positioned Close Button
                Stack(
                  children: [
                    Center(
                      child: Text(
                        'Book Information',
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: AdminColor.primaryTextColor,
                        ),
                      ),
                    ),
                    Positioned(
                      right: 0,
                      top: 0,
                      child: IconButton(
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        icon: CircleAvatar(
                          radius: 14,
                          backgroundColor: AdminColor.secondaryBackgroundColor,
                          child: const Icon(Icons.close,
                              size: 16, color: Colors.white),
                        ),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Content
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Left Column
                    Expanded(
                      flex: 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if ((book['image'] ?? '').isNotEmpty)
                            Center(
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black12,
                                      blurRadius: 10,
                                      offset: Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Image.asset(
                                    book['image']!,
                                    height: 200,
                                    fit: BoxFit.contain,
                                    errorBuilder:
                                        (context, error, stackTrace) =>
                                            const Text("Image not found"),
                                  ),
                                ),
                              ),
                            ),
                          const SizedBox(height: 20),
                          _buildTextField(
                              label: 'Category', value: book['category'] ?? ''),
                          _buildTextField(
                              label: 'Condition',
                              value: book['condition'] ?? ''),
                          const SizedBox(height: 16),
                          const Text(
                            'Description:',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(book['description'] ?? ''),
                        ],
                      ),
                    ),
                    const SizedBox(width: 20),

                    // Right Column
                    Expanded(
                      flex: 3,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildTextField(
                              label: 'Book ID', value: book['bookId'] ?? ''),
                          _buildTextField(
                              label: 'Title', value: book['title'] ?? ''),
                          _buildTextField(
                              label: 'Author', value: book['author'] ?? ''),
                          Row(
                            children: [
                              Expanded(
                                child: _buildTextField(
                                    label: 'Year Published',
                                    value: book['year'] ?? ''),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: _buildTextField(
                                    label: 'Version',
                                    value: book['version'] ?? ''),
                              ),
                            ],
                          ),
                          _buildTextField(
                              label: 'ISBN', value: book['isbn'] ?? ''),
                          // ✅ Correctly side-by-side
                          Row(
                            children: [
                              Expanded(
                                child: _buildTextField(
                                    label: 'Copies',
                                    value: book['copies'] ?? ''),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: _buildTextField(
                                    label: 'Section',
                                    value: book['section'] ?? ''),
                              ),
                            ],
                          ),
                          _buildTextField(
                              label: 'Shelf Location',
                              value: book['shelfLocation'] ?? ''),
                        ],
                      ),
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

  Widget _buildTextField({required String label, required String value}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 6),
          TextFormField(
            initialValue: value,
            readOnly: true,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.grey.shade400),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(
                    color: AdminColor.secondaryBackgroundColor, width: 2),
              ),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              filled: true,
              fillColor: Colors.grey[200],
            ),
            style: const TextStyle(
              color: Colors.black87,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}
