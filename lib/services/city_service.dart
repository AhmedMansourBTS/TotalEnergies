// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:total_energies/models/city_model.dart';
// import 'package:total_energies/screens/Auth/loginPage.dart';

// class CityService {
//   static const String _baseUrl = 'https://www.besttopsystems.net:4336/api/City/GetAll';

//   Future<List<CityModel>> getCities(BuildContext context) async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     var token = prefs.getString('token');
//     var expiresOn = prefs.getString('expiresOn');

//     if (token == null) {
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (context) => const LoginScreen()),
//       );
//       throw Exception('Token not found in SharedPreferences');
//     }

//     if (expiresOn != null && expiresOn.isNotEmpty) {
//       final expiryDate = DateTime.tryParse(expiresOn);
//       if (expiryDate != null && DateTime.now().isAfter(expiryDate)) {
//         await prefs.clear();
//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(builder: (context) => const LoginScreen()),
//         );
//         throw Exception('Session expired. Please log in again.');
//       }
//     }

//     try {
//       final response = await http.get(
//         Uri.parse(_baseUrl),
//         headers: {
//           'Authorization': 'Bearer $token',
//           'Content-Type': 'application/json',
//         },
//       ).timeout(const Duration(seconds: 10));

//       print("(City) Request URL: $_baseUrl");
//       print("(City) Status Code: ${response.statusCode}");
//       print("(City) Response body: ${response.body}");

//       if (response.statusCode == 200) {
//         final List<dynamic> data = json.decode(response.body);
//         return data.map((item) => CityModel.fromJson(item)).toList();
//       } else if (response.statusCode == 401) {
//         await prefs.clear();
//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(builder: (context) => const LoginScreen()),
//         );
//         throw Exception('Unauthorized access. Please log in again.');
//       } else {
//         throw Exception('Failed to load cities: ${response.statusCode}');
//       }
//     } catch (e) {
//       print('Error fetching cities: $e');
//       throw Exception('Error fetching cities: $e');
//     }
//   }
// }

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:total_energies/models/city_model.dart';

class CityService {
  static const String _baseUrl = 'https://www.besttopsystems.net:4336/api/City/GetAll';

  Future<List<CityModel>> getCities() async {
    try {
      final response = await http.get(Uri.parse(_baseUrl)).timeout(const Duration(seconds: 10));

      print("(City) Request URL: $_baseUrl");
      print("(City) Status Code: ${response.statusCode}");
      print("(City) Response body: ${response.body}");

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((item) => CityModel.fromJson(item)).toList();
      } else {
        throw Exception('Failed to load cities: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching cities: $e');
      throw Exception('Error fetching cities: $e');
    }
  }
}
