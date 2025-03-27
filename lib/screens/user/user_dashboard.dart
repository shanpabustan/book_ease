import 'package:flutter/material.dart';
import 'package:book_ease/screens/user/user_nav.dart';
import 'package:book_ease/screens/user/library_screen.dart';
import 'package:book_ease/screens/user/mybooks_screen.dart';
import 'package:book_ease/screens/user/profile_screen.dart';

void main() {
  runApp(const UserDashApp());
}

class UserDashApp extends StatefulWidget {
  const UserDashApp({super.key});

  @override
  _UserDashAppState createState() => _UserDashAppState();
}

class _UserDashAppState extends State<UserDashApp> {
  int _selectedIndex = 0; // Track selected tab

  final List<Widget> _pages = [
    const HomeScreen(),
    const LibraryScreen(),
    const MyBooksScreen(),
    const ProfileScreen(),
  ];

  void _onTabChange(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: _pages[_selectedIndex], // Display selected page
        bottomNavigationBar: NavigationBarWidget(
          selectedIndex: _selectedIndex,
          onTabChange: _onTabChange,
        ),
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: Container(
          height: 40,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Search for books...',
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(vertical: 10),
              prefixIcon: const Icon(Icons.search, color: Colors.grey),
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Explore Library Books',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Container(
              height: 180,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                image: const DecorationImage(
                  image: AssetImage('assets/images/banner.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 25),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildCategoryIcon(
                      context, Icons.computer_rounded, 'Technology'),
                  _buildCategoryIcon(context, Icons.calculate, 'Mathematics'),
                  _buildCategoryIcon(context, Icons.psychology, 'Psychology'),
                  _buildCategoryIcon(context, Icons.balance, 'Physics'),
                  _buildCategoryIcon(context, Icons.science, 'Chemistry'),
                ],
              ),
            ),
            const SizedBox(height: 10),
            _buildSectionTitle(context, 'Recommendations'),
            _buildBookList(),
            _buildSectionTitle(context, 'Borrowed Books'),
            _buildBookList(),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryIcon(BuildContext context, IconData icon, String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        children: [
          Icon(icon, size: 40, color: Colors.teal),
          FittedBox(
            child: Text(
              label,
              style: TextStyle(
                fontSize: MediaQuery.of(context).size.width * 0.03,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          TextButton(
            onPressed: () {},
            child: const Text('See All', style: TextStyle(color: Colors.teal)),
          ),
        ],
      ),
    );
  }

  Widget _buildBookList() {
    return SizedBox(
      height: 150,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 5,
        itemBuilder: (context, index) {
          return Container(
            width: 100,
            margin: const EdgeInsets.only(right: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 100,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    image: const DecorationImage(
                      image: AssetImage('assets/images/percy-book.jpg'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(height: 5),
                const Text(
                  'Book Title',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const Text(
                  '5 copies available',
                  style: TextStyle(fontSize: 10, color: Colors.grey),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
