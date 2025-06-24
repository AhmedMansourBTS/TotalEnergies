import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:total_energies/models/promotions_model.dart';

// class PromotionsService {
//   // final String apiUrl =
//   //     "http://92.204.139.204:4335/api/PromotionEvent/GetValidPromotion";
//   final String apiUrl =
//       "https://www.besttopsystems.net:4336/api/PromotionEvent/GetValidPromotions";

//   Future<List<PromotionsModel>> getPromotions() async {
//     final response = await http.get(Uri.parse(apiUrl));
//     print("Request URL: $apiUrl");
//     print('Status Code: ${response.statusCode}');
//     print('Body: ${response.body}');

//     try {
//       if (response.statusCode == 200) {
//         List<dynamic> jsonResponse = jsonDecode(response.body);
//         // var firstPromo = jsonResponse.first;
//         // print('First promo data: $firstPromo');
//       // var data =  PromotionsModel.fromJson(jsonResponse[0]).toList();
//       // print(data);
//       // return data;
//       var data = jsonResponse
//             .map((promo) => PromotionsModel.fromJson(promo))
//             .toList();
//       return data;
//         // return jsonResponse
//         //     .map((promo) => PromotionsModel.fromJson(promo))
//         //     .toList();
//       } else {
//         print("Error: Server returned ${response.statusCode}");
//         throw Exception("Failed to load promotions.");
//       }
//     } catch (e) {
//       // throw Exception('Error fetching promotions: $e');
//       print('Error fetching promotions: $e');
//       throw Exception('Error fetching promotions: $e');
//     }
//   }
// }

class PromotionsService {
  final String apiUrl =
      "https://www.besttopsystems.net:4336/api/PromotionEvent/GetValidPromotions";

  Future<List<PromotionsModel>> getPromotions() async {
    try {
      final response = await http.get(Uri.parse(apiUrl));
      print("(All) Request URL: $apiUrl");
      print('(All) Status Code: ${response.statusCode}');
      print('(All) Response body: ${response.body}');

      if (response.statusCode == 200) {
        // return PromotionsModel.fromJson(response.body)
        final List<dynamic> jsonResponse = jsonDecode(response.body);
        final promotions = jsonResponse
            .map((promo) => PromotionsModel.fromJson(promo))
            .toList();
        print("(All) Promotions: ${promotions}");
        return promotions;
      } else {
        print("(All) Server error: ${response.statusCode}");
        throw Exception("Failed to load promotions.");
      }
    } catch (e) {
      print('Exception occurred: $e');
      throw Exception('Error fetching promotions: $e');
    }
  }
}

// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:total_energies/models/promotions_model.dart';

// class PromotionsService {
//   final String _apiUrl =
//       'https://www.besttopsystems.net:4336/api/PromotionEvent/GetValidPromotions';

//   Future<List<PromotionsModel>> getPromotions() async {
//     final uri = Uri.parse(_apiUrl);

//     try {
//       final response = await http.get(uri);
//       print("Request URL: $uri");
//       print('Status Code: ${response.statusCode}');
//       print('Body: ${response.body}');

//       if (response.statusCode == 200) {
//         final List<dynamic> jsonData = json.decode(response.body);
//         return jsonData.map((e) => PromotionsModel.fromJson(e)).toList();
//       } else {
//         throw Exception(
//             'Failed to load promotions. Status code: ${response.statusCode}');
//       }
//     } catch (e) {
//       throw Exception('Error fetching promotions: $e');
//     }
//   }
// }
