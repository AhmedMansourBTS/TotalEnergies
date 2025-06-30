// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:total_energies/models/governorate_model.dart';

// class GovernorateService {
//   static const String _url =
//       "https://www.besttopsystems.net:4336/api/Governorate/GetAll";

//   static Future<List<GovernorateModel>> getAllGovernorates() async {
//     try {
//       final response = await http
//           .get(Uri.parse(_url))
//           .timeout(const Duration(seconds: 10));

//       if (response.statusCode == 200) {
//         final List<dynamic> jsonList = jsonDecode(response.body);
//         return jsonList
//             .map((json) => GovernorateModel.fromJson(json))
//             .toList();
//       } else {
//         throw Exception('Failed to load governorates');
//       }
//     } catch (e) {
//       throw Exception('Error fetching governorates: $e');
//     }
//   }

//   getGovernorates() {}
// }

// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:total_energies/models/governorate_model.dart';
// import 'package:total_energies/screens/Auth/loginPage.dart';

// class GovernorateService {
//   static const String _baseUrl = 'https://www.besttopsystems.net:4336/api/Governorate/GetAll';

//   static Future<List<GovernorateModel>> getAllGovernorates(BuildContext context) async {
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

//       print("(Governorate) Request URL: $_baseUrl");
//       print("(Governorate) Status Code: ${response.statusCode}");
//       print("(Governorate) Response body: ${response.body}");

//       if (response.statusCode == 200) {
//         final List<dynamic> data = json.decode(response.body);
//         return data.map((item) => GovernorateModel.fromJson(item)).toList();
//       } else if (response.statusCode == 401) {
//         await prefs.clear();
//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(builder: (context) => const LoginScreen()),
//         );
//         throw Exception('Unauthorized access. Please log in again.');
//       } else {
//         throw Exception('Failed to load governorates: ${response.statusCode}');
//       }
//     } catch (e) {
//       print('Error fetching governorates: $e');
//       throw Exception('Error fetching governorates: $e');
//     }
//   }
// }

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:total_energies/models/governorate_model.dart';

class GovernorateService {
  static const String _baseUrl = 'https://www.besttopsystems.net:4336/api/Governorate/GetAll';

  static Future<List<GovernorateModel>> getAllGovernorates() async {
    try {
      final response = await http.get(
        Uri.parse(_baseUrl),
        headers: {
          'Content-Type': 'application/json',
        },
      ).timeout(const Duration(seconds: 10));

      print("(Governorate) Request URL: $_baseUrl");
      print("(Governorate) Status Code: ${response.statusCode}");
      print("(Governorate) Response body: ${response.body}");

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((item) => GovernorateModel.fromJson(item)).toList();
      } else {
        throw Exception('Failed to load governorates: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching governorates: $e');
      throw Exception('Error fetching governorates: $e');
    }
  }
}
