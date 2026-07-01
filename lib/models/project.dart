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

  factory Project.fromJson(Map<String, dynamic> json) {
    final rawStack = json['stack'] ?? json['technologies'] ?? json['frameworks'] ?? const <dynamic>[];
    final stack = rawStack is List ? rawStack.map((item) => item.toString()).toList() : <String>[];
    return Project(
      id: (json['id'] ?? json['_id'] ?? json['uuid'] ?? '').toString(),
      name: (json['name'] ?? json['title'] ?? 'Projet sans nom').toString(),
      description: (json['description'] ?? json['summary'] ?? '').toString(),
      framework: (json['framework'] ?? json['type'] ?? (stack.isNotEmpty ? stack.first : 'Flutter')).toString(),
      status: ProjectStatusParser.fromValue(json['status']),
      lastActivity: _formatActivity(json['lastActivity'] ?? json['updatedAt'] ?? json['createdAt']),
      progress: _parseProgress(json['progress'] ?? json['completion'] ?? json['buildProgress']),
      deployUrl: (json['deployUrl'] ?? json['deploymentUrl'] ?? json['previewUrl'] ?? json['url'] ?? '').toString(),
      stack: stack,
    );
  }

  static double _parseProgress(Object? value) {
    if (value is num) {
      final numeric = value.toDouble();
      return numeric > 1 ? (numeric / 100).clamp(0.0, 1.0) : numeric.clamp(0.0, 1.0);
    }
    return 0;
  }

  static String _formatActivity(Object? value) {
    if (value == null) return 'activité récente';
    final parsed = DateTime.tryParse(value.toString());
    if (parsed == null) return value.toString();
    final diff = DateTime.now().difference(parsed.toLocal());
    if (diff.inMinutes < 1) return 'à l’instant';
    if (diff.inMinutes < 60) return 'il y a ${diff.inMinutes} min';
    if (diff.inHours < 24) return 'il y a ${diff.inHours} h';
    return 'il y a ${diff.inDays} j';
  }
}

class ProjectStatusParser {
  const ProjectStatusParser._();

  static ProjectStatus fromValue(Object? value) {
    final normalized = value?.toString().toLowerCase().trim() ?? '';
    if (normalized.contains('live') || normalized.contains('deployed') || normalized.contains('success') || normalized.contains('ready')) return ProjectStatus.live;
    if (normalized.contains('build') || normalized.contains('running') || normalized.contains('progress') || normalized.contains('pending')) return ProjectStatus.building;
    if (normalized.contains('pause') || normalized.contains('draft') || normalized.contains('inactive')) return ProjectStatus.paused;
    if (normalized.contains('error') || normalized.contains('fail')) return ProjectStatus.error;
    return ProjectStatus.building;
  }
}
