class AppConfig {
  const AppConfig._();

  static const String apiBaseUrl = String.fromEnvironment('SKOLEOM_API_BASE_URL', defaultValue: '');
  static const String apiToken = String.fromEnvironment('SKOLEOM_API_TOKEN', defaultValue: '');
  static const String authLoginEndpoint = String.fromEnvironment('SKOLEOM_AUTH_LOGIN_ENDPOINT', defaultValue: '/auth/login');
  static const String projectsEndpoint = String.fromEnvironment('SKOLEOM_PROJECTS_ENDPOINT', defaultValue: '/projects');
  static const String agentsEndpoint = String.fromEnvironment('SKOLEOM_AGENTS_ENDPOINT', defaultValue: '/agents');
  static const String usageEndpoint = String.fromEnvironment('SKOLEOM_USAGE_ENDPOINT', defaultValue: '/usage');
  static const String billingEndpoint = String.fromEnvironment('SKOLEOM_BILLING_ENDPOINT', defaultValue: '/billing/current-plan');
  static const String chatEndpoint = String.fromEnvironment('SKOLEOM_CHAT_ENDPOINT', defaultValue: '/chat');

  static bool get useApi => apiBaseUrl.trim().isNotEmpty;
  static bool get hasStaticToken => apiToken.trim().isNotEmpty;

  static Uri endpoint(String path) {
    final normalizedBase = apiBaseUrl.endsWith('/') ? apiBaseUrl.substring(0, apiBaseUrl.length - 1) : apiBaseUrl;
    if (path.startsWith('http://') || path.startsWith('https://')) {
      return Uri.parse(path);
    }
    final normalizedPath = path.startsWith('/') ? path : '/$path';
    return Uri.parse('$normalizedBase$normalizedPath');
  }
}
