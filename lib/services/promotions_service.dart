import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:total_energies/models/promotions_model.dart';

class PromotionsService {
  // final String apiUrl =
  //     "http://92.204.139.204:4335/api/PromotionEvent/GetValidPromotion";
  final String apiUrl =
      "https://www.besttopsystems.net:4336/api/PromotionEvent/GetValidPromotions";

  Future<List<PromotionsModel>> getPromotions() async {
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = jsonDecode(response.body);
      return jsonResponse
          .map((promo) => PromotionsModel.fromJson(promo))
          .toList();
    } else {
      throw Exception("Failed to load promotions");
    }
  }
}
