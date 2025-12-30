import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:figure_gallery/services/cloudinary_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:riverpod/riverpod.dart';
import '../models/Post.dart';

// Provides the PostService instance
final postServiceProvider = Provider<PostService>((ref) {
  return PostService(FirebaseFirestore.instance, FirebaseAuth.instance);
});

// Stream for the Global Feed
final feedProvider = StreamProvider<List<Post>>((ref) {
  debugPrint("Here");
  return ref.read(postServiceProvider).getFeedStream();
});

// Stream for the Current User's Profile
final userPostsProvider = StreamProvider<List<Post>>((ref) {
  return ref.read(postServiceProvider).getUserPostsStream();
});

class PostService {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  PostService(this._firestore, this._auth);

  String? get _currentUserId => _auth.currentUser?.uid;

  // --- READS ---
  Stream<List<Post>> getFeedStream() {
    return _firestore
        .collection('posts')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) => Post.fromFirestore(doc)).toList();
        });
  }

  Stream<List<Post>> getUserPostsStream() {
    final uid = _currentUserId;
    if (uid == null) return Stream.value([]);

    return _firestore
        .collection('posts')
        .where('userId', isEqualTo: uid)
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) => Post.fromFirestore(doc)).toList();
        });
  }

  Stream<Post> getPostStream(String postId) {
    return _firestore
        .collection('posts')
        .doc(postId)
        .snapshots()
        .map((doc) => Post.fromFirestore(doc));
  }

  // --- WRITES ---
  Future<void> toggleUpvote(String postId, List<String> currentUpvotes) async {
    final uid = _currentUserId;
    if (uid == null) return;

    final docRef = _firestore.collection('posts').doc(postId);

    if (currentUpvotes.contains(uid)) {
      await docRef.update({
        'upvotes': FieldValue.arrayRemove([uid]),
      });
    } else {
      await docRef.update({
        'upvotes': FieldValue.arrayUnion([uid]),
      });
    }
  }

  Future<void> addPost({
    required String figureName,
    required String description,
    required List<String> imageUrls,
  }) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception("User not logged in");

    await _firestore.collection('posts').add({
      'userId': user.uid,
      'userEmail': user.email,
      'figureName': figureName,
      'description': description,
      'images': imageUrls,
      'upvotes': [],
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  Future<void> deletePost(Post post) async {
    try {
      final cloudinaryService = CloudinaryService();
      await cloudinaryService.deleteImages(post.images);

      await _firestore.collection('posts').doc(post.id).delete();
    } catch (e) {
      debugPrint("Delete failed: $e");
      rethrow;
    }
  }
}
