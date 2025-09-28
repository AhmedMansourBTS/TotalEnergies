import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:total_energies/models/ads_model.dart';

class AdvertisementService {
  final String baseUrl =
      "https://www.besttopsystems.net:4336/api/Advertisement/GetAll";

  Future<List<AdvertisementModel>> fetchAdvertisements() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((item) => AdvertisementModel.fromJson(item)).toList();
    } else {
      throw Exception("Failed to load advertisements");
    }
  }
}
