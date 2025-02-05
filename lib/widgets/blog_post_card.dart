import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:twizzy/models/post_model.dart';

class BlogPostCard extends StatefulWidget {
  final Post post;
  final Function(String) onCommentAdded;
  final List<String> comments;

  BlogPostCard({
    required this.post,
    required this.onCommentAdded,
    required this.comments,
  });

  @override
  _BlogPostCardState createState() => _BlogPostCardState();
}

class _BlogPostCardState extends State<BlogPostCard> {
  bool hasLiked = false;
  bool hasDisliked = false;
  int likes = 0;
  int dislikes = 0;

  void toggleLike() {
    setState(() {
      if (!hasLiked) {
        if (hasDisliked) {
          hasDisliked = false;
          dislikes--;
        }
        hasLiked = true;
        likes++;
      } else {
        hasLiked = false;
        likes--;
      }
    });
  }

  void toggleDislike() {
    setState(() {
      if (!hasDisliked) {
        if (hasLiked) {
          hasLiked = false;
          likes--;
        }
        hasDisliked = true;
        dislikes++;
      } else {
        hasDisliked = false;
        dislikes--;
      }
    });
  }

  void showCommentDialog() {
    String newComment = '';
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Add Comment'),
        content: TextField(
          onChanged: (value) => newComment = value,
          decoration: InputDecoration(hintText: 'Enter your comment'),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text('Cancel')),
          TextButton(
            onPressed: () {
              if (newComment.isNotEmpty) {
                widget.onCommentAdded(newComment);
                Navigator.pop(context);
              }
            },
            child: Text('Post'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 3,
      child: Padding(
        padding: EdgeInsets.all(12.0.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.post.content, style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold)),
            SizedBox(height: 8.h),
            Row(
              children: [
                IconButton(icon: Icon(Icons.thumb_up, color: hasLiked ? Colors.blue : Colors.grey), onPressed: toggleLike),
                Text('$likes'),
                SizedBox(width: 16.w),
                IconButton(icon: Icon(Icons.thumb_down, color: hasDisliked ? Colors.red : Colors.grey), onPressed: toggleDislike),
                Text('$dislikes'),
                Spacer(),
                TextButton.icon(
                  onPressed: showCommentDialog,
                  icon: Icon(Icons.comment, color: Colors.blueAccent),
                  label: Text('Add Comment', style: TextStyle(color: Colors.blueAccent)),
                ),
              ],
            ),
            if (widget.comments.isNotEmpty) ...[
              Divider(),
              Text('Comments:', style: TextStyle(fontWeight: FontWeight.bold)),
              ...widget.comments.map((c) => Text(c)).toList(),
            ],
          ],
        ),
      ),
    );
  }
}
