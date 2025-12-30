import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/Post.dart';
import '../repositories/post_repository.dart';

final postDetailProvider = StreamProvider.family<Post, String>((ref, postId) {
  return ref.read(postRepositoryProvider).getPostStream(postId);
});
