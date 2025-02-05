import 'package:flutter/material.dart';
import 'package:twizzy/models/post_model.dart';
import 'package:twizzy/services/api_service.dart';
import 'package:twizzy/widgets/blog_post_card.dart';
import 'package:twizzy/widgets/add_post_dialog.dart';

class BlogScreen extends StatefulWidget {
  @override
  _BlogScreenState createState() => _BlogScreenState();
}

class _BlogScreenState extends State<BlogScreen> {
  List<Post> blogPosts = [];
  List<List<String>> comments = [];

  @override
  void initState() {
    super.initState();
    fetchBlogPosts();
  }

  Future<void> fetchBlogPosts() async {
    final posts = await ApiService.fetchBlogPost();
    setState(() {
      blogPosts = posts;
      comments = List.generate(posts.length, (index) => []);
    });
  }

  Future<void> addNewPost(String content) async {
    await ApiService.addBlogPost(content);
    fetchBlogPosts();
  }

  void showAddPostDialog() {
    showDialog(
      context: context,
      builder: (context) => AddPostDialog(onPostAdded: addNewPost),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Blog"),
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () => Navigator.pushReplacementNamed(context, '/profile'),
          ),
        ],
        backgroundColor: Colors.blueAccent,
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        onPressed: showAddPostDialog,
        child: Icon(Icons.add, color: Colors.white),
      ),
      body: ListView.builder(
        itemCount: blogPosts.length,
        itemBuilder: (context, index) {
          return BlogPostCard(
            post: blogPosts[index],
            onCommentAdded: (comment) {
              setState(() {
                comments[index].add(comment);
              });
            },
            comments: comments[index],
          );
        },
      ),
    );
  }
}
