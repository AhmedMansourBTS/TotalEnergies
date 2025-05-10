import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:total_energies/models/categories_promotion_model.dart';

class GetCategPromoService {
  static const String baseUrl =
      'https://www.besttopsystems.net:4336/api/PromotionEvent/GetValidPromotionsByCategory';

  static Future<List<CategoriesPromotionModel>> getPromotionsByCategory(
      int categoryId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/$categoryId'),
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body);
      return jsonList.map((e) => CategoriesPromotionModel.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load promotions for category $categoryId');
    }
  }
}
