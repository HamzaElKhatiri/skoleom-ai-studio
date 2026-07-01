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
}
