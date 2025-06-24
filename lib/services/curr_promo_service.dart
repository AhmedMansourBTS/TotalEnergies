import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/curr_promo_model.dart';

class GetCurrPromoService {
  final String baseUrl =
      "https://www.besttopsystems.net:4336/api/PromotionEvent/GetAllValidPormotionByCustomerSerial";

  Future<List<CurrPromoModel>> getCurrPromotion() async {
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

    // final response = await http.get(url);

    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList.map((e) => CurrPromoModel.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load promotions');
    }
  }
}
