import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:twizzy/models/post_model.dart';
import 'dart:convert';
class BlogScreen extends StatefulWidget {
  @override
  _BlogScreenState createState() => _BlogScreenState();
}

class _BlogScreenState extends State<BlogScreen> {
  List<Post> blogPosts = [];
  List<bool> hasLiked = [];
  List<bool> hasDisliked = [];
  List<int> likes = [];
  List<int> dislikes = [];
  List<List<String>> comments = [];

  Future<void> fetchBlogPost() async {
    final url = Uri.parse('http://192.168.1.234/twizzy/getAllPosts.php');

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);

        setState(() {
          blogPosts = data
              .map((item) => Post(
                    id: item['id'].toString(),
                    content: item['content'].toString(),
                  ))
              .toList();
          initializePostData(); 
        });
      } else {
        print("Error: ${response.statusCode}");
      }
    } catch (e) {
      print("Exception: $e");
    }
  }

  Future<void> addBlogPost(String content) async {
    final url = Uri.parse('http://192.168.1.234/twizzy/insert.php');

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"content": content}),
      );

      if (response.statusCode == 200) {
        print("Post added successfully");
        fetchBlogPost(); 
      } else {
        print("Error: ${response.statusCode}");
      }
    } catch (e) {
      print("Exception: $e");
    }
  }

  void initializePostData() {
    int count = blogPosts.length;
    hasLiked = List.filled(count, false);
    hasDisliked = List.filled(count, false);
    likes = List.filled(count, 0);
    dislikes = List.filled(count, 0);
    comments = List.generate(count, (index) => []);
  }

  @override
  void initState() {
    super.initState();
    fetchBlogPost();
  }
  void showAddPostDialog() {
    String newPostContent = '';
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "New Blog Post",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent,
                ),
              ),
              SizedBox(height: 12),
              TextField(
                onChanged: (value) => newPostContent = value,
                decoration: InputDecoration(
                  hintText: "Enter blog content",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.blueAccent),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.blueAccent),
                  ),
                  contentPadding: EdgeInsets.all(10),
                ),
                maxLines: 5,
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      "Cancel",
                      style: TextStyle(color: Colors.blueAccent),
                    ),
                  ),
                  SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () {
                      if (newPostContent.isNotEmpty) {
                        addBlogPost(newPostContent);
                        Navigator.pop(context);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text("Post"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Blog",
          style: TextStyle(
              fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/profile');
            },
            color: Colors.white,
          ),
        ],
        backgroundColor: Colors.blueAccent,
        elevation: 4,
        centerTitle: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        onPressed: showAddPostDialog, // Open form to add a new post
        child: Icon(Icons.add, color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
          itemCount: blogPosts.length,
          itemBuilder: (context, index) {
            return Card(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              elevation: 3,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      blogPosts[index].content, // Display blog content
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87),
                    ),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        IconButton(
                          icon: Icon(Icons.thumb_up,
                              color:
                                  hasLiked[index] ? Colors.blue : Colors.grey),
                          onPressed: () => setState(() {
                            if (!hasLiked[index]) {
                              if (hasDisliked[index]) {
                                hasDisliked[index] = false;
                                dislikes[index]--;
                              }
                              hasLiked[index] = true;
                              likes[index]++;
                            } else {
                              hasLiked[index] = false;
                              likes[index]--;
                            }
                          }),
                        ),
                        Text('${likes[index]}',
                            style: TextStyle(color: Colors.black87)),
                        SizedBox(width: 16),
                        IconButton(
                          icon: Icon(Icons.thumb_down,
                              color: hasDisliked[index]
                                  ? Colors.red
                                  : Colors.grey),
                          onPressed: () => setState(() {
                            if (!hasDisliked[index]) {
                              if (hasLiked[index]) {
                                hasLiked[index] = false;
                                likes[index]--;
                              }
                              hasDisliked[index] = true;
                              dislikes[index]++;
                            } else {
                              hasDisliked[index] = false;
                              dislikes[index]--;
                            }
                          }),
                        ),
                        Text('${dislikes[index]}',
                            style: TextStyle(color: Colors.black87)),
                        Spacer(),
                        TextButton.icon(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                String newComment = '';
                                return AlertDialog(
                                  title: Text('Add Comment'),
                                  content: TextField(
                                    onChanged: (value) => newComment = value,
                                    decoration: InputDecoration(
                                        hintText: 'Enter your comment'),
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: Text('Cancel'),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        if (newComment.isNotEmpty) {
                                          setState(() {
                                            comments[index].add(newComment);
                                          });
                                          Navigator.pop(context);
                                        }
                                      },
                                      child: Text('Post'),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          icon: Icon(Icons.comment, color: Colors.blueAccent),
                          label: Text('Add Comment',
                              style: TextStyle(color: Colors.blueAccent)),
                        ),
                      ],
                    ),
                    if (comments[index].isNotEmpty) ...[
                      Divider(),
                      Text('Comments:',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black87)),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: comments[index].length,
                        itemBuilder: (context, commentIndex) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4.0),
                            child: Text(comments[index][commentIndex],
                                style: TextStyle(color: Colors.black87)),
                          );
                        },
                      ),
                    ],
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
