import 'package:flutter/material.dart';
import 'package:twizzy/models/post_model.dart';
import 'package:twizzy/services/api_service.dart';
import 'package:twizzy/widgets/blog_post_card.dart';
import 'package:twizzy/widgets/add_post_dialog.dart';
import 'package:twizzy/widgets/search_bar_widget.dart';

class BlogScreen extends StatefulWidget {
  @override
  _BlogScreenState createState() => _BlogScreenState();
}

class _BlogScreenState extends State<BlogScreen> {
  List<Post> blogPosts = [];
  List<Post> filteredPosts = [];
  List<List<String>> comments = [];
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchBlogPosts();
    searchController.addListener(_filterPosts);
  }

  Future<void> fetchBlogPosts() async {
    final posts = await ApiService.fetchBlogPost();
    setState(() {
      blogPosts = posts;
      filteredPosts = posts;
      comments = List.generate(posts.length, (index) => []);
    });
  }

  void _filterPosts() {
    String query = searchController.text.toLowerCase();
    setState(() {
      filteredPosts = blogPosts
          .where((post) => post.content.toLowerCase().contains(query))
          .toList();
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
        title: Text("Blog", style: TextStyle(fontWeight: FontWeight.bold ,color: Colors.white)),
        actions: [
          IconButton(
            icon: const Icon(Icons.person, color: Colors.white,),
            onPressed: () =>
                Navigator.pushReplacementNamed(context, '/profile'),
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
      body: Column(
        children: [
          SearchBarWidget(
            controller: searchController,
            onChanged: (value) => _filterPosts(),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredPosts.length,
              itemBuilder: (context, index) {
                return BlogPostCard(
                  post: filteredPosts[index],
                  onCommentAdded: (comment) {
                    setState(() {
                      comments[index].add(comment);
                    });
                  },
                  comments: comments[index],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }
}
