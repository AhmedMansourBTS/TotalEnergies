// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:total_energies/models/stations_model.dart';

// class StationService {
//   final String baseUrl = "https://www.besttopsystems.net:4336/api/Station/GetAll";

//   Future<List<StationModel>> getStations() async {
//     final response = await http.get(Uri.parse(baseUrl));

//     if (response.statusCode == 200) {
//       List jsonResponse = jsonDecode(response.body);
//       return jsonResponse.map((data) => StationModel.fromJson(data)).toList();
//     } else {
//       throw Exception("Failed to load stations");
//     }
//   }

//   Future<List<StationModel>> getOnlyStations() async {
//     final response = await http.get(Uri.parse(baseUrl));

//     if (response.statusCode == 200) {
//       List jsonResponse = jsonDecode(response.body);
//       return jsonResponse
//           .map((data) => StationModel.fromJson(data))
//           .where((station) => (station.serial ?? 0) < 20) // Filter serial < 30
//           .toList();
//     } else {
//       throw Exception("Failed to load stations");
//     }
//   }
// }


import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:total_energies/models/stations_model.dart';
import 'package:total_energies/screens/Auth/loginPage.dart';

class StationService {
  static const String _baseUrl = 'https://www.besttopsystems.net:4336/api/Station/GetAll';

  Future<List<StationModel>> getStations(BuildContext context) async {
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
      ).timeout(const Duration(seconds: 10));

      print("(Station) Request URL: $_baseUrl");
      print("(Station) Status Code: ${response.statusCode}");
      print("(Station) Response body: ${response.body}");

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((item) => StationModel.fromJson(item)).toList();
      } else if (response.statusCode == 401) {
        await prefs.clear();
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
        throw Exception('Unauthorized access. Please log in again.');
      } else {
        throw Exception('Failed to load stations: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching stations: $e');
      throw Exception('Error fetching stations: $e');
    }
  }

  Future<List<StationModel>> getOnlyStations(BuildContext context) async {
    final stations = await getStations(context);
    return stations.where((station) => (station.serial ?? 0) < 20).toList();
  }
}