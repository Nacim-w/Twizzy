class CommentController {
  Map<String, List<String>> comments = {};

  void addComment(String postId, String comment) {
    if (!comments.containsKey(postId)) {
      comments[postId] = [];
    }
    comments[postId]!.add(comment);
  }
}
