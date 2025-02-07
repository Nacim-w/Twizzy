import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:twizzy/models/post_model.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.r)),
        title: Text(AppLocalizations.of(context)!.addcomment, style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold)),
        content: TextField(
          onChanged: (value) => newComment = value,
          decoration: InputDecoration(hintText: AppLocalizations.of(context)!.addcomment),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text(AppLocalizations.of(context)!.cancel)),
          TextButton(
            onPressed: () {
              if (newComment.isNotEmpty) {
                widget.onCommentAdded(newComment);
                Navigator.pop(context);
              }
            },
            child: Text(AppLocalizations.of(context)!.postbutton),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.r)),
      elevation: 5,
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.post.content, style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold)),
            SizedBox(height: 10.h),
            Row(
              children: [
                IconButton(
                  icon: Icon(Icons.thumb_up, color: hasLiked ? Colors.blue : Colors.grey),
                  onPressed: toggleLike,
                ),
                Text('$likes', style: TextStyle(fontSize: 14.sp)),
                SizedBox(width: 16.w),
                IconButton(
                  icon: Icon(Icons.thumb_down, color: hasDisliked ? Colors.red : Colors.grey),
                  onPressed: toggleDislike,
                ),
                Text('$dislikes', style: TextStyle(fontSize: 14.sp)),
                Spacer(),
                TextButton.icon(
                  onPressed: showCommentDialog,
                  icon: Icon(Icons.comment, color: Colors.blueAccent),
                  label: Text(
                    AppLocalizations.of(context)!.addcomment,
                    style: TextStyle(color: Colors.blueAccent, fontSize: 14.sp),
                  ),
                ),
              ],
            ),
            if (widget.comments.isNotEmpty) ...[
              Divider(),
              Text('Comments:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.sp)),
              SizedBox(height: 5.h),
              ...widget.comments.map((c) => Padding(
                    padding: EdgeInsets.symmetric(vertical: 3.h),
                    child: Text(c, style: TextStyle(fontSize: 14.sp, color: Colors.black87)),
                  )),
            ],
          ],
        ),
      ),
    );
  }
}
