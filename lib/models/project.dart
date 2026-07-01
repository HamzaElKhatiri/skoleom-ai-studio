enum ProjectStatus { live, building, paused, error }

class Project {
  const Project({
    required this.id,
    required this.name,
    required this.description,
    required this.framework,
    required this.status,
    required this.lastActivity,
    required this.progress,
    required this.deployUrl,
    required this.stack,
  });

  final String id;
  final String name;
  final String description;
  final String framework;
  final ProjectStatus status;
  final String lastActivity;
  final double progress;
  final String deployUrl;
  final List<String> stack;
}
