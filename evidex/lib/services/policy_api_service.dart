import 'dart:convert';
import 'package:evidex/models/policy_analysis_model.dart';
import 'package:http/http.dart' as http;
import '../models/policy_model.dart';

class PolicyApiService {
  static const String _baseUrl = 'http://10.10.147.195:8000/api/v1';

  static Future<List<PolicyModel>> fetchPolicies(String state) async {
    final res = await http.get(Uri.parse('$_baseUrl/policy/$state'));

    if (res.statusCode != 200) {
      throw Exception('Failed to load policies');
    }

    final List data = jsonDecode(res.body);
    return data.map((e) => PolicyModel.fromJson(e)).toList();
  }

  /// POST analysis for selected policy
  static Future<PolicyAnalysisModel> analyzePolicy({
    required String state,
    required String policyTitle,
    required Map<String, double> index,
  }) async {
    final res = await http.post(
      Uri.parse('$_baseUrl/analysis/$state'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({"policy": policyTitle, "index": index}),
    );
    print(res.body);

    if (res.statusCode != 200) {
      throw Exception('Analysis failed');
    }
    return PolicyAnalysisModel.fromJson(jsonDecode(res.body));
  }
}
