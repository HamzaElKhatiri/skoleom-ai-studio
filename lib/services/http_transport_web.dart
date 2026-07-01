import 'dart:html' as html;

class TransportResponse {
  const TransportResponse({required this.statusCode, required this.body});

  final int statusCode;
  final String body;
}

class HttpTransport {
  Future<TransportResponse> send({required String method, required Uri uri, required Map<String, String> headers, String? body}) async {
    final response = await html.HttpRequest.request(uri.toString(), method: method, requestHeaders: headers, sendData: body);
    return TransportResponse(statusCode: response.status ?? 0, body: response.responseText ?? '');
  }
}
