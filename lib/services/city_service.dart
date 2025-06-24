// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:total_energies/models/city_model.dart';

// class CityService {
//   // final String baseUrl = "http://92.204.139.204:4335/api/City/GetAll";

//   final String baseUrl = "https://www.besttopsystems.net:4336/api/City/GetAll";

//   // Read (Get Users)
//   Future<List<CityModel>> getUsers() async {
//     final response = await http.get(Uri.parse(baseUrl));

//     if (response.statusCode == 200) {
//       List jsonResponse = jsonDecode(response.body);
//       return jsonResponse.map((data) => CityModel.fromJson(data)).toList();
//     } else {
//       throw Exception("Failed to load cities");
//     }
//   }
// }

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:total_energies/models/city_model.dart';

class CityService {
  final String baseUrl = "https://www.besttopsystems.net:4336/api/City/GetAll";

  // Read (Get Cities)
  Future<List<CityModel>> getCities() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      List jsonResponse = jsonDecode(response.body);
      return jsonResponse.map((data) => CityModel.fromJson(data)).toList();
    } else {
      throw Exception("Failed to load cities");
    }
  }
}