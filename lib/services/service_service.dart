import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:total_energies/models/service_model.dart';

class GetAllServicesService {
  static const String _baseUrl =
      'https://www.besttopsystems.net:4336/api/Service/getallServices';

  static Future<List<ServiceModel>> fetchAllServices() async {
    final response = await http.get(Uri.parse(_baseUrl));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => ServiceModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load services');
    }
  }
}
