import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import '../services/cloudinary_service.dart';
import '../services/post_service.dart';

class UploadScreen extends ConsumerStatefulWidget {
  const UploadScreen({super.key});

  @override
  ConsumerState<UploadScreen> createState() => _UploadScreenState();
}

class _UploadScreenState extends ConsumerState<UploadScreen> {
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

    try {
      List<String> imageUrls = await CloudinaryService().uploadImages(_images);
      await ref
          .read(postServiceProvider)
          .addPost(
            figureName: _nameController.text,
            description: _descController.text,
            imageUrls: imageUrls,
          );

      if (mounted) {
        setState(() => _isUploading = false);
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isUploading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Upload failed: $e"),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Upload Pose")),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _nameController,
                decoration: InputDecoration(labelText: "Figure Name"),
              ),
              SizedBox(height: 10),
              TextField(
                controller: _descController,
                decoration: InputDecoration(labelText: "Description"),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _pickImages,
                child: Text("Select Images (${_images.length})"),
              ),

              // Image Preview (Optional but helpful)
              if (_images.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Text(
                    "${_images.length} images selected",
                    style: TextStyle(color: Colors.green),
                  ),
                ),

              SizedBox(height: 20),
              _isUploading
                  ? CircularProgressIndicator(color: Colors.redAccent)
                  : ElevatedButton(
                      onPressed: _submit,
                      child: Text("Post Gallery"),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
