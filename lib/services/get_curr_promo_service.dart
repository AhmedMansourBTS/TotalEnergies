// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:total_energies/models/curr_promo_model.dart';

// class GetCurrPromoService {
//   final String baseUrl =
//       "https://www.besttopsystems.net:4336/api/PromotionEvent/GetAllValidPormotionByCustomerSerial";

//   Future<List<CurrPromoModel>> getCurrPromotions() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     var customerSerial = prefs.getInt('serial');
//     final url = Uri.parse("$baseUrl/$customerSerial");
//     print("Fetching promotions from: $url");

//     try {
//       final response = await http.get(url);

//       if (response.statusCode == 200) {
//         final List<dynamic> jsonData = json.decode(response.body);

//         List<CurrPromoModel> allPromos =
//             jsonData.map((json) => CurrPromoModel.fromJson(json)).toList();

//         return allPromos;
//       } else {
//         throw Exception("Failed to load promotions: ${response.statusCode}");
//       }
//     } catch (e) {
//       throw Exception("Error fetching promotions: $e");
//     }
//   }
// }

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:total_energies/models/curr_promo_model.dart';

class GetCurrPromoService {
  final String baseUrl =
      "https://www.besttopsystems.net:4336/api/PromotionEvent/GetAllValidPormotionByCustomerSerial";

  Future<List<CurrPromoModel>> getCurrPromotions() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var customerSerial = prefs.getInt('serial');
    var token = prefs.getString('token');

    if (customerSerial == null) {
      throw Exception('Customer serial not found in SharedPreferences');
    }

    if (token == null) {
      throw Exception('Token not found in SharedPreferences');
    }

    final url = Uri.parse('$baseUrl?customerCode=$customerSerial');

    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    print("(CURR) Request URL: $baseUrl");
    print('(CURR) Status Code: ${response.statusCode}');

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body);
      print("(CURR) Response body: ${response.body}");
      return jsonList.map((e) => CurrPromoModel.fromJson(e)).toList();
    } else {
      print("(CURR) Response body: ${response.body}");
      throw Exception('Failed to load promotions: ${response.statusCode}');
    }
  }
}
