enum AgentStatus { running, stopped, draft }

class Agent {
  const Agent({
    required this.id,
    required this.name,
    required this.role,
    required this.status,
    required this.tasksToday,
    required this.successRate,
  });

  final String id;
  final String name;
  final String role;
  final AgentStatus status;
  final int tasksToday;
  final double successRate;

  factory Agent.fromJson(Map<String, dynamic> json) {
    return Agent(
      id: (json['id'] ?? json['_id'] ?? json['uuid'] ?? '').toString(),
      name: (json['name'] ?? json['title'] ?? 'Agent IA').toString(),
      role: (json['role'] ?? json['description'] ?? json['systemPrompt'] ?? '').toString(),
      status: AgentStatusParser.fromValue(json['status'] ?? json['state']),
      tasksToday: _parseInt(json['tasksToday'] ?? json['dailyTasks'] ?? json['tasks_count']),
      successRate: _parseRatio(json['successRate'] ?? json['success_rate'] ?? json['score']),
    );
  }

  static int _parseInt(Object? value) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse(value?.toString() ?? '') ?? 0;
  }

  static double _parseRatio(Object? value) {
    if (value is num) {
      final numeric = value.toDouble();
      return numeric > 1 ? (numeric / 100).clamp(0.0, 1.0) : numeric.clamp(0.0, 1.0);
    }
    return 0;
  }
}

class AgentStatusParser {
  const AgentStatusParser._();

  static AgentStatus fromValue(Object? value) {
    final normalized = value?.toString().toLowerCase().trim() ?? '';
    if (normalized.contains('run') || normalized.contains('active') || normalized.contains('online')) return AgentStatus.running;
    if (normalized.contains('draft') || normalized.contains('new')) return AgentStatus.draft;
    return AgentStatus.stopped;
  }
}
