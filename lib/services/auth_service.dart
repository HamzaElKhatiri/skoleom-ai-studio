import 'package:skoleom_ai_studio/config/app_config.dart';
import 'package:skoleom_ai_studio/services/api_client.dart';

class AuthService {
  String? _accessToken;

  String? get accessToken => _accessToken ?? (AppConfig.apiToken.trim().isEmpty ? null : AppConfig.apiToken.trim());

  void authenticateWithStaticToken() {
    _accessToken = AppConfig.apiToken.trim();
  }

  Future<void> login({required String email, required String password}) async {
    if (!AppConfig.useApi) {
      _accessToken = 'local-preview-token';
      return;
    }

    if (AppConfig.hasStaticToken) {
      authenticateWithStaticToken();
      return;
    }

    if (email.trim().isEmpty || password.trim().isEmpty) {
      throw const ApiException(message: 'Email et mot de passe requis pour l’API configurée.', statusCode: 400);
    }

    final client = ApiClient(tokenResolver: () => _accessToken);
    final response = await client.post(AppConfig.authLoginEndpoint, <String, dynamic>{
      'email': email.trim(),
      'password': password,
    });

    if (response is Map<String, dynamic>) {
      final token = response['accessToken'] ?? response['token'] ?? response['jwt'] ?? response['data']?['accessToken'] ?? response['data']?['token'];
      if (token != null && token.toString().trim().isNotEmpty) {
        _accessToken = token.toString();
        return;
      }
    }

    throw const ApiException(message: 'Token absent dans la réponse de connexion.', statusCode: 401);
  }
}
