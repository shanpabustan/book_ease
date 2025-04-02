import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:permission_handler/permission_handler.dart';

class ChangeProfilePhotoScreen extends StatefulWidget {
  final Function(File?) onImagePicked;

  const ChangeProfilePhotoScreen({super.key, required this.onImagePicked});

  @override
  _ChangeProfilePhotoScreenState createState() =>
      _ChangeProfilePhotoScreenState();
}

class _ChangeProfilePhotoScreenState extends State<ChangeProfilePhotoScreen> {
  bool _isPickingImage = false; // Prevents multiple selections

  // Request permissions for camera and gallery
  Future<bool> _requestPermission(ImageSource source) async {
    if (source == ImageSource.camera) {
      var status = await Permission.camera.request();
      if (status.isDenied || status.isPermanentlyDenied) {
        _showPermissionDialog("Camera");
        return false;
      }
    } else if (source == ImageSource.gallery) {
      var status = await Permission.photos.request();
      if (status.isDenied || status.isPermanentlyDenied) {
        _showPermissionDialog("Gallery");
        return false;
      }
    }
    return true;
  }

  // Show permission dialog if denied
  void _showPermissionDialog(String type) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("$type Permission Required"),
        content: Text("Please enable $type access in settings to proceed."),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel")),
          TextButton(
            onPressed: () {
              openAppSettings();
              Navigator.pop(context);
            },
            child: const Text("Open Settings"),
          ),
        ],
      ),
    );
  }

  // Function to pick an image
  Future<void> _pickImage(ImageSource source) async {
    if (_isPickingImage) return; // Prevent multiple taps
    setState(() => _isPickingImage = true); // Lock selection

    bool permissionGranted = await _requestPermission(source);
    if (!permissionGranted) {
      setState(() => _isPickingImage = false);
      return;
    }

    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);
    if (pickedFile != null) {
      widget.onImagePicked(File(pickedFile.path)); // Return selected image
      Navigator.pop(context); // Close bottom sheet
    }

    setState(() => _isPickingImage = false); // Unlock selection
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pop(context),
      child: Container(
        color: Colors.black.withOpacity(0.4),
        child: DraggableScrollableSheet(
          initialChildSize: 0.35,
          minChildSize: 0.3,
          maxChildSize: 0.6,
          builder: (context, scrollController) {
            return Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Column(
                children: [
                  // Drag Indicator
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Container(
                      height: 5,
                      width: 50,
                      decoration: BoxDecoration(
                        color: Colors.grey[400],
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),

                  // Title
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Center(
                      child: Text(
                        "Change Profile Photo",
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.teal,
                        ),
                      ),
                    ),
                  ),

                  // Options to pick image
                  Expanded(
                    child: ListView(
                      controller: scrollController,
                      children: [
                        _buildPhotoOptionButton(
                          Icons.camera_alt,
                          "Take a Photo",
                          ImageSource.camera,
                        ),
                        _buildPhotoOptionButton(
                          Icons.photo_library,
                          "Choose from Gallery",
                          ImageSource.gallery,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  // Helper method to build the option buttons
  Widget _buildPhotoOptionButton(
      IconData icon, String label, ImageSource source) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
      child: ElevatedButton.icon(
        onPressed: _isPickingImage
            ? null
            : () => _pickImage(source), // Disable if busy
        icon: Icon(icon, color: Colors.white),
        label: Text(label),
        style: ElevatedButton.styleFrom(
          backgroundColor: _isPickingImage ? Colors.grey : Colors.teal,
          foregroundColor: Colors.white,
          minimumSize: const Size(double.infinity, 50),
        ),
      ),
    );
  }
}
