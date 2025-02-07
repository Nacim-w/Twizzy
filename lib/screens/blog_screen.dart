import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
    final posts = await ApiService.fetchAllPosts();
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
        title: Text(
          "Blog",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.sp, color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.person, color: Colors.white, size: 28.r),
            onPressed: () => Navigator.pushReplacementNamed(context, '/profile'),
          ),
        ],
        backgroundColor: Colors.blueAccent,
        centerTitle: true,
        elevation: 5,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        onPressed: showAddPostDialog,
        child: Icon(Icons.add, color: Colors.white, size: 24.r),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.r)),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
        child: Column(
          children: [
            SearchBarWidget(
              controller: searchController,
              onChanged: (value) => _filterPosts(),
            ),
            SizedBox(height: 10.h),
            Expanded(
              child: filteredPosts.isEmpty
                  ? Center(
                      child: Text(
                        "No posts available",
                        style: TextStyle(fontSize: 16.sp, color: Colors.black54),
                      ),
                    )
                  : ListView.builder(
                      itemCount: filteredPosts.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: EdgeInsets.only(bottom: 10.h),
                          child: BlogPostCard(
                            post: filteredPosts[index],
                            onCommentAdded: (comment) {
                              setState(() {
                                comments[index].add(comment);
                              });
                            },
                            comments: comments[index],
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }
}
