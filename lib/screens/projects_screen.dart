import 'package:flutter/material.dart';
import 'package:skoleom_ai_studio/models/project.dart';
import 'package:skoleom_ai_studio/screens/project_detail_screen.dart';
import 'package:skoleom_ai_studio/services/mock_repository.dart';
import 'package:skoleom_ai_studio/theme/app_theme.dart';
import 'package:skoleom_ai_studio/widgets/premium_card.dart';
import 'package:skoleom_ai_studio/widgets/progress_bar.dart';
import 'package:skoleom_ai_studio/widgets/screen_frame.dart';
import 'package:skoleom_ai_studio/widgets/state_views.dart';
import 'package:skoleom_ai_studio/widgets/status_pill.dart';

class ProjectsScreen extends StatefulWidget {
  const ProjectsScreen({super.key});

  @override
  State<ProjectsScreen> createState() => _ProjectsScreenState();
}

class _ProjectsScreenState extends State<ProjectsScreen> {
  final MockRepository _repo = const MockRepository();
  late Future<List<Project>> _future;

  @override
  void initState() {
    super.initState();
    _future = _repo.getProjects();
  }

  Color _statusColor(ProjectStatus status) => switch (status) { ProjectStatus.live => AppTheme.success, ProjectStatus.building => AppTheme.accent2, ProjectStatus.paused => AppTheme.warning, ProjectStatus.error => AppTheme.danger };
  String _statusLabel(ProjectStatus status) => switch (status) { ProjectStatus.live => 'Live', ProjectStatus.building => 'Building', ProjectStatus.paused => 'Paused', ProjectStatus.error => 'Error' };

  @override
  Widget build(BuildContext context) {
    return ScreenFrame(
      title: 'Projets',
      subtitle: 'Applications, previews et déploiements récents.',
      trailing: IconButton.filled(onPressed: () {}, icon: const Icon(Icons.add_rounded)),
      child: FutureBuilder<List<Project>>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) return const SizedBox(height: 420, child: LoadingView(label: 'Chargement des projets'));
          if (snapshot.hasError) return SizedBox(height: 420, child: ErrorStateView(onRetry: () => setState(() => _future = _repo.getProjects())));
          final projects = snapshot.data ?? [];
          if (projects.isEmpty) return const SizedBox(height: 420, child: EmptyStateView(title: 'Aucun projet', message: 'Lance ton premier build depuis le chat IA.', icon: Icons.folder_off_rounded));
          return Column(
            children: projects.map((project) {
              final color = _statusColor(project.status);
              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: PremiumCard(
                  onTap: () => Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => ProjectDetailScreen(project: project))),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(children: [Expanded(child: Text(project.name, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900))), StatusPill(label: _statusLabel(project.status), color: color)]),
                      const SizedBox(height: 10),
                      Text(project.description, style: const TextStyle(color: AppTheme.muted, height: 1.45)),
                      const SizedBox(height: 16),
                      Row(children: [Icon(Icons.code_rounded, size: 18, color: color), const SizedBox(width: 8), Text(project.framework, style: const TextStyle(fontWeight: FontWeight.w700)), const Spacer(), Text(project.lastActivity, style: const TextStyle(color: AppTheme.muted, fontSize: 12))]),
                      const SizedBox(height: 14),
                      PremiumProgressBar(value: project.progress, color: color),
                    ],
                  ),
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
