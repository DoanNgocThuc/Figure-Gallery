import 'package:figure_gallery/viewmodels/feed_viewmodel.dart';
import 'package:figure_gallery/widgets/feed/post_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FeedScreen extends ConsumerWidget {
  const FeedScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final feedAsyncValue = ref.watch(feedViewModelProvider);

    return feedAsyncValue.when(
      data: (posts) {
        if (posts.isEmpty) {
          return Center(
            child: Text("No posts yet", style: TextStyle(color: Colors.white)),
          );
        }
        return ListView.builder(
          padding: EdgeInsets.only(bottom: 100),
          itemCount: posts.length,
          itemBuilder: (context, index) {
            final post = posts[index];

            return PostCard(key: ValueKey(post.id), post: post);
          },
        );
      },
      error: (err, stack) => Center(
        child: Text("Error: $err", style: TextStyle(color: Colors.red)),
      ),
      loading: () =>
          Center(child: CircularProgressIndicator(color: Colors.redAccent)),
    );
  }
}
