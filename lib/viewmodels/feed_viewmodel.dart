import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../repositories/post_repository.dart';
import '../models/Post.dart';

final feedViewModelProvider = StreamProvider<List<Post>>((ref) {
  return ref.read(postRepositoryProvider).getFeedStream();
});
