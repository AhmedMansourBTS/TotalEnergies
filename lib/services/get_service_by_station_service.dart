import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:total_energies/models/service_by_station_model.dart';

class GetStationServices {
  static Future<List<StationServiceModel>> fetchActiveServicesByStation(int stationSerial) async {
    final url = Uri.parse('https://www.besttopsystems.net:4336/api/Service/GetServicesByStationSerial/$stationSerial');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      
      return data
          .map((json) => StationServiceModel.fromJson(json))
          .where((service) => service.validYN == true) // only active services
          .toList();
    } else {
      throw Exception('Failed to load station services');
    }
  }
}
