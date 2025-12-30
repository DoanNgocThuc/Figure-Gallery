import 'package:figure_gallery/repositories/post_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PostActionViewModel {
  final WidgetRef ref;
  PostActionViewModel(this.ref);

  Future<void> toggleUpvote(String postId, List<String> upvotes) async {
    // Logic delegated to Repository
    await ref.read(postRepositoryProvider).toggleUpvote(postId, upvotes);
  }
}
