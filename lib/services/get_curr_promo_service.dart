// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:total_energies/models/promotions_model.dart';

// class GetCurrPromoService {
//   final String baseUrl =
//       "https://www.besttopsystems.net:4336/api/PromotionEvent/GetAllValidPormotionByCustomerSerial";

//   Future<List<PromotionsModel>> getCurrPromotions() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     var customerSerial = prefs.getInt('serial');

//     final url = Uri.parse("$baseUrl?customerCode=$customerSerial");

//     print("Request URL: $url");

//     try {
//       final response = await http.get(url);

//       if (response.statusCode == 200) {
//         final List<dynamic> jsonData = json.decode(response.body);

//         return jsonData.map((json) => PromotionsModel.fromJson(json)).toList();
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
import 'package:total_energies/models/promotions_model.dart';

class GetCurrPromoService {
  final String baseUrl =
      "https://www.besttopsystems.net:4336/api/PromotionEvent/GetAllValidPormotionByCustomerSerial";

  Future<List<CurrPromoModel>> getCurrPromotions() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var customerSerial = prefs.getInt('serial');

    final url = Uri.parse("$baseUrl?customerCode=$customerSerial");

    print("Request URL: $url");

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);

        return jsonData.map((json) => CurrPromoModel.fromJson(json)).toList();
      } else {
        throw Exception("Failed to load promotions: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Error fetching promotions: $e");
    }
  }
}
