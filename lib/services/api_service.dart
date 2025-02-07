import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:twizzy/models/user_model.dart';
class ApiService {
  static const String baseUrl = "http://192.168.1.234:8080/";


 static Future<Map<String, dynamic>> updateUser(String id, User updatedUser) async {
    final url = Uri.parse('${baseUrl}users/$id'); 
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwt_token') ?? ''; // Get the token from SharedPreferences

    try {
      final response = await http.put(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",  // Add JWT token to the request headers
        },
        body: jsonEncode(updatedUser),  // Send the updated user data
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        return responseData; // Return the response data (success message and updated user)
      } else if (response.statusCode == 404) {
        throw Exception("User not found.");
      } else {
        throw Exception("Error updating user: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Exception: $e");
    }
  }
}
