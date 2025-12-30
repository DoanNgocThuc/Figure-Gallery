import 'package:figure_gallery/models/Post.dart';
import 'package:figure_gallery/widgets/feed/post_card.dart';
import 'package:flutter/material.dart';

class PostDetailScreen extends StatelessWidget {
  final Post post;

  const PostDetailScreen({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(post.figureName)),
      body: SingleChildScrollView(child: PostCard(post: post)),
    );
  }
}
