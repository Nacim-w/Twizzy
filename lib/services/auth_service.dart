import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
class AuthService {
  static const String baseUrl = "http://192.168.1.234:8080/";

//login
  static Future<Map<String, dynamic>> login(
      String username, String password) async {
    final url = Uri.parse('http://192.168.1.234:8080/auth/login');
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

//register
  static Future<Map<String, dynamic>> register(
      String username, String password, String email) async {
    final url = Uri.parse('http://192.168.1.234:8080/auth/register');
    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(
            {"username": username, "email": email, "password": password}),
      );
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
