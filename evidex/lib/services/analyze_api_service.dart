import 'dart:convert';
import 'package:http/http.dart' as http;

class AnalyzeApiService {
  static const String _baseUrl =
      'http://10.10.147.195:8000/api/v1';

  static Future<String> analyzePolicy({
    required String lens,
    required String state,
    required String policy,
    required List<String> chatHistory,
    required String query,
  }) async {
    final res = await http.post(
      Uri.parse('$_baseUrl/lens'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "persona": lens,
        "state": state,
        "policy": policy,
        "history": chatHistory,
        "query": query,
      }),
    );
    print(res.body);

    if (res.statusCode != 200) {
      throw Exception("Analyze request failed");
    }

    final data = jsonDecode(res.body);

    return data['response']?.toString() ?? "";
  }
}
