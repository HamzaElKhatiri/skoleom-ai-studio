import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:skoleom_ai_studio/config/app_config.dart';

class ApiClient {
  ApiClient({required this.tokenResolver, http.Client? httpClient}) : _httpClient = httpClient ?? http.Client();

  final String? Function() tokenResolver;
  final http.Client _httpClient;

  Future<dynamic> get(String endpoint) async {
    final response = await _httpClient.get(AppConfig.endpoint(endpoint), headers: _headers());
    return _decode(response);
  }

  Future<dynamic> post(String endpoint, Map<String, dynamic> body) async {
    final response = await _httpClient.post(AppConfig.endpoint(endpoint), headers: _headers(), body: jsonEncode(body));
    return _decode(response);
  }

  Map<String, String> _headers() {
    final token = tokenResolver()?.trim();
    return <String, String>{
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
      if (AppConfig.apiToken.trim().isNotEmpty) 'X-API-Key': AppConfig.apiToken.trim(),
    };
  }

  dynamic _decode(http.Response response) {
    final body = response.body.trim();
    final decoded = body.isEmpty ? <String, dynamic>{} : jsonDecode(body);
    if (response.statusCode < 200 || response.statusCode >= 300) {
      final message = decoded is Map<String, dynamic>
          ? (decoded['message'] ?? decoded['error'] ?? decoded['detail'] ?? 'Erreur API ${response.statusCode}').toString()
          : 'Erreur API ${response.statusCode}';
      throw ApiException(message: message, statusCode: response.statusCode);
    }
    return decoded;
  }
}

class ApiException implements Exception {
  const ApiException({required this.message, required this.statusCode});

  final String message;
  final int statusCode;

  @override
  String toString() => message;
}
