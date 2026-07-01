import 'package:skoleom_ai_studio/models/agent.dart';
import 'package:skoleom_ai_studio/models/chat_message.dart';
import 'package:skoleom_ai_studio/models/project.dart';
import 'package:skoleom_ai_studio/models/usage.dart';

abstract interface class StudioRepository {
  Future<List<Project>> getProjects();
  Future<List<Agent>> getAgents();
  Future<List<UsageMetric>> getUsage();
  Future<BillingPlan> getCurrentPlan();
  Future<ChatMessage> sendPrompt(String prompt);
  Future<Project> createProject({required String name, required String prompt});
  Future<Project> redeployProject(String projectId);
}
