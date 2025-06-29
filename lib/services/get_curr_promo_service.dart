import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:total_energies/models/curr_promo_model.dart';
import 'package:flutter/material.dart';
import 'package:total_energies/screens/Auth/loginPage.dart';

class GetCurrPromoService {
  final String baseUrl =
      "https://www.besttopsystems.net:4336/api/PromotionEvent/GetAllValidPormotionByCustomerSerial";

  Future<List<CurrPromoModel>> getCurrPromotions(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var customerSerial = prefs.getInt('serial');
    var token = prefs.getString('token');
    print("(CURR) Request URL: $token");
    var expiresOn = prefs.getString('expiresOn');

    if (customerSerial == null) {
      throw Exception('Customer serial not found in SharedPreferences');
    }

    if (token == null) {
      throw Exception('Token not found in SharedPreferences');
    }

    // Check token expiry
    if (expiresOn != null && expiresOn.isNotEmpty) {
      final expiryDate = DateTime.tryParse(expiresOn);
      if (expiryDate != null && DateTime.now().isAfter(expiryDate)) {
        // Token expired, clear SharedPreferences and redirect to LoginScreen
        await prefs.clear();
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
        throw Exception('Session expired. Please log in again.');
      }
    }

    // final url = Uri.parse('$baseUrl?customerCode=$customerSerial');

    final url = Uri.parse('$baseUrl/$customerSerial');

    print("(CURR) Request URL: $url");
    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    print('(CURR) Status Code: ${response.statusCode}');
    print("(CURR) Response body: ${response.body}");

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList.map((e) => CurrPromoModel.fromJson(e)).toList();
    } else if (response.statusCode == 401) {
      // Unauthorized, likely invalid or expired token
      await prefs.clear();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
      throw Exception('Unauthorized access. Please log in again.');
    } else {
      throw Exception('Failed to load promotions: ${response.statusCode}');
    }
  }
}
