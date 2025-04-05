import 'package:flutter/material.dart';

class LogoutModal extends StatelessWidget {
  final VoidCallback onLogout;
  final VoidCallback onCancel;

  const LogoutModal({
    super.key,
    required this.onLogout,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8), // Smaller border radius
      ),
      elevation: 8, // Reduced elevation for a more subtle floating effect
      backgroundColor: Colors
          .transparent, // Transparent background to create a pop-up effect
      child: ClipRRect(
        borderRadius: BorderRadius.circular(
            8), // Matching the border radius for consistency
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blueAccent.shade100, Colors.blue.shade700],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black
                    .withOpacity(0.15), // Softer shadow for modern look
                spreadRadius: 4,
                blurRadius: 12,
                offset: Offset(0, 3), // Subtle shadow offset
              ),
            ],
          ),
          padding: const EdgeInsets.all(
              16.0), // Adjusted padding for a more compact modal
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.exit_to_app,
                size: 40, // Slightly smaller icon for better balance
                color: Colors.white,
              ),
              const SizedBox(
                  height: 12), // Adjusted spacing for better alignment
              const Text(
                "Are you sure you want to log out?",
                style: TextStyle(
                  fontSize: 16, // Slightly smaller text for a more compact look
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
              const SizedBox(
                  height: 20), // Reduced spacing for a more compact modal
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: onCancel,
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      backgroundColor: Colors.grey[900]!.withOpacity(0.7),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            6), // Smaller button border radius
                      ),
                    ),
                    child: const Text(
                      "Cancel",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12), // Adjusted spacing between buttons
                  ElevatedButton(
                    onPressed: onLogout,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      backgroundColor: Colors.red.shade600,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            6), // Smaller button border radius
                      ),
                      elevation:
                          4, // Slightly reduced elevation for a smoother look
                    ),
                    child: const Text(
                      "Logout",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
