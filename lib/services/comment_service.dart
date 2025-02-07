import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
class CommentService {
  static const String baseUrl = "http://192.168.1.234:8080/";
// Create a comment on a post
  static Future<Map<String, dynamic>> createComment(String postId, String content, String authorId) async {
    final url = Uri.parse('http://192.168.1.234:8080/comments/post/$postId');
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwt_token') ?? '';  // You can send the JWT token if required

    try {
      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token", 
        },
        body: jsonEncode({
          "content": content,
          "authorId": authorId,
        }),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);  // Successfully created comment
      } else {
        throw Exception("Error creating comment: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Exception: $e");
    }
  }
  
}
