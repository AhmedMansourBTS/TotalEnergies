import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:total_energies/models/exp_promo_model.dart';
import 'package:total_energies/screens/Auth/loginPage.dart';

class GetExpPromoService {
  final String baseUrl =
      "https://www.besttopsystems.net:4336/api/PromotionEvent/GetAllCustomerExpiredPromotions";

  Future<List<ExpiredPromoModel>> getExpPromotions(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var customerSerial = prefs.getInt('serial');
    var token = prefs.getString('token');
    var expiresOn = prefs.getString('expiresOn');

    if (customerSerial == null) {
      throw Exception('Customer serial not found in SharedPreferences');
    }

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

    final url = Uri.parse("$baseUrl?customerCode=$customerSerial");
    print("Request URL: $url");

    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      print("(EXP) Status Code: ${response.statusCode}");
      print("(EXP) Response body: ${response.body}");

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        List<ExpiredPromoModel> allPromos =
            jsonData.map((json) => ExpiredPromoModel.fromJson(json)).toList();

        // Filter unique by serial
        final uniquePromos = <int, ExpiredPromoModel>{};
        for (var promo in allPromos) {
          uniquePromos[promo.serial] = promo;
        }

        return uniquePromos.values.toList();
      } else if (response.statusCode == 401) {
        await prefs.clear();
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
        throw Exception('Unauthorized access. Please log in again.');
      } else {
        throw Exception("Failed to load promotions: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Error fetching promotions: $e");
    }
  }
}