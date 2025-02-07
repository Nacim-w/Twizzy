import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:twizzy/models/post_model.dart';
class ApiService {
  static const String baseUrl = "http://192.168.1.33:8080/";

static Future<List<Post>> fetchAllPosts() async {
    final url = Uri.parse("http://192.168.1.33:8080/posts");
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwt_token') ?? '';

    try {
      final response = await http.get(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",  // Send the JWT token in the request header
        },
      );

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
  final url = Uri.parse('http://192.168.1.33:8080/auth/login');
  try {
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"username": username, "password": password}),
    );
    print(response.body);
    print(response.statusCode);
    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      String token = responseData['token'];
      // Save the token securely (e.g., using shared_preferences)
      final prefs = await SharedPreferences.getInstance();
      prefs.setString('jwt_token', token);
      
      return responseData;
    } else {
      throw Exception("Error logging in: ${response.statusCode}");
    }
  } catch (e) {
    throw Exception("Exception: $e");
  }
}
 static Future<Map<String, dynamic>> register(String username, String password, String email) async {
    final url = Uri.parse('http://192.168.1.33:8080/auth/register');
    try {
      print("hello");
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"username": username, "email": email, "password": password}),
      );
      print("hello");
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception("Error registering user: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Exception: $e");
    }
  }
}
