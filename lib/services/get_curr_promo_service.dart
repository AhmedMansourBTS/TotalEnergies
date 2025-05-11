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

// working correctly
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

//     final url = Uri.parse("$baseUrl?customerCode=$customerSerial");

//     print("Request URL: $url");

//     try {
//       final response = await http.get(url);

//       if (response.statusCode == 200) {
//         final List<dynamic> jsonData = json.decode(response.body);

//         return jsonData.map((json) => CurrPromoModel.fromJson(json)).toList();
//       } else {
//         throw Exception("Failed to load promotions: ${response.statusCode}");
//       }
//     } catch (e) {
//       throw Exception("Error fetching promotions: $e");
//     }
//   }
// }

// Unique serial
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

//     // final url = Uri.parse("$baseUrl?customerCode=$customerSerial");
//     final url = Uri.parse("$baseUrl/$customerSerial");

//     print("Request URL: $url");

//     try {
//       final response = await http.get(url);

//       if (response.statusCode == 200) {
//         final List<dynamic> jsonData = json.decode(response.body);
//         print("Request URL: ${response.body}");
//         // Parse JSON into model list
//         List<CurrPromoModel> allPromos =
//             jsonData.map((json) => CurrPromoModel.fromJson(json)).toList();

//         // Remove duplicates based on 'serial'
//         final uniquePromos = <int, CurrPromoModel>{};
//         for (var promo in allPromos) {
//           uniquePromos[promo.serial] = promo;
//         }

//         return uniquePromos.values.toList();
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
    final url = Uri.parse("$baseUrl/$customerSerial");
    print("Fetching promotions from: $url");

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);

        List<CurrPromoModel> allPromos =
            jsonData.map((json) => CurrPromoModel.fromJson(json)).toList();

        return allPromos;
      } else {
        throw Exception("Failed to load promotions: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Error fetching promotions: $e");
    }
  }
}
