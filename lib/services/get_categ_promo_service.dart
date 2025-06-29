import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:total_energies/models/categories_promotion_model.dart';
import 'package:total_energies/screens/Auth/loginPage.dart';

class GetCategPromoService {
  static const String baseUrl =
      'https://www.besttopsystems.net:4336/api/PromotionEvent/GetValidPromotionsByCategory';

  static Future<List<CategoriesPromotionModel>> getPromotionsByCategory(
      int categoryId, BuildContext context) async {
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
        Uri.parse('$baseUrl/$categoryId'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      print("(CategPromo) Request URL: $baseUrl/$categoryId");
      print("(CategPromo) Status Code: ${response.statusCode}");
      print("(CategPromo) Response body: ${response.body}");

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body);
        return jsonList.map((e) => CategoriesPromotionModel.fromJson(e)).toList();
      } else if (response.statusCode == 401) {
        await prefs.clear();
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
        throw Exception('Unauthorized access. Please log in again.');
      } else {
        throw Exception('Failed to load promotions for category $categoryId: ${response.statusCode}');
      }
    } catch (e) {
      print('Exception occurred: $e');
      throw Exception('Error fetching promotions for category $categoryId: $e');
    }
  }
}