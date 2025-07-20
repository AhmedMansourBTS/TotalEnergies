import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:total_energies/models/service_by_station_model.dart';

class GetServicesByStationSerialService {
  static const String baseUrl =
      'https://www.besttopsystems.net:4336/api/Service/GetServicesByStationSerial/';

  static Future<List<StationServiceModel>> fetchServicesByStationSerial(
      int stationSerial) async {
    final response = await http.get(Uri.parse('$baseUrl$stationSerial'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data
          .map((json) =>
              StationServiceModel.fromJson(json as Map<String, dynamic>))
          .where((service) => service.validYN)
          .toList();
    } else {
      throw Exception(
          'Failed to load services for station serial $stationSerial');
    }
  }
}
