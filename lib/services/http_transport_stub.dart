class TransportResponse {
  const TransportResponse({required this.statusCode, required this.body});

  final int statusCode;
  final String body;
}

class HttpTransport {
  Future<TransportResponse> send({required String method, required Uri uri, required Map<String, String> headers, String? body}) async {
    throw UnsupportedError('HTTP transport indisponible sur cette plateforme.');
  }
}
