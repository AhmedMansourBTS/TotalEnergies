import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:total_energies/models/service_station_model.dart';

class GetStationsByServiceCodeService {
  static const String baseUrl =
      'https://www.besttopsystems.net:4336/api/Service/GetStationsByServiceCode/';

  static Future<List<ServiceStationModel>> fetchStationsByServiceCode(
      int serviceCode) async {
    final response = await http.get(Uri.parse('$baseUrl$serviceCode'));

    if (response.statusCode == 200) {
      final dynamic data = json.decode(response.body);
      final List<dynamic> dataList = data is List ? data : [data];
      return dataList
          .map((json) =>
              ServiceStationModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception('Failed to load stations for service');
    }
  }
}