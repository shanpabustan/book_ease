import 'package:flutter/material.dart';

// Define your reusable color constants here
class AdminColor {
  // Text Colors
  static const Color primaryTextColor = Color.fromRGBO(0, 0, 0, 1); // Black
  static const Color secondaryTextColor =
      Color.fromRGBO(255, 255, 255, 1); // White
  static const Color tertiaryTextColor =
      Color.fromRGBO(49, 120, 115, 1); // Green

  // Background Colors
  static const Color primaryBackgroundColor =
      Color.fromRGBO(250, 250, 250, 1); // Light background color
  static const Color secondaryBackgroundColor =
      Color.fromRGBO(49, 120, 115, 1); // Secondary color
  static const Color tertiaryBackgroundColor = Color.fromRGBO(110, 107, 107, 1);
// Grey color
  static const Color sidebarBackgroundColor = Color.fromRGBO(51, 53, 54, 1);

  // Border Colors
  static const Color borderColor =
      Color.fromRGBO(220, 220, 220, 1); // Light gray border
}

class AdminFontSize {
  static const double heading = 24.0;
  static const double subHeading = 18.0;
  static const double bodyText = 14.0;
  static const double labelText = 16.0;
  static const double buttonText = 16.0;
}

class AdminTextStyle {
  // Heading style
  static TextStyle heading() {
    return TextStyle(
      fontSize: AdminFontSize.heading,
      fontWeight: FontWeight.bold,
      color: AdminColor.primaryTextColor,
    );
  }

  // Subheading style
  static TextStyle subHeading() {
    return TextStyle(
      fontSize: AdminFontSize.subHeading,
      fontWeight: FontWeight.w600,
      color: AdminColor.primaryTextColor,
    );
  }

  // Body text style
  static TextStyle bodyText() {
    return TextStyle(
      fontSize: AdminFontSize.bodyText,
      fontWeight: FontWeight.normal,
      color: AdminColor.secondaryTextColor,
    );
  }

  // Label text style
  static TextStyle labelText() {
    return TextStyle(
      fontSize: AdminFontSize.labelText,
      fontWeight: FontWeight.normal,
      color: AdminColor.secondaryTextColor,
    );
  }

  // Button text style
  static TextStyle buttonText() {
    return TextStyle(
      fontSize: AdminFontSize.buttonText,
      fontWeight: FontWeight.w600,
      color: AdminColor.tertiaryTextColor, // White color for button text
    );
  }
}

// Usage example:

class AdminPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          AdminColor.primaryBackgroundColor, // Using primary background color
      appBar: AppBar(
        title: Text(
          'Admin Page',
          style: AdminTextStyle.heading(), // Using heading text style
        ),
        backgroundColor: AdminColor
            .secondaryBackgroundColor, // Using secondary background color
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Welcome to the Admin Page',
              style: AdminTextStyle.subHeading(), // Using subheading text style
            ),
            SizedBox(height: 20),
            Container(
              padding: EdgeInsets.all(16),
              color: AdminColor
                  .secondaryBackgroundColor, // Using secondary background color
              child: Text(
                'This is a sample container',
                style: AdminTextStyle.bodyText(), // Using body text style
              ),
            ),
          ],
        ),
      ),
    );
  }
}
