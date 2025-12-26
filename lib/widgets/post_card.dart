import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class PostCard extends StatefulWidget {
  final QueryDocumentSnapshot post;
  const PostCard({super.key, required this.post});

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    List<dynamic> images = widget.post['images'];

    return Container(
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 0),
      color: Color(0xFF1C1C1C),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(12),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.redAccent,
                  child: Text(
                    widget.post['userEmail'][0].toUpperCase(),
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.post['figureName'],
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      widget.post['userEmail'].split('@')[0],
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
                    itemCount: images.length,
                    onPageChanged: (idx) => setState(() => _currentIndex = idx),
                    itemBuilder: (ctx, i) {
                      return CachedNetworkImage(
                        imageUrl: images[i],
                        fit: BoxFit.contain,

                        placeholder: (c, u) => Center(
                          child: CircularProgressIndicator(
                            color: Colors.redAccent,
                          ),
                        ),
                        errorWidget: (context, url, error) =>
                            Icon(Icons.error, color: Colors.red),
                      );
                    },
                  ),
                  if (images.length > 1)
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
                            color: Colors.redAccent.withValues(alpha: 0.5),
                          ),
                        ),
                        child: Text(
                          "${_currentIndex + 1}/${images.length}",
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
            padding: EdgeInsets.all(12),
            child: Text(
              widget.post['description'],
              style: TextStyle(color: Colors.grey[300]),
            ),
          ),
        ],
      ),
    );
  }
}
