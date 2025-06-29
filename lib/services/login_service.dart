import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:total_energies/models/login_model.dart';

class LoginService {
  final String _baseUrl = 'https://www.besttopsystems.net:4336/api/Customer';

  Future<http.Response> loginuser(LoginModel user) async {
    final url = Uri.parse('$_baseUrl/CustomerLogin');
    
    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(user.toJson()),
      );
      
      return response;
    } catch (e) {
      throw Exception('Failed to login: $e');
    }
  }
}