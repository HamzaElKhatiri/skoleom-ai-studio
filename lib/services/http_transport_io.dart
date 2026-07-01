import 'dart:convert';
import 'dart:io';

class TransportResponse {
  const TransportResponse({required this.statusCode, required this.body});

  final int statusCode;
  final String body;
}

class HttpTransport {
  final HttpClient _client = HttpClient();

  Future<TransportResponse> send({required String method, required Uri uri, required Map<String, String> headers, String? body}) async {
    final request = await _client.openUrl(method, uri);
    headers.forEach(request.headers.set);
    if (body != null) {
      request.write(body);
    }
    final response = await request.close();
    final text = await response.transform(utf8.decoder).join();
    return TransportResponse(statusCode: response.statusCode, body: text);
  }
}
