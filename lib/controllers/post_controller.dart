class PostController {
  List<String> posts = [
    'This is a sample post content for Twizzy.',
    'Another example of a microblogging post.',
    'Flutter makes UI development fun and easy!'
  ];

  void addPost(String content) {
    posts.insert(0, content);
  }
}
