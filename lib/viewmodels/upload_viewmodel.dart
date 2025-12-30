import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import '../repositories/post_repository.dart';
import '../services/cloudinary_service.dart'; // Keep this as a service helper
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final uploadViewModelProvider = AsyncNotifierProvider<UploadViewModel, void>(
  () {
    return UploadViewModel();
  },
);

class UploadViewModel extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  Future<void> uploadAndPost({
    required String name,
    required String desc,
    required List<XFile> images,
  }) async {
    state = const AsyncValue.loading();

    try {
      final imageUrls = await CloudinaryService().uploadImages(images);
      final user = FirebaseAuth.instance.currentUser;

      final postData = {
        'figureName': name,
        'description': desc,
        'images': imageUrls,
        'userId': user?.uid,
        'userEmail': user?.email,
        'upvotes': [],
        'timestamp': FieldValue.serverTimestamp(),
      };

      await ref.read(postRepositoryProvider).addPost(postData);

      state = const AsyncValue.data(null);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }
}
