import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class AddUser extends StatelessWidget {
  const AddUser({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add User"),
        backgroundColor: Colors.blueGrey[700],
      ),
      body: Center(
        child: ElevatedButton(
            onPressed: () {
            // Button pressed logic here
            print("Button pressed");
            }, child: null,
        ),
      ),
    );
  }
}


