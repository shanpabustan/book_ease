import 'package:flutter/material.dart';

class SearchAdmin extends StatelessWidget {
  final String hintText;
  final ValueChanged<String>? onChanged;
  final TextEditingController? controller;

  // Define secondaryTextColor as a static constant for reusability
  static const Color secondaryTextColor = Colors.grey;

  const SearchAdmin({
    Key? key,
    this.hintText = 'Search...',
    this.onChanged,
    this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300,
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        style: const TextStyle(color: Colors.black), // Text color set to black
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: const TextStyle(
              color: Colors.grey), // Optional: change hint text color
          prefixIcon: const Icon(Icons.search),
          contentPadding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 5), // Adjusted vertical padding to match button
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide:
                BorderSide(color: secondaryTextColor), // Default border color
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide:
                BorderSide(color: secondaryTextColor), // Focused border color
          ),
        ),
      ),
    );
  }
}
