import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import '../viewmodels/upload_viewmodel.dart';

class UploadScreen extends ConsumerStatefulWidget {
  const UploadScreen({super.key});
  @override
  ConsumerState<UploadScreen> createState() => _UploadScreenState();
}

class _UploadScreenState extends ConsumerState<UploadScreen> {
  final _nameController = TextEditingController();
  final _descController = TextEditingController();
  List<XFile> _images = [];

  void _listenToState() {
    ref.listen(uploadViewModelProvider, (previous, next) {
      next.when(
        data: (_) => Navigator.pop(context),
        error: (err, stack) => ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("$err"))),
        loading: () {},
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    _listenToState();

    final uploadState = ref.watch(uploadViewModelProvider);
    final isLoading = uploadState.isLoading;

    return Scaffold(
      appBar: AppBar(title: Text("Upload Pose")),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: "Name"),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _descController,
              decoration: InputDecoration(labelText: "Desc"),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final picker = ImagePicker();
                final imgs = await picker.pickMultiImage();
                setState(() => _images = imgs);
              },
              child: Text("Pick Images (${_images.length})"),
            ),
            SizedBox(height: 20),

            isLoading
                ? CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: () {
                      if (_images.isEmpty) return;
                      ref
                          .read(uploadViewModelProvider.notifier)
                          .uploadAndPost(
                            name: _nameController.text,
                            desc: _descController.text,
                            images: _images,
                          );
                    },
                    child: Text("Submit"),
                  ),
          ],
        ),
      ),
    );
  }
}
