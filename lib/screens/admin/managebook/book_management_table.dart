import 'package:flutter/material.dart';

class BookManagementTable extends StatelessWidget {
  // Dummy Data for the Books
  final List<Map<String, String>> bookData = [
    {
      'title': 'Flutter for Beginners',
      'author': 'John Doe',
      'year': '2021',
      'version': '1st',
      'catalog': 'ABC123',
      'number': '101',
      'copies': '10'
    },
    {
      'title': 'Dart Programming',
      'author': 'Jane Smith',
      'year': '2020',
      'version': '2nd',
      'catalog': 'XYZ456',
      'number': '102',
      'copies': '15'
    },
    // Add more books as needed
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.all(16.0),
        ),
        // Table Header Row
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            children: [
              _buildHeaderText('Title'),
              _buildHeaderText('Author'),
              _buildHeaderText('Year Published'),
              _buildHeaderText('Version'),
              _buildHeaderText('Catalog Number'),
              _buildHeaderText('Book Number'),
              _buildHeaderText('Total Copies'),
              _buildHeaderText('Actions'),
            ],
          ),
        ),
        // Book Management Table (Displays the table with dummy data)
        Expanded(
          child: ListView.builder(
            itemCount: bookData.length,
            itemBuilder: (context, index) {
              final book = bookData[index];
              return Card(
                margin: const EdgeInsets.symmetric(
                    vertical: 10.0, horizontal: 16.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                elevation: 5,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      // Book Title Column
                      Expanded(
                        child: Text(
                          book['title'] ?? '',
                          style: const TextStyle(
                            fontSize: 14, // Uniform font size
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.left, // Align left
                        ),
                      ),
                      // Book Author Column
                      Expanded(
                        child: Text(book['author'] ?? '',
                            style: const TextStyle(fontSize: 14),
                            textAlign: TextAlign.left), // Align left
                      ),
                      // Year Published Column
                      Expanded(
                        child: Text(book['year'] ?? '',
                            style: const TextStyle(fontSize: 14),
                            textAlign: TextAlign.left), // Align left
                      ),
                      // Version Column
                      Expanded(
                        child: Text(book['version'] ?? '',
                            style: const TextStyle(fontSize: 14),
                            textAlign: TextAlign.left), // Align left
                      ),
                      // Catalog Number Column
                      Expanded(
                        child: Text(book['catalog'] ?? '',
                            style: const TextStyle(fontSize: 14),
                            textAlign: TextAlign.left), // Align left
                      ),
                      // Book Number Column
                      Expanded(
                        child: Text(book['number'] ?? '',
                            style: const TextStyle(fontSize: 14),
                            textAlign: TextAlign.left), // Align left
                      ),
                      // Total Copies Column
                      Expanded(
                        child: Text(book['copies'] ?? '',
                            style: const TextStyle(fontSize: 14),
                            textAlign: TextAlign.left), // Align left
                      ),
                      // Actions Column (View, Edit, Delete)
                      SizedBox(
                        width: 180, // Increased width to fit actions
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            TextButton(
                              onPressed: () {
                                // Handle View Action
                              },
                              child: const Text(
                                'View',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.blue,
                                ),
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                // Handle Edit Action
                              },
                              child: const Text(
                                'Edit',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.orange,
                                ),
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                // Handle Delete Action
                              },
                              child: const Text(
                                'Delete',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.red,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  // Helper method to build header text with black color
  Widget _buildHeaderText(String text) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0), // Reduced height
        child: Container(
          color:
              Colors.blueGrey[700], // Set the background color to blueGrey[700]
          padding: const EdgeInsets.symmetric(
              vertical: 6.0, horizontal: 10.0), // Added top and bottom padding
          child: Text(
            text,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 12, // Reduced font size for header
              color: Colors.white, // Set text color to white
            ),
            textAlign: TextAlign.left, // Align the header text to the left
          ),
        ),
      ),
    );
  }
}
