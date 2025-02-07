import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:twizzy/models/post_model.dart';
import 'package:twizzy/services/post_service.dart';
import 'package:twizzy/widgets/blog_post_card.dart';
import 'package:twizzy/widgets/add_post_dialog.dart';
import 'package:twizzy/widgets/search_bar_widget.dart';

class TrendingScreen extends StatefulWidget {
  @override
  _TrendingScreenState createState() => _TrendingScreenState();
}

class _TrendingScreenState extends State<TrendingScreen> {
  List<Post> blogPosts = [];
  List<Post> filteredPosts = [];
  List<List<String>> comments = [];
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchTrendingPosts();
    searchController.addListener(_filterPosts);
  }

  Future<void> fetchTrendingPosts() async {
    final posts = await PostService.fetchTrendingPosts();
    setState(() {
      blogPosts = posts;
      filteredPosts = posts;
      comments = posts.map((post) => post.comments).toList();
      print(comments);
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
    await PostService.createPost(content);
    fetchTrendingPosts();
  }

  void showAddPostDialog() {
    showDialog(
      context: context,
      builder: (context) => AddPostDialog(onPostAdded: addNewPost),
    );
  }

  void _showPostOptions(BuildContext context, Post post) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      builder: (context) {
        return Wrap(
          children: [
            ListTile(
              leading: Icon(Icons.edit),
              title: Text("Edit Post"),
              onTap: () {
                Navigator.pop(context);
                _editPost(post);
              },
            ),
            ListTile(
              leading: Icon(Icons.delete, color: Colors.red),
              title: Text("Delete Post"),
              onTap: () {
                Navigator.pop(context);
                _deletePost(post);
              },
            ),
          ],
        );
      },
    );
  }

  void _editPost(Post post) {
    TextEditingController editController = TextEditingController(text: post.content);
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Text("Edit Post"),
          content: TextField(
            controller: editController,
            decoration: InputDecoration(hintText: "Update your post"),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () async {
                String updatedContent = editController.text.trim();

                // Basic validation to check if the content is not empty
                if (updatedContent.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Post content cannot be empty')),
                  );
                }

                // Show loading indicator
                showDialog(
                  context: context,
                  builder: (BuildContext context) => Center(child: CircularProgressIndicator()),
                );

                // Update the post on the backend
                try {
                  var postbool = await PostService.updatePost(post.id, updatedContent);
                  if(postbool){
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Post updated successfully"),
                        behavior: SnackBarBehavior.floating,
                        backgroundColor: Colors.green,
                      ),
                    );
                                      fetchTrendingPosts();
                    }
                    else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Failed to update post"),
                          behavior: SnackBarBehavior.floating,
                          backgroundColor: Colors.redAccent,
                        ),
                      );
                    }
                } finally {
                  Navigator.pop(context); // Remove loading indicator
                  Navigator.pop(context); // Close the dialog
                }
              },
              child: Text("Save"),
            ),
          ],
        );
      },
    );
  }

  void _deletePost(Post post) async {
    var test= await PostService.deletePost(post.id);
    if(test){
      fetchTrendingPosts();
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Post deleted successfully"),
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.green,
          ),
        );
    }else{
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Failed to delete post"),
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.redAccent,
          ),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
  title: Text(
    "Blog",
    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.sp, color: Colors.white),
  ),
  leading: Padding(
    padding: EdgeInsets.only(left: 10), // Adjust spacing
    child: IconButton(
      onPressed: () {
  Navigator.pushReplacementNamed(context, '/blog');
      },
      icon: Text(
        "🏃‍♂️", // Running man emoji
        style: TextStyle(fontSize: 28), // Adjust size
      ),
    ),
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
                        return GestureDetector(
                          onLongPress: () => _showPostOptions(context, filteredPosts[index]),
                          child: Padding(
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
