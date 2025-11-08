import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  // Replace with your actual base URL, e.g. "https://queueless.onrender.com"
  static const String baseUrl = "https://localhost:61442/api/v1"; 

  // LOGIN
  static Future<Map<String, dynamic>> login(String username, String password) async {
    final url = Uri.parse("$baseUrl/login");

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "username": username,
        "password": password,
      }),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Login failed: ${response.statusCode} - ${response.body}");
    }
  }

  // REGISTER
  static Future<Map<String, dynamic>> signup({
    required String username,
    required String email,
    required String firstName,
    required String lastName,
    required String organization,
    required String password,
  }) async {
    final url = Uri.parse("$baseUrl/register");

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "username": username,
        "email": email,
        "firstName": firstName,
        "lastName": lastName,
        "organization": organization,
        "password": password,
      }),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Signup failed: ${response.statusCode} - ${response.body}");
    }
  }
}
