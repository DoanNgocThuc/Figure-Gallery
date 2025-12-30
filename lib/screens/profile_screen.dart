import 'package:figure_gallery/screens/post_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../models/Post.dart';
import '../../viewmodels/profile_viewmodel.dart';
import '../../widgets/profile/stat_card.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final postsAsync = ref.watch(profilePostsProvider);
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) return Center(child: Text("Please Login"));

    return Scaffold(
      backgroundColor: Colors.black,
      body: postsAsync.when(
        loading: () =>
            Center(child: CircularProgressIndicator(color: Colors.redAccent)),
        error: (err, stack) => Center(
          child: Text("Error: $err", style: TextStyle(color: Colors.white)),
        ),
        data: (posts) {
          final int figureCount = posts.length;
          final int totalLikes = posts.fold(
            0,
            (sum, post) => sum + post.upvotes.length,
          );

          return SingleChildScrollView(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                SizedBox(height: 20),
                CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.redAccent,
                  child: Text(
                    user.email![0].toUpperCase(),
                    style: TextStyle(
                      fontSize: 40,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  user.email!.split('@')[0],
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  user.email!,
                  style: TextStyle(color: Colors.grey, fontSize: 14),
                ),

                SizedBox(height: 20),

                Row(
                  children: [
                    StatCard(
                      title: "Figures",
                      stat: figureCount.toString(),
                      icon: Icons.accessibility_new,
                    ),
                    SizedBox(width: 10),
                    StatCard(
                      title: "Total Likes",
                      stat: totalLikes.toString(),
                      icon: Icons.favorite,
                    ),
                  ],
                ),

                SizedBox(height: 20),
                Divider(color: Colors.grey.shade800),

                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "My Collection",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 10),

                _buildGrid(context, posts),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildGrid(BuildContext context, List<Post> posts) {
    if (posts.isEmpty) {
      return Padding(
        padding: const EdgeInsets.only(top: 40),
        child: Text(
          "No figures uploaded yet.",
          style: TextStyle(color: Colors.grey),
        ),
      );
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 2,
        mainAxisSpacing: 2,
      ),
      itemCount: posts.length,
      itemBuilder: (context, index) {
        final post = posts[index];
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => PostDetailScreen(post: post)),
            );
          },
          child: Container(
            decoration: BoxDecoration(
              color: Color(0xFF1C1C1C),
              image: DecorationImage(
                image: CachedNetworkImageProvider(post.images[0]),
                fit: BoxFit.cover,
              ),
            ),
          ),
        );
      },
    );
  }
}
