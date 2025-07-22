import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:total_energies/models/news_model.dart';

class GetNewsService {
  static const String _baseUrl = 'https://www.besttopsystems.net:4336/api/News/GetAvailable';

  static Future<List<NewsModel>> fetchNews() async {
    final response = await http.get(Uri.parse(_baseUrl));

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);
      return jsonData.map((item) => NewsModel.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load news');
    }
  }
}
