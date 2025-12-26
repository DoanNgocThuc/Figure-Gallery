import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/cloudinary_service.dart';

class UploadScreen extends StatefulWidget {
  const UploadScreen({super.key});

  @override
  State<UploadScreen> createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  final _nameController = TextEditingController();
  final _descController = TextEditingController();
  List<XFile> _images = [];
  bool _isUploading = false;

  Future<void> _pickImages() async {
    final ImagePicker picker = ImagePicker();
    final List<XFile> selected = await picker.pickMultiImage();
    setState(() => _images = selected);
  }

  Future<void> _submit() async {
    if (_nameController.text.isEmpty || _images.isEmpty) return;

    setState(() => _isUploading = true);

    // 1. Upload to Cloudinary
    List<String> imageUrls = await CloudinaryService().uploadImages(_images);

    // 2. Save Data to Firestore
    User? user = FirebaseAuth.instance.currentUser;
    await FirebaseFirestore.instance.collection('posts').add({
      'figureName': _nameController.text,
      'description': _descController.text,
      'images': imageUrls,
      'userId': user?.uid,
      'userEmail': user?.email,
      'timestamp': FieldValue.serverTimestamp(),
    });

    setState(() => _isUploading = false);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Upload Pose")),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: "Figure Name"),
            ),
            TextField(
              controller: _descController,
              decoration: InputDecoration(labelText: "Description"),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _pickImages,
              child: Text("Select Images (${_images.length})"),
            ),
            SizedBox(height: 20),
            _isUploading
                ? CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: _submit,
                    child: Text("Post Gallery"),
                  ),
          ],
        ),
      ),
    );
  }
}
