import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  final String id;
  final String userId;
  final String userEmail;
  final String figureName;
  final String description;
  final List<String> images;
  final DateTime timestamp;
  final List<String> upvotes;

  Post({
    required this.id,
    required this.userId,
    required this.userEmail,
    required this.description,
    required this.figureName,
    required this.timestamp,
    required this.images,
    required this.upvotes,
  });

  factory Post.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    return Post(
      id: doc.id,
      userId: data['userId'] ?? '',
      userEmail: data['userEmail'] ?? '',
      description: data['description'] ?? '',
      figureName: data['figureName'] ?? '',
      images: List<String>.from(data['images'] ?? []),
      timestamp: (data['timestamp'] as Timestamp?)?.toDate() ?? DateTime.now(),
      upvotes: List<String>.from(data['upvotes'] ?? []),
    );
  }
}
