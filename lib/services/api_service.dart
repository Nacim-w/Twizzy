import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:twizzy/models/post_model.dart';
class ApiService {
  static const String baseUrl = "http://192.168.1.234/twizzy/";

  static Future<List<Post>> fetchBlogPost() async {
    final url = Uri.parse('${baseUrl}getAllPosts.php');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((item) => Post.fromJson(item)).toList();
      } else {
        throw Exception("Error fetching posts: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Exception: $e");
    }
  }

  static Future<void> addBlogPost(String content) async {
    final url = Uri.parse('${baseUrl}insert.php');
    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"content": content}),
      );
      if (response.statusCode != 200) {
        throw Exception("Error adding post: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Exception: $e");
    }
  }

  static Future<Map<String, dynamic>> login(String username, String password) async {
    final url = Uri.parse('${baseUrl}login.php');
    try {
      final response = await http.post(
        url,
        body: {'username': username, 'password': password},
      );

      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        return responseData;
      } else {
        throw Exception("Error logging in: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Exception: $e");
    }
  }
}
