class Comment {
  final String commentId;
  final String content;

  Comment({
    required this.commentId,
    required this.content,
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      commentId: json['commentId'],
      content: json['content'],);
  }

  Map<String, dynamic> toJson() {
    return {
      'commentId': commentId,
      'content': content,
    };
  }
}
