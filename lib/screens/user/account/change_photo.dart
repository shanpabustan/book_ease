import 'package:book_ease/provider/user_data.dart';
import 'package:flutter/material.dart';
import 'dart:io'; // Required for mobile file handling
import 'package:image_picker/image_picker.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:typed_data'; // Required for handling file data on web
import 'package:provider/provider.dart';


class ChangeProfilePhotoScreen extends StatefulWidget {
  final Function(File?) onImagePicked; // For mobile
  final Function(Uint8List?) onImagePickedWeb; // For web

  const ChangeProfilePhotoScreen({
    super.key,
    required this.onImagePicked,
    required this.onImagePickedWeb, required String userId,
  });

  @override
  _ChangeProfilePhotoScreenState createState() => _ChangeProfilePhotoScreenState();
}

class _ChangeProfilePhotoScreenState extends State<ChangeProfilePhotoScreen> {
  bool _isPickingImage = false;
  final Dio _dio = Dio(); // Dio for API requests

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

  void _showPermissionDialog(String type) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("$type Permission Required"),
        content: Text("Please enable $type access in settings to proceed."),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
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

  // 📸 Mobile Image Picker
  Future<void> _pickImageMobile(ImageSource source) async {
    if (_isPickingImage) return;
    setState(() => _isPickingImage = true);

    bool permissionGranted = await _requestPermission(source);
    if (!permissionGranted) {
      setState(() => _isPickingImage = false);
      return;
    }

    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);
    if (pickedFile != null) {
      File imageFile = File(pickedFile.path);
      widget.onImagePicked(imageFile); // Call function for mobile
      _uploadImage(imageFile);
    }

    setState(() => _isPickingImage = false);
  }

  // 🌐 Web Image Picker
  Future<void> _pickImageWeb() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
    );

    if (result != null) {
      Uint8List fileBytes = result.files.first.bytes!;
      String fileName = result.files.first.name;

      print("File selected: $fileName");

      widget.onImagePickedWeb(fileBytes); // Call function for web
      _uploadImageWeb(fileBytes, fileName);
      Navigator.pop(context);
    } else {
      print("No image selected");
    }
  }

  // 📤 Upload Image (Mobile)
  Future<void> _uploadImage(File imageFile) async {
    String userId = Provider.of<UserData>(context, listen: false).userID; // Fetch user_id from provider
    String apiUrl = "http://127.0.0.1:5566/stud/add-pic";
    FormData formData = FormData.fromMap({
      "user_id": userId, // Pass user_id from provider
      "picture": await MultipartFile.fromFile(imageFile.path, filename: "profile.jpg"),
    });

    try {
      Response response = await _dio.post(
        apiUrl,
        data: formData,
        options: Options(
          headers: {"Content-Type": "multipart/form-data"}, // Explicit content-type
        ),
      );
      if (response.statusCode == 200) {
        print("Profile picture uploaded successfully");
      } else {
        print("Failed to upload image: ${response.data}");
      }
    } catch (e) {
      print("Error uploading image: $e");
    }
  }

  // 📤 Upload Image (Web)
  Future<void> _uploadImageWeb(Uint8List fileBytes, String fileName) async {
    String userId = Provider.of<UserData>(context, listen: false).userID; // Fetch user_id from provider
    String apiUrl = "http://127.0.0.1:5566/stud/add-pic";
    FormData formData = FormData.fromMap({
      "user_id": userId, // Pass user_id from provider
      "picture": MultipartFile.fromBytes(fileBytes, filename: fileName),
    });

    try {
      Response response = await _dio.post(
        apiUrl,
        data: formData,
        options: Options(
          headers: {"Content-Type": "multipart/form-data"}, // Explicit content-type
        ),
      );
      if (response.statusCode == 200) {
        print("Profile picture uploaded successfully");
      } else {
        print("Failed to upload image: ${response.data}");
      }
    } catch (e) {
      print("Error uploading image: $e");
    }
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
                  Expanded(
                    child: ListView(
                      controller: scrollController,
                      children: [
                        _buildPhotoOptionButton(
                          Icons.camera_alt,
                          "Take a Photo",
                          () => _pickImageMobile(ImageSource.camera), // Mobile Camera
                        ),
                        _buildPhotoOptionButton(
                          Icons.photo_library,
                          "Choose from Gallery",
                          () => _pickImageWeb(), // Web Image Picker
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

  Widget _buildPhotoOptionButton(IconData icon, String label, VoidCallback onPressed) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
      child: ElevatedButton.icon(
        onPressed: _isPickingImage ? null : onPressed,
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
