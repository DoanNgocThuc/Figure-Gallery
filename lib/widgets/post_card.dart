import 'package:cached_network_image/cached_network_image.dart';
import 'package:figure_gallery/models/Post.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:figure_gallery/services/post_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/post_service.dart';

class PostCard extends ConsumerStatefulWidget {
  final Post post;
  const PostCard({super.key, required this.post});

  @override
  ConsumerState<PostCard> createState() => _PostCardState();
}

class _PostCardState extends ConsumerState<PostCard> {
  int _currentIndex = 0;
  final currentUser = FirebaseAuth.instance.currentUser;

  bool get isLiked =>
      currentUser != null && widget.post.upvotes.contains(currentUser?.uid);
  int get likeCount => widget.post.upvotes.length;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final int likeCount = widget.post.upvotes.length;

    return Container(
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 0),
      decoration: BoxDecoration(
        color: Color(0xFF1C1C1C),
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(12),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: colorScheme.primary,
                  child: Text(
                    widget.post.userEmail.toUpperCase()[0],
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.post.figureName,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      widget.post.userEmail.split('@')[0],
                      style: TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Center(
            child: Container(
              height: 400,
              width: 400,
              color: Colors.black,
              child: Stack(
                children: [
                  PageView.builder(
                    itemCount: widget.post.images.length,
                    onPageChanged: (idx) => setState(() => _currentIndex = idx),
                    itemBuilder: (ctx, i) {
                      return CachedNetworkImage(
                        imageUrl: widget.post.images[i],
                        fit: BoxFit.contain,

                        placeholder: (c, u) => Center(
                          child: CircularProgressIndicator(
                            color: colorScheme.primary,
                          ),
                        ),
                        errorWidget: (context, url, error) =>
                            Icon(Icons.error, color: Colors.red),
                      );
                    },
                  ),
                  if (widget.post.images.length > 1)
                    Positioned(
                      top: 10,
                      right: 10,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.7),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: colorScheme.primary.withValues(alpha: 0.5),
                          ),
                        ),
                        child: Text(
                          "${_currentIndex + 1}/${widget.post.images.length}",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),

          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              children: [
                IconButton(
                  icon: Icon(
                    isLiked ? Icons.favorite : Icons.favorite_border,
                    color: isLiked ? Colors.redAccent : Colors.grey,
                    size: 28,
                  ),
                  onPressed: () {
                    ref
                        .read(postServiceProvider)
                        .toggleUpvote(widget.post.id, widget.post.upvotes);
                  },
                ),
                Text(
                  "$likeCount likes",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          Padding(
            padding: EdgeInsets.all(12),
            child: Text(
              widget.post.description,
              style: TextStyle(color: Colors.grey[300]),
            ),
          ),
        ],
      ),
    );
  }
}
