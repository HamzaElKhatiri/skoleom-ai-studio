import 'dart:convert';

import 'package:skoleom_ai_studio/config/app_config.dart';
import 'package:skoleom_ai_studio/services/http_transport.dart';

class ApiClient {
  ApiClient({String? Function()? tokenResolver, HttpTransport? transport}) : _tokenResolver = tokenResolver, _transport = transport ?? HttpTransport();

  final String? Function()? _tokenResolver;
  final HttpTransport _transport;

  Future<dynamic> get(String endpoint) async {
    final response = await _transport.send(method: 'GET', uri: AppConfig.endpoint(endpoint), headers: _headers());
    return _decode(response.statusCode, response.body);
  }

  Future<dynamic> post(String endpoint, Map<String, dynamic> body) async {
    final response = await _transport.send(method: 'POST', uri: AppConfig.endpoint(endpoint), headers: _headers(), body: jsonEncode(body));
    return _decode(response.statusCode, response.body);
  }

  Map<String, String> _headers() {
    final token = (_tokenResolver?.call() ?? AppConfig.apiToken).trim();
    return <String, String>{
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      if (token.isNotEmpty) 'Authorization': 'Bearer $token',
      if (AppConfig.apiToken.trim().isNotEmpty) 'X-API-Key': AppConfig.apiToken.trim(),
    };
  }

  dynamic _decode(int statusCode, String body) {
    final trimmed = body.trim();
    final dynamic decoded = trimmed.isEmpty ? <String, dynamic>{} : _safeJson(trimmed);
    if (statusCode < 200 || statusCode >= 300) {
      final message = decoded is Map<String, dynamic> ? (decoded['message'] ?? decoded['error'] ?? 'Erreur API $statusCode').toString() : 'Erreur API $statusCode';
      throw ApiException(message: message, statusCode: statusCode);
    }
    return decoded;
  }

  dynamic _safeJson(String source) {
    try {
      return jsonDecode(source);
    } catch (_) {
      return source;
    }
  }
}

class ApiException implements Exception {
  const ApiException({required this.message, required this.statusCode});

  final String message;
  final int statusCode;

  @override
  String toString() => message;
}
