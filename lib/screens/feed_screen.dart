import 'package:figure_gallery/services/post_service.dart';
import 'package:figure_gallery/widgets/post_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FeedScreen extends ConsumerWidget {
  const FeedScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final feedAsyncValue = ref.watch(feedProvider);

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
            return PostCard(post: posts[index]);
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
