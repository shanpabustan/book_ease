class Book {
  final int bookId;
  final String title;
  final String author;
  final int copies;
  final String year;
  final String description;
  final String image;
  final String isbn;
  final String shelfLocation;
  final String librarySection;

  Book({
    required this.bookId,
    required this.title,
    required this.author,
    required this.copies,
    required this.year,
    required this.description,
    required this.image,
    required this.isbn,
    required this.shelfLocation,
    required this.librarySection,
  });

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      bookId: json['book_id'],
      title: json['title'],
      author: json['author'],
      copies: json['available_copies'],
      year: json['year_published']?.toString() ?? "Unknown",
      description: json['description'],
      image: json['picture'],
      isbn: json['isbn'] ?? "Unknown",
      shelfLocation: json['shelf_location'] ?? "Unknown",
      librarySection: json['library_section'] ?? "Unknown",
    );
  }
}
