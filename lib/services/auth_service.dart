import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthService {
  final String baseUrl = 'http://192.168.163.26:8000/api';

  Future<bool> login(String username, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/login/'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'username': username, 'password': password}),
      );

      if (response.statusCode == 200) {
        final responseBody = json.decode(response.body);
        // Assuming your backend returns a success flag without a token
        return responseBody['success'] == true; // Login successful
      } else {
        print('Error during login: ${response.statusCode}, ${response.body}');
        return false; // Login failed
      }
    } catch (e) {
      print('Error: $e');
      return false; // Handle exceptions
    }
  }
}
