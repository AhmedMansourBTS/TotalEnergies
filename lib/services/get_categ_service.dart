import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:total_energies/models/categories_model.dart';
import 'package:total_energies/screens/Auth/loginPage.dart';

class CategoryService {
  static const String _baseUrl = 'https://www.besttopsystems.net:4336/api/Category/GetAll';

  static Future<List<CategoryModel>> fetchCategories(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    var expiresOn = prefs.getString('expiresOn');

    if (token == null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
      throw Exception('Token not found in SharedPreferences');
    }

    // Check token expiry
    if (expiresOn != null && expiresOn.isNotEmpty) {
      final expiryDate = DateTime.tryParse(expiresOn);
      if (expiryDate != null && DateTime.now().isAfter(expiryDate)) {
        await prefs.clear();
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
        throw Exception('Session expired. Please log in again.');
      }
    }

    try {
      final response = await http.get(
        Uri.parse(_baseUrl),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      print("(Category) Request URL: $_baseUrl");
      print("(Category) Status Code: ${response.statusCode}");
      print("(Category) Response body: ${response.body}");

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((item) => CategoryModel.fromJson(item)).toList();
      } else if (response.statusCode == 401) {
        await prefs.clear();
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
        throw Exception('Unauthorized access. Please log in again.');
      } else {
        throw Exception('Failed to load categories: ${response.statusCode}');
      }
    } catch (e) {
      print('Exception occurred: $e');
      throw Exception('Error fetching categories: $e');
    }
  }
}