import 'package:flutter/material.dart';

class AppBarWidget extends StatelessWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;

  AppBarWidget({required this.scaffoldKey});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4, // Adds shadow for depth
      margin: EdgeInsets.all(10), // Adds spacing around the card
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15), // Rounded corners
      ),
      color: Colors.white, // 🔹 Background color changed to white
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Left Side - Welcome Message
            Row(
              children: [
                if (MediaQuery.of(context).size.width < 800)
                  IconButton(
                    icon: Icon(Icons.menu, color: Colors.black87),
                    onPressed: () {
                      scaffoldKey.currentState?.openDrawer();
                    },
                  ),
                Text(
                  "Welcome to the Admin Dashboard",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),

            // Right Side - Profile & Notifications
            Row(
              children: [
                // Notifications Icon with Badge
                Stack(
                  children: [
                    IconButton(
                      icon: Icon(Icons.notifications, color: Colors.black87),
                      onPressed: () {
                        // Handle notification tap
                      },
                    ),
                    Positioned(
                      right: 8,
                      top: 8,
                      child: CircleAvatar(
                        backgroundColor: Colors.red,
                        radius: 6,
                        child: Text(
                          '3', // Sample notification count
                          style: TextStyle(fontSize: 10, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),

                // Profile Avatar
                Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: CircleAvatar(
                    radius: 20,
                    backgroundImage: AssetImage(
                        'assets/images/bini.jpg'), // Change to actual path
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
