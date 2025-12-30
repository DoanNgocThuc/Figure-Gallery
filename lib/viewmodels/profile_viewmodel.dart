import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/Post.dart';
import '../repositories/post_repository.dart';

final profilePostsProvider = StreamProvider.autoDispose<List<Post>>((ref) {
  return ref.read(postRepositoryProvider).getUserPostsStream();
});
