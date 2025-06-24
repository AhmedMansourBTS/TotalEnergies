import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:total_energies/models/governorate_model.dart';

class GovernorateService {
  static const String _url =
      "https://www.besttopsystems.net:4336/api/Governorate/GetAll";

  static Future<List<GovernorateModel>> getAllGovernorates() async {
    try {
      final response = await http
          .get(Uri.parse(_url))
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = jsonDecode(response.body);
        return jsonList
            .map((json) => GovernorateModel.fromJson(json))
            .toList();
      } else {
        throw Exception('Failed to load governorates');
      }
    } catch (e) {
      throw Exception('Error fetching governorates: $e');
    }
  }

  getGovernorates() {}
}
