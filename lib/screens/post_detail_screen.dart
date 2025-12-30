import 'package:figure_gallery/widgets/feed/post_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/Post.dart';
import '../viewmodels/post_detail_viewmodel.dart'; // Import the new ViewModel

class PostDetailScreen extends ConsumerWidget {
  final Post post;

  const PostDetailScreen({super.key, required this.post});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final postAsync = ref.watch(postDetailProvider(post.id));

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(title: Text(post.figureName)),
      body: postAsync.when(
        data: (livePost) {
          return SingleChildScrollView(child: PostCard(post: livePost));
        },

        loading: () {
          return SingleChildScrollView(child: PostCard(post: post));
        },

        error: (err, stack) => Center(
          child: Text("Error: $err", style: TextStyle(color: Colors.red)),
        ),
      ),
    );
  }
}
