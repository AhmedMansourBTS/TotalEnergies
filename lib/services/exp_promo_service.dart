import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:total_energies/models/exp_promo_model.dart';

class ExpiredPromoService {
  Future<List<ExpiredPromoModel>> getExpiredPromotions() async {
    final prefs = await SharedPreferences.getInstance();
    final customerSerial = prefs.getInt('serial');

    if (customerSerial == null) {
      throw Exception('Customer serial not found in SharedPreferences');
    }

    final url = Uri.parse(
      'https://www.besttopsystems.net:4336/api/PromotionEvent/GetAllCustomerExpiredPromotions?customerCode=$customerSerial',
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((item) => ExpiredPromoModel.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load expired promotions');
    }
  }
}
