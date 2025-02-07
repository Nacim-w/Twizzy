import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:twizzy/models/post_model.dart';
class PostService {
  static const String baseUrl = "http://192.168.1.234:8080/";
//get all posts
static Future<List<Post>> fetchAllPosts() async {
  final url = Uri.parse("http://192.168.1.234:8080/posts");
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('jwt_token') ?? '';

  try {
    final response = await http.get(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      
      // Ensure the Post model handles comments correctly
      return data.reversed.map((item) => Post.fromJson(item)).toList();
    } else {
      throw Exception("Error fetching posts: ${response.statusCode}");
    }
  } catch (e) {
    throw Exception("Exception: $e");
  }
}


//get trending posts
static Future<List<Post>> fetchTrendingPosts() async {
  final url = Uri.parse("http://192.168.1.234:8080/posts/trending");
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('jwt_token') ?? '';

  try {
    final response = await http.get(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      
      // Ensure the Post model handles comments correctly
      return data.reversed.map((item) => Post.fromJson(item)).toList();
    } else {
      throw Exception("Error fetching posts: ${response.statusCode}");
    }
  } catch (e) {
    throw Exception("Exception: $e");
  }
}

//create post
  static Future<Post> createPost(String content) async {
    final url = Uri.parse("http://192.168.1.234:8080/posts");
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwt_token') ?? '';

    try {
      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",  
        },
        body: jsonEncode({"content": content}),
      );

      if (response.statusCode == 200) {
        return Post.fromJson(json.decode(response.body));
      } else {
        throw Exception("Error creating post: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Exception: $e");
    }
  }
  // Update a post
static Future<bool> updatePost(String id, String content) async {
    final url = Uri.parse('http://192.168.1.234:8080/posts/$id');
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwt_token') ?? '';

    try {
      final response = await http.put(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",  // Send the JWT token in the request header
        },
        body: jsonEncode({"content": content}),
      );
      print(response.body);
      if (response.statusCode == 200) {
        return true;
      } else {
          return false;
      }
    } catch (e) {
      throw Exception("Exception: $e");
    }
  }
// Delete a post
  static Future<bool> deletePost(String id) async {
    final url = Uri.parse('http://192.168.1.234:8080/posts/$id');
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwt_token') ?? '';
    var showing=true;

    try {
      final response = await http.delete(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",  // Send the JWT token in the request header
        },
      );
      if (response.statusCode != 200) {
        return !showing;
      } else{
        return showing;
      }
    } catch (e) {
      throw Exception("Exception: $e");
    }
  }




}
