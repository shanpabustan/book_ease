import 'package:flutter/material.dart';
import 'package:book_ease/screens/user/user_nav.dart';
import 'package:book_ease/screens/user/library_screen.dart';
import 'package:book_ease/screens/user/mybooks_screen.dart';
import 'package:book_ease/screens/user/profile_screen.dart';
import 'package:book_ease/widgets/appbar_widget.dart';
import 'package:book_ease/widgets/notification_widget.dart';
import 'package:book_ease/data/userdashbook_data.dart';
import 'package:book_ease/data/notification_data.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const UserDashApp());
}

class UserDashApp extends StatefulWidget {
  const UserDashApp({super.key});

  @override
  _UserDashAppState createState() => _UserDashAppState();
}

// ===================== Bottom Navigation =====================
class _UserDashAppState extends State<UserDashApp> {
  int _selectedIndex = 0;

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
      theme: ThemeData(
        primarySwatch: Colors.teal,
        fontFamily: GoogleFonts.poppins().fontFamily,
      ),
      home: Scaffold(
        body: _pages[_selectedIndex],
        bottomNavigationBar: NavigationBarWidget(
          selectedIndex: _selectedIndex,
          onTabChange: _onTabChange,
        ),
      ),
    );
  }
}

// ===================== Home Screen =====================
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _showNotifications = false;
  final TextEditingController _searchController = TextEditingController();

  void _toggleNotificationOverlay() {
    setState(() {
      _showNotifications = !_showNotifications;
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: AppBarWidget(
            onNotificationPressed: _toggleNotificationOverlay,
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSectionTitle('Explore Library Books'),
                _buildBanner(),
                const SizedBox(height: 25),
                _buildCategoryIcons(),
                const SizedBox(height: 10),
                _buildBookSection(context, 'Recommendations'),
                _buildBookSection(context, 'Trending Books'),
                _buildBookSection(context, 'Borrowed Books'),
              ],
            ),
          ),
        ),

        // Notification Overlay
        if (_showNotifications)
          NotificationOverlay(
            onClose: _toggleNotificationOverlay,
            notifications: dummyNotifications,
          ),
      ],
    );
  }

  // ===================== UI Components =====================
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildBanner() {
    return Container(
      height: 180,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        image: const DecorationImage(
          image: AssetImage('assets/images/banner.jpg'),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildCategoryIcons() {
    final List<Map<String, dynamic>> categories = [
      {"icon": Icons.computer_rounded, "label": "Technology"},
      {"icon": Icons.calculate, "label": "Mathematics"},
      {"icon": Icons.psychology, "label": "Psychology"},
      {"icon": Icons.balance, "label": "Physics"},
      {"icon": Icons.science, "label": "Chemistry"},
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: categories
            .map((cat) => _buildCategoryIcon(
                cat["icon"] as IconData, cat["label"] as String))
            .toList(),
      ),
    );
  }

  Widget _buildCategoryIcon(IconData icon, String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        children: [
          Icon(icon, size: 40, color: Colors.teal),
          FittedBox(
            child: Text(
              label,
              style: GoogleFonts.poppins(fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBookSection(BuildContext context, String category) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(context, category),
        _buildBookList(category),
      ],
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style:
                GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SeeAllScreen(category: title),
                ),
              );
            },
            child: Text(
              'See All',
              style: GoogleFonts.poppins(color: Colors.teal),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBookList(String category) {
    final books = getBooks(category);

    return SizedBox(
      height: 150,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: books.length,
        itemBuilder: (context, index) {
          final book = books[index];
          return _buildBookTile(
            book["title"]!,
            book["copies"]!,
            book["image"]!,
          );
        },
      ),
    );
  }

  Widget _buildBookTile(String title, String copies, String imagePath) {
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
              image: DecorationImage(
                image: AssetImage(imagePath),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: 5),
          Text(
            title,
            style:
                GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.bold),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            copies,
            style: GoogleFonts.poppins(fontSize: 10, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}

// ===================== See All Screen =====================
class SeeAllScreen extends StatelessWidget {
  final String category;
  const SeeAllScreen({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(category)),
      body: Center(child: Text('Display all books for $category')),
    );
  }
}
