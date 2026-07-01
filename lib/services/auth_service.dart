import 'package:skoleom_ai_studio/config/app_config.dart';
import 'package:skoleom_ai_studio/services/api_client.dart';

class AuthService {
  String? _accessToken;
  String? _email;
  String? _plan;

  String? get accessToken => _accessToken ?? (AppConfig.apiToken.trim().isEmpty ? null : AppConfig.apiToken.trim());
  String? get email => _email;
  String? get plan => _plan;
  bool get isAuthenticated => accessToken?.trim().isNotEmpty == true;

  void authenticateWithStaticToken({String? email, String? plan}) {
    _accessToken = AppConfig.apiToken.trim().isNotEmpty ? AppConfig.apiToken.trim() : 'local-preview-token';
    _email = email;
    _plan = plan;
  }

  Future<void> login({required String email, required String password}) async {
    final cleanEmail = email.trim();
    _validateCredentials(cleanEmail, password);

    if (!AppConfig.useApi) {
      authenticateWithStaticToken(email: cleanEmail, plan: 'hobby');
      return;
    }

    if (AppConfig.hasStaticToken) {
      authenticateWithStaticToken(email: cleanEmail, plan: 'hobby');
      return;
    }

    final client = ApiClient(tokenResolver: () => _accessToken);
    final response = await client.post(AppConfig.authLoginEndpoint, <String, dynamic>{
      'email': cleanEmail,
      'password': password,
    });
    _consumeAuthResponse(response, fallbackEmail: cleanEmail, fallbackPlan: 'hobby');
  }

  Future<void> register({required String plan, required String name, required String organization, required String phone, required String email, required String password}) async {
    final cleanEmail = email.trim();
    final cleanPlan = plan.trim().toLowerCase();
    _validateRegistration(plan: cleanPlan, name: name, organization: organization, phone: phone, email: cleanEmail, password: password);

    if (!AppConfig.useApi) {
      authenticateWithStaticToken(email: cleanEmail, plan: cleanPlan);
      return;
    }

    if (AppConfig.hasStaticToken) {
      authenticateWithStaticToken(email: cleanEmail, plan: cleanPlan);
      return;
    }

    final client = ApiClient(tokenResolver: () => _accessToken);
    final response = await client.post(AppConfig.authRegisterEndpoint, <String, dynamic>{
      'plan': cleanPlan,
      'name': name.trim(),
      'organization': organization.trim(),
      'phone': phone.trim(),
      'email': cleanEmail,
      'password': password,
    });
    _consumeAuthResponse(response, fallbackEmail: cleanEmail, fallbackPlan: cleanPlan);
  }

  void logout() {
    _accessToken = null;
    _email = null;
    _plan = null;
  }

  void _validateCredentials(String email, String password) {
    if (email.isEmpty || !email.contains('@')) {
      throw const ApiException(message: 'Email valide requis.', statusCode: 400);
    }
    if (password.trim().length < 6) {
      throw const ApiException(message: 'Mot de passe requis, minimum 6 caractères.', statusCode: 400);
    }
  }

  void _validateRegistration({required String plan, required String name, required String organization, required String phone, required String email, required String password}) {
    if (!const ['hobby', 'pro', 'studio'].contains(plan)) {
      throw const ApiException(message: 'Choisis un plan : Hobby, Pro ou Studio.', statusCode: 400);
    }
    if (name.trim().isEmpty) {
      throw const ApiException(message: 'Nom requis.', statusCode: 400);
    }
    if (organization.trim().isEmpty) {
      throw const ApiException(message: 'Organisation requise.', statusCode: 400);
    }
    if (phone.trim().isEmpty) {
      throw const ApiException(message: 'Téléphone requis.', statusCode: 400);
    }
    _validateCredentials(email, password);
  }

  void _consumeAuthResponse(dynamic response, {required String fallbackEmail, required String fallbackPlan}) {
    if (response is Map<String, dynamic>) {
      final data = response['data'];
      final auth = response['auth'];
      final user = response['user'];
      final token = response['accessToken'] ?? response['token'] ?? response['jwt'] ?? (data is Map ? data['accessToken'] ?? data['token'] ?? data['jwt'] : null) ?? (auth is Map ? auth['accessToken'] ?? auth['token'] ?? auth['jwt'] : null);
      if (token != null && token.toString().trim().isNotEmpty) {
        _accessToken = token.toString().trim();
        _email = _extractString(response['email']) ?? _extractString(user is Map ? user['email'] : null) ?? _extractString(data is Map ? data['email'] : null) ?? fallbackEmail;
        _plan = _extractString(response['plan']) ?? _extractString(user is Map ? user['plan'] : null) ?? _extractString(data is Map ? data['plan'] : null) ?? fallbackPlan;
        return;
      }
    }
    throw const ApiException(message: 'Token absent dans la réponse d’authentification.', statusCode: 401);
  }

  String? _extractString(Object? value) {
    final text = value?.toString().trim() ?? '';
    return text.isEmpty ? null : text;
  }
}
