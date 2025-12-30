import 'package:figure_gallery/models/Post.dart';
import 'package:figure_gallery/services/post_service.dart';
import 'package:figure_gallery/widgets/feed/post_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PostDetailScreen extends ConsumerWidget {
  final Post post;

  const PostDetailScreen({super.key, required this.post});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final postStream = ref.watch(postServiceProvider).getPostStream(post.id);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(title: Text(post.figureName)),
      body: StreamBuilder<Post>(
        stream: postStream,
        initialData: post,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return SingleChildScrollView(child: PostCard(post: snapshot.data!));
          }

          return Center(
            child: CircularProgressIndicator(color: Colors.redAccent),
          );
        },
      ),
    );
  }
}
