class Post {
  final String id;
  final String userId;
  final String content;
  final DateTime timestamp;
  final int likes;
  final int dislikes;

  Post({
    required this.id,
    required this.userId,
    required this.content,
    required this.timestamp,
    this.likes = 0,
    this.dislikes = 0,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'],
      userId: json['userId'],
      content: json['content'],
      timestamp: DateTime.parse(json['timestamp']),
      likes: json['likes'] ?? 0,
      dislikes: json['dislikes'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'content': content,
      'timestamp': timestamp.toIso8601String(),
      'likes': likes,
      'dislikes': dislikes,
    };
  }
}
