import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/news_model.dart';

class NewsApiService {
  static const String _baseUrl =
      'http://10.10.147.195:8000/api/v1/news';

  static Future<List<NewsModel>> fetchNews(String category) async {
    final url = Uri.parse('$_baseUrl/$category');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        print('News API Response: ${response.body}');
        final List data = jsonDecode(response.body);
        return data
            .map((json) => NewsModel.fromJson(json))
            .toList();
      } else {
        print('Error hai: ${response.statusCode}');
        throw Exception(
            'Failed to load news (${response.statusCode})');
      }
    } catch (e) {
      print('Exception caught: $e');
      throw Exception('Error fetching news: $e');
    }
  }
}
