import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/Post.dart';

final postRepositoryProvider = Provider((ref) => PostRepository());

class PostRepository {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  Stream<List<Post>> getFeedStream() {
    return _firestore
        .collection('posts')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((s) => s.docs.map((d) => Post.fromFirestore(d)).toList());
  }

  Stream<List<Post>> getUserPostsStream() {
    final String uid = _auth.currentUser!.uid;

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

  Future<void> addPost(Map<String, dynamic> data) async {
    await _firestore.collection('posts').add(data);
  }

  Future<void> toggleUpvote(String postId, List<String> currentUpvotes) async {
    final uid = _auth.currentUser?.uid;
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
}
