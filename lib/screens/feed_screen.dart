import 'package:figure_gallery/models/Post.dart';
import 'package:figure_gallery/widgets/post_card.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FeedScreen extends StatelessWidget {
  const FeedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('posts')
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(color: Colors.redAccent),
            );
          }

          return ListView.builder(
            padding: EdgeInsets.only(bottom: 80, left: 10, right: 10),

            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              Post post = Post.fromFirestore(snapshot.data!.docs[index]);

              return TweenAnimationBuilder(
                tween: Tween<double>(begin: 0, end: 1),
                duration: Duration(milliseconds: 500 + (index * 100)),
                curve: Curves.easeOut,
                builder: (context, double val, child) {
                  return Transform.translate(
                    offset: Offset(0, 50 * (1 - val)),
                    child: Opacity(opacity: val, child: child),
                  );
                },
                child: PostCard(post: post),
              );
            },
          );
        },
      ),
    );
  }
}
