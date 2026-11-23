import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'http://10.0.2.2/api-test/public';
  
  static Future<Map<String, dynamic>> saveMembreMultipart({
  int? id,
  required Map<String, String> fields,
  String? imagePath,
}) async {
  final String url = id == null
      ? '$baseUrl/famille-membres'
      : '$baseUrl/famille-membres/$id';

  final request = http.MultipartRequest('POST', Uri.parse(url));
  request.fields.addAll(fields);

  if (imagePath != null && imagePath.isNotEmpty) {
    request.files.add(
      await http.MultipartFile.fromPath('image', imagePath),
    );
  }

  final streamedResponse = await request.send();
  final responseBody = await streamedResponse.stream.bytesToString();
  return jsonDecode(responseBody) as Map<String, dynamic>;
}
  static Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/accounts/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email.trim(),
        'password': password,
      }),
    );

    final data = jsonDecode(response.body) as Map<String, dynamic>;
    return {
      'statusCode': response.statusCode,
      'success': data['success'] == true,
      'message': data['message'] ?? 'Réponse inattendue',
      'data': data['data'],
      'errors': data['errors'],
    };
  }

  static Future<Map<String, dynamic>> register({
    required String email,
    required String password,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/accounts/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email.trim(),
        'password': password,
      }),
    );

    final data = jsonDecode(response.body) as Map<String, dynamic>;
    return {
      'statusCode': response.statusCode,
      'success': data['success'] == true,
      'message': data['message'] ?? 'Réponse inattendue',
      'data': data['data'],
      'errors': data['errors'],
    };
  }
  static Future<List<dynamic>> getMembres() async {
  final response = await http.get(Uri.parse('$baseUrl/famille-membres'));
  final data = jsonDecode(response.body) as Map<String, dynamic>;
  if (response.statusCode == 200 && data['success'] == true) {
    return data['data'] is List ? data['data'] : [];
  }
  throw Exception(data['message'] ?? 'Erreur lors du chargement des membres');
}

static Future<Map<String, dynamic>> createMembreJson(Map<String, dynamic> body) async {
  final response = await http.post(
    Uri.parse('$baseUrl/famille-membres'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode(body),
  );
  return jsonDecode(response.body) as Map<String, dynamic>;
}

static Future<Map<String, dynamic>> updateMembreJson(int id, Map<String, dynamic> body) async {
  final response = await http.put(
    Uri.parse('$baseUrl/famille-membres/$id'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode(body),
  );
  return jsonDecode(response.body) as Map<String, dynamic>;
}

static Future<Map<String, dynamic>> deleteMembre(int id) async {
  final response = await http.delete(Uri.parse('$baseUrl/famille-membres/$id'));
  return jsonDecode(response.body) as Map<String, dynamic>;
 }
}