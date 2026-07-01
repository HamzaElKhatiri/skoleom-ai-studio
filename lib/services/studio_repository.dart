import 'package:skoleom_ai_studio/config/app_config.dart';
import 'package:skoleom_ai_studio/models/studio_models.dart';
import 'package:skoleom_ai_studio/services/api_client.dart';

abstract interface class StudioRepository {
  Future<List<Project>> getProjects();
  Future<List<Agent>> getAgents();
  Future<List<UsageMetric>> getUsage();
  Future<BillingPlan> getCurrentPlan();
  Future<ChatMessage> sendPrompt(String prompt);
  Future<Project> createProject({required String name, required String prompt});
  Future<Project> redeployProject(String projectId);
}

class RepositoryProvider {
  RepositoryProvider._();

  static StudioRepository instance = const MockRepository();

  static void configure(StudioRepository repository) {
    instance = repository;
  }
}

class ApiRepository implements StudioRepository {
  const ApiRepository(this._client);

  final ApiClient _client;

  @override
  Future<List<Project>> getProjects() async {
    final response = await _client.get(AppConfig.projectsEndpoint);
    return _extractList(response, const ['projects', 'items', 'data']).map(Project.fromJson).toList();
  }

  @override
  Future<List<Agent>> getAgents() async {
    final response = await _client.get(AppConfig.agentsEndpoint);
    return _extractList(response, const ['agents', 'items', 'data']).map(Agent.fromJson).toList();
  }

  @override
  Future<List<UsageMetric>> getUsage() async {
    final response = await _client.get(AppConfig.usageEndpoint);
    return _extractList(response, const ['usage', 'metrics', 'items', 'data']).map(UsageMetric.fromJson).toList();
  }

  @override
  Future<BillingPlan> getCurrentPlan() async {
    final response = await _client.get(AppConfig.billingEndpoint);
    return BillingPlan.fromJson(_extractObject(response, const ['plan', 'billing', 'data']));
  }

  @override
  Future<ChatMessage> sendPrompt(String prompt) async {
    final response = await _client.post(AppConfig.chatEndpoint, <String, dynamic>{'message': prompt, 'prompt': prompt});
    final json = _extractObject(response, const ['message', 'assistantMessage', 'chat', 'data']);
    final message = ChatMessage.fromJson(json);
    return message.content.trim().isEmpty ? ChatMessage(id: DateTime.now().microsecondsSinceEpoch.toString(), content: response.toString(), isUser: false, time: DateTime.now()) : message;
  }

  @override
  Future<Project> createProject({required String name, required String prompt}) async {
    final response = await _client.post(AppConfig.projectsEndpoint, <String, dynamic>{'name': name, 'prompt': prompt});
    return Project.fromJson(_extractObject(response, const ['project', 'data']));
  }

  @override
  Future<Project> redeployProject(String projectId) async {
    final response = await _client.post('${AppConfig.projectsEndpoint}/$projectId/deploy', <String, dynamic>{});
    return Project.fromJson(_extractObject(response, const ['project', 'deployment', 'data']));
  }

  List<Map<String, dynamic>> _extractList(dynamic response, List<String> keys) {
    if (response is List) return response.whereType<Map>().map((item) => Map<String, dynamic>.from(item)).toList();
    if (response is Map<String, dynamic>) {
      for (final key in keys) {
        final value = response[key];
        if (value is List) return value.whereType<Map>().map((item) => Map<String, dynamic>.from(item)).toList();
      }
    }
    return <Map<String, dynamic>>[];
  }

  Map<String, dynamic> _extractObject(dynamic response, List<String> keys) {
    if (response is Map<String, dynamic>) {
      for (final key in keys) {
        final value = response[key];
        if (value is Map) return Map<String, dynamic>.from(value);
      }
      return response;
    }
    return <String, dynamic>{'message': response.toString()};
  }
}

class MockRepository implements StudioRepository {
  const MockRepository();

  @override
  Future<List<Project>> getProjects() async {
    await Future<void>.delayed(const Duration(milliseconds: 260));
    return const [
      Project(id: 'p1', name: 'LearnFlow Mobile', description: 'Plateforme micro-learning IA pour cohortes premium.', framework: 'Flutter', status: ProjectStatus.live, lastActivity: 'il y a 8 min', progress: 1, deployUrl: 'learnflow.skoleom.app', stack: ['Flutter', 'Material 3', 'API-ready']),
      Project(id: 'p2', name: 'AgentOps Console', description: 'Dashboard pour piloter agents, jobs et déploiements.', framework: 'Flutter Web', status: ProjectStatus.building, lastActivity: 'il y a 22 min', progress: 0.72, deployUrl: 'agentops.preview.app', stack: ['Flutter', 'Web', 'Responsive']),
      Project(id: 'p3', name: 'Campus CRM', description: 'CRM mobile-first pour équipes pédagogiques.', framework: 'Flutter', status: ProjectStatus.paused, lastActivity: 'hier', progress: 0.43, deployUrl: 'campus-crm.local', stack: ['Flutter', 'API', 'Billing']),
    ];
  }

  @override
  Future<List<Agent>> getAgents() async {
    await Future<void>.delayed(const Duration(milliseconds: 220));
    return const [
      Agent(id: 'a1', name: 'Builder', role: 'Génération de projets Flutter et dashboards', status: AgentStatus.running, tasksToday: 18, successRate: 0.96),
      Agent(id: 'a2', name: 'Reviewer', role: 'Audit UI, sécurité et performance', status: AgentStatus.running, tasksToday: 11, successRate: 0.91),
      Agent(id: 'a3', name: 'Deploy Pilot', role: 'Prépare les previews et checks de livraison', status: AgentStatus.stopped, tasksToday: 4, successRate: 0.88),
    ];
  }

  @override
  Future<List<UsageMetric>> getUsage() async {
    await Future<void>.delayed(const Duration(milliseconds: 180));
    return const [UsageMetric(label: 'Prompts aujourd’hui', used: 74, limit: 120), UsageMetric(label: 'Build minutes', used: 410, limit: 800), UsageMetric(label: 'Déploiements semaine', used: 17, limit: 30)];
  }

  @override
  Future<BillingPlan> getCurrentPlan() async {
    await Future<void>.delayed(const Duration(milliseconds: 180));
    return const BillingPlan(name: 'Hobby', price: '0€ / mois', credits: 2400, features: ['Authentification obligatoire', 'Builds Flutter Web', 'Déploiements preview', 'API-ready']);
  }

  @override
  Future<ChatMessage> sendPrompt(String prompt) async {
    await Future<void>.delayed(const Duration(milliseconds: 620));
    return ChatMessage(id: DateTime.now().microsecondsSinceEpoch.toString(), content: 'Compte authentifié. J’ai analysé ton prompt et je peux maintenant appeler les endpoints protégés de ton API.', isUser: false, time: DateTime.now(), suggestedStack: const ['Auth ready', 'Flutter Web', 'API protected']);
  }

  @override
  Future<Project> createProject({required String name, required String prompt}) async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    return Project(id: DateTime.now().millisecondsSinceEpoch.toString(), name: name, description: prompt, framework: 'Flutter', status: ProjectStatus.building, lastActivity: 'à l’instant', progress: 0.12, deployUrl: 'preview.local', stack: const ['Flutter', 'Responsive Web']);
  }

  @override
  Future<Project> redeployProject(String projectId) async {
    await Future<void>.delayed(const Duration(milliseconds: 320));
    return const Project(id: 'redeploy', name: 'Redéploiement lancé', description: 'Déploiement relancé avec succès.', framework: 'Flutter Web', status: ProjectStatus.building, lastActivity: 'à l’instant', progress: 0.2, deployUrl: 'preview.local', stack: ['Flutter', 'Release']);
  }
}
