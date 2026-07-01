import 'package:skoleom_ai_studio/config/app_config.dart';
import 'package:skoleom_ai_studio/models/agent.dart';
import 'package:skoleom_ai_studio/models/chat_message.dart';
import 'package:skoleom_ai_studio/models/project.dart';
import 'package:skoleom_ai_studio/models/usage.dart';
import 'package:skoleom_ai_studio/services/api_client.dart';
import 'package:skoleom_ai_studio/services/studio_repository.dart';

class ApiRepository implements StudioRepository {
  const ApiRepository(this._client);

  final ApiClient _client;

  @override
  Future<List<Project>> getProjects() async {
    final response = await _client.get(AppConfig.projectsEndpoint);
    return _extractList(response, keys: const ['projects', 'items', 'data']).map((json) => Project.fromJson(json)).toList();
  }

  @override
  Future<List<Agent>> getAgents() async {
    final response = await _client.get(AppConfig.agentsEndpoint);
    return _extractList(response, keys: const ['agents', 'items', 'data']).map((json) => Agent.fromJson(json)).toList();
  }

  @override
  Future<List<UsageMetric>> getUsage() async {
    final response = await _client.get(AppConfig.usageEndpoint);
    return _extractList(response, keys: const ['usage', 'metrics', 'items', 'data']).map((json) => UsageMetric.fromJson(json)).toList();
  }

  @override
  Future<BillingPlan> getCurrentPlan() async {
    final response = await _client.get(AppConfig.billingEndpoint);
    final json = _extractObject(response, keys: const ['plan', 'billing', 'data']);
    return BillingPlan.fromJson(json);
  }

  @override
  Future<ChatMessage> sendPrompt(String prompt) async {
    final response = await _client.post(AppConfig.chatEndpoint, <String, dynamic>{
      'message': prompt,
      'prompt': prompt,
    });
    final json = _extractObject(response, keys: const ['message', 'assistantMessage', 'chat', 'data']);
    return ChatMessage.fromJson(json).content.trim().isEmpty
        ? ChatMessage(id: DateTime.now().microsecondsSinceEpoch.toString(), content: response.toString(), isUser: false, time: DateTime.now())
        : ChatMessage.fromJson(json);
  }

  @override
  Future<Project> createProject({required String name, required String prompt}) async {
    final response = await _client.post(AppConfig.projectsEndpoint, <String, dynamic>{
      'name': name,
      'prompt': prompt,
    });
    return Project.fromJson(_extractObject(response, keys: const ['project', 'data']));
  }

  @override
  Future<Project> redeployProject(String projectId) async {
    final response = await _client.post('${AppConfig.projectsEndpoint}/$projectId/deploy', <String, dynamic>{});
    return Project.fromJson(_extractObject(response, keys: const ['project', 'deployment', 'data']));
  }

  List<Map<String, dynamic>> _extractList(dynamic response, {required List<String> keys}) {
    if (response is List) {
      return response.whereType<Map>().map((item) => Map<String, dynamic>.from(item)).toList();
    }
    if (response is Map<String, dynamic>) {
      for (final key in keys) {
        final value = response[key];
        if (value is List) {
          return value.whereType<Map>().map((item) => Map<String, dynamic>.from(item)).toList();
        }
      }
    }
    return <Map<String, dynamic>>[];
  }

  Map<String, dynamic> _extractObject(dynamic response, {required List<String> keys}) {
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
