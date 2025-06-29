import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:total_energies/models/promotions_model.dart';
import 'package:total_energies/screens/Auth/loginPage.dart';

class PromotionsService {
  final String apiUrl =
      "https://www.besttopsystems.net:4336/api/PromotionEvent/GetValidPromotions";

  Future<List<PromotionsModel>> getPromotions(BuildContext context) async {
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
        Uri.parse(apiUrl),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      print("(All) Request URL: $apiUrl");
      print('(All) Status Code: ${response.statusCode}');
      print('(All) Response body: ${response.body}');

      if (response.statusCode == 200) {
        final List<dynamic> jsonResponse = jsonDecode(response.body);
        final promotions = jsonResponse
            .map((promo) => PromotionsModel.fromJson(promo))
            .toList();
        print("(All) Promotions: $promotions");
        return promotions;
      } else if (response.statusCode == 401) {
        await prefs.clear();
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
        throw Exception('Unauthorized access. Please log in again.');
      } else {
        print("(All) Server error: ${response.statusCode}");
        throw Exception("Failed to load promotions: ${response.statusCode}");
      }
    } catch (e) {
      print('Exception occurred: $e');
      throw Exception('Error fetching promotions: $e');
    }
  }
}