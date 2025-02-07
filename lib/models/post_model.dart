class Post {
  final String id;
  final String content;
  final List<String> comments;

  Post({required this.id, required this.content, required this.comments});

  factory Post.fromJson(Map<String, dynamic> json) {
    // If comments are objects (with a 'text' field), extract the text
    List<String> commentsList = [];
    if (json['comments'] != null) {
      commentsList = (json['comments'] as List)
          .map((comment) => comment['content'] as String)
          .toList();
    }

    return Post(
      id: json['id'],
      content: json['content'],
      comments: commentsList,
    );
  }
}