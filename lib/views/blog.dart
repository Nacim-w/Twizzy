import 'package:flutter/material.dart';
import 'package:twizzy/views/profile.dart';

class BlogScreen extends StatefulWidget {
  @override
  _BlogScreenState createState() => _BlogScreenState();
}

class _BlogScreenState extends State<BlogScreen> {
  final List<String> blogPosts = [
    "Blog Post 1: Introduction to Flutter",
    "Blog Post 2: Understanding State Management",
    "Blog Post 3: Building Responsive UIs",
    "Blog Post 4: Networking in Flutter",
    "Blog Post 5: Deploying Flutter Apps"
  ];

  List<bool> hasLiked = List.filled(5, false);
  List<bool> hasDisliked = List.filled(5, false);
  List<int> likes = List.filled(5, 0);
  List<int> dislikes = List.filled(5, 0);
  List<List<String>> comments = List.generate(5, (index) => []);

  void toggleLike(int index) {
    setState(() {
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
    });
  }

  void toggleDislike(int index) {
    setState(() {
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
    });
  }

  void addComment(int index) {
    showDialog(
      context: context,
      builder: (context) {
        String newComment = '';
        return AlertDialog(
          title: Text('Add Comment'),
          content: TextField(
            onChanged: (value) => newComment = value,
            decoration: InputDecoration(hintText: 'Enter your comment'),
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.blueAccent,
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) =>  ProfileScreen()),
            );
          },
          child: const Icon(Icons.arrow_forward, color: Colors.white, size: 28),
          ),
      appBar: AppBar(
        title: Text(
          "Blog",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.blueAccent,
        elevation: 4,
        centerTitle: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(20),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
          itemCount: blogPosts.length,
          itemBuilder: (context, index) {
            return Card(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              elevation: 3,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      blogPosts[index],
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
                    ),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        IconButton(
                          icon: Icon(Icons.thumb_up, color: hasLiked[index] ? Colors.blue : Colors.grey),
                          onPressed: () => toggleLike(index),
                        ),
                        Text('${likes[index]}', style: TextStyle(color: Colors.black87)),
                        SizedBox(width: 16),
                        IconButton(
                          icon: Icon(Icons.thumb_down, color: hasDisliked[index] ? Colors.red : Colors.grey),
                          onPressed: () => toggleDislike(index),
                        ),
                        Text('${dislikes[index]}', style: TextStyle(color: Colors.black87)),
                        Spacer(),
                        TextButton.icon(
                          onPressed: () => addComment(index),
                          icon: Icon(Icons.comment, color: Colors.blueAccent),
                          label: Text('Add Comment', style: TextStyle(color: Colors.blueAccent)),
                        ),
                      ],
                    ),
                    if (comments[index].isNotEmpty) ...[
                      Divider(),
                      Text('Comments:', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87)),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: comments[index].length,
                        itemBuilder: (context, commentIndex) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4.0),
                            child: Text(comments[index][commentIndex], style: TextStyle(color: Colors.black87)),
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