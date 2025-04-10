import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'book_data.dart'; // Your Book model

class BookProvider with ChangeNotifier {
  List<Book> _books = [];
  bool _isLoading = false;

  List<Book> get books => _books;
  bool get isLoading => _isLoading;

  Future<void> fetchBooks() async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await Dio().get('http://127.0.0.1:5566/get-all');
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['data'];
        _books = data.map((json) => Book.fromJson(json)).toList();
      }
    } catch (e) {
      print('Error fetching books: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
