enum ProjectStatus { live, building, paused, error }

enum AgentStatus { running, stopped, draft }

class Project {
  const Project({required this.id, required this.name, required this.description, required this.framework, required this.status, required this.lastActivity, required this.progress, required this.deployUrl, required this.stack});

  final String id;
  final String name;
  final String description;
  final String framework;
  final ProjectStatus status;
  final String lastActivity;
  final double progress;
  final String deployUrl;
  final List<String> stack;

  factory Project.fromJson(Map<String, dynamic> json) {
    final rawStack = json['stack'] ?? json['technologies'] ?? const <dynamic>[];
    final stack = rawStack is List ? rawStack.map((item) => item.toString()).toList() : <String>[];
    return Project(
      id: (json['id'] ?? json['_id'] ?? '').toString(),
      name: (json['name'] ?? json['title'] ?? 'Projet sans nom').toString(),
      description: (json['description'] ?? json['summary'] ?? '').toString(),
      framework: (json['framework'] ?? (stack.isNotEmpty ? stack.first : 'Flutter')).toString(),
      status: ProjectStatusParser.fromValue(json['status']),
      lastActivity: (json['lastActivity'] ?? json['updatedAt'] ?? 'activité récente').toString(),
      progress: RatioParser.parse(json['progress'] ?? json['completion']),
      deployUrl: (json['deployUrl'] ?? json['previewUrl'] ?? json['url'] ?? '').toString(),
      stack: stack,
    );
  }
}

class Agent {
  const Agent({required this.id, required this.name, required this.role, required this.status, required this.tasksToday, required this.successRate});

  final String id;
  final String name;
  final String role;
  final AgentStatus status;
  final int tasksToday;
  final double successRate;

  factory Agent.fromJson(Map<String, dynamic> json) {
    return Agent(
      id: (json['id'] ?? json['_id'] ?? '').toString(),
      name: (json['name'] ?? 'Agent IA').toString(),
      role: (json['role'] ?? json['description'] ?? '').toString(),
      status: AgentStatusParser.fromValue(json['status']),
      tasksToday: IntParser.parse(json['tasksToday'] ?? json['dailyTasks']),
      successRate: RatioParser.parse(json['successRate'] ?? json['score']),
    );
  }
}

class ChatMessage {
  const ChatMessage({required this.id, required this.content, required this.isUser, required this.time, this.suggestedStack = const []});

  final String id;
  final String content;
  final bool isUser;
  final DateTime time;
  final List<String> suggestedStack;

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    final rawStack = json['suggestedStack'] ?? json['stack'] ?? const <dynamic>[];
    final role = (json['role'] ?? json['sender'] ?? '').toString().toLowerCase();
    return ChatMessage(
      id: (json['id'] ?? DateTime.now().microsecondsSinceEpoch).toString(),
      content: (json['content'] ?? json['message'] ?? json['response'] ?? json['text'] ?? '').toString(),
      isUser: json['isUser'] == true || role.contains('user'),
      time: DateTime.tryParse((json['createdAt'] ?? '').toString()) ?? DateTime.now(),
      suggestedStack: rawStack is List ? rawStack.map((item) => item.toString()).toList() : const [],
    );
  }
}

class UsageMetric {
  const UsageMetric({required this.label, required this.used, required this.limit});

  final String label;
  final int used;
  final int limit;

  double get ratio => limit <= 0 ? 0 : (used / limit).clamp(0.0, 1.0);

  factory UsageMetric.fromJson(Map<String, dynamic> json) {
    return UsageMetric(label: (json['label'] ?? json['name'] ?? 'Usage').toString(), used: IntParser.parse(json['used'] ?? json['value']), limit: IntParser.parse(json['limit'] ?? json['max']));
  }
}

class BillingPlan {
  const BillingPlan({required this.name, required this.price, required this.credits, required this.features});

  final String name;
  final String price;
  final int credits;
  final List<String> features;

  factory BillingPlan.fromJson(Map<String, dynamic> json) {
    final rawFeatures = json['features'] ?? const <dynamic>[];
    return BillingPlan(name: (json['name'] ?? 'Plan actif').toString(), price: (json['price'] ?? '').toString(), credits: IntParser.parse(json['credits']), features: rawFeatures is List ? rawFeatures.map((item) => item.toString()).toList() : const []);
  }
}

class ProjectStatusParser {
  const ProjectStatusParser._();

  static ProjectStatus fromValue(Object? value) {
    final text = value?.toString().toLowerCase() ?? '';
    if (text.contains('live') || text.contains('success') || text.contains('ready')) return ProjectStatus.live;
    if (text.contains('pause') || text.contains('draft')) return ProjectStatus.paused;
    if (text.contains('error') || text.contains('fail')) return ProjectStatus.error;
    return ProjectStatus.building;
  }
}

class AgentStatusParser {
  const AgentStatusParser._();

  static AgentStatus fromValue(Object? value) {
    final text = value?.toString().toLowerCase() ?? '';
    if (text.contains('run') || text.contains('active') || text.contains('online')) return AgentStatus.running;
    if (text.contains('draft')) return AgentStatus.draft;
    return AgentStatus.stopped;
  }
}

class RatioParser {
  const RatioParser._();

  static double parse(Object? value) {
    if (value is num) {
      final parsed = value.toDouble();
      return parsed > 1 ? (parsed / 100).clamp(0.0, 1.0) : parsed.clamp(0.0, 1.0);
    }
    return 0;
  }
}

class IntParser {
  const IntParser._();

  static int parse(Object? value) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse(value?.toString() ?? '') ?? 0;
  }
}
