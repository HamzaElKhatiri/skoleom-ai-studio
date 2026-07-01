import 'package:flutter/material.dart';
import 'package:skoleom_ai_studio/models/agent.dart';
import 'package:skoleom_ai_studio/models/project.dart';
import 'package:skoleom_ai_studio/services/repository_provider.dart';
import 'package:skoleom_ai_studio/services/studio_repository.dart';
import 'package:skoleom_ai_studio/theme/app_theme.dart';
import 'package:skoleom_ai_studio/widgets/premium_card.dart';
import 'package:skoleom_ai_studio/widgets/progress_bar.dart';
import 'package:skoleom_ai_studio/widgets/screen_frame.dart';
import 'package:skoleom_ai_studio/widgets/state_views.dart';
import 'package:skoleom_ai_studio/widgets/status_pill.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final StudioRepository _repo = RepositoryProvider.instance;
  late Future<({List<Project> projects, List<Agent> agents})> _future;

  @override
  void initState() {
    super.initState();
    _load();
  }

  void _load() {
    _future = Future.wait<Object>([_repo.getProjects(), _repo.getAgents()]).then((values) => (projects: values[0] as List<Project>, agents: values[1] as List<Agent>));
  }

  @override
  Widget build(BuildContext context) {
    return ScreenFrame(
      title: 'Studio',
      subtitle: 'Vue rapide synchronisée avec le backend Skoleom.',
      trailing: CircleAvatar(backgroundColor: AppTheme.accent.withValues(alpha: 0.2), child: const Text('S', style: TextStyle(fontWeight: FontWeight.w900))),
      child: FutureBuilder<({List<Project> projects, List<Agent> agents})>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) return const SizedBox(height: 420, child: LoadingView(label: 'Synchronisation API du studio'));
          if (snapshot.hasError) return SizedBox(height: 420, child: ErrorStateView(onRetry: () => setState(_load)));
          final data = snapshot.data!;
          final running = data.agents.where((a) => a.status == AgentStatus.running).length;
          return Column(
            children: [
              PremiumCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(children: [const Expanded(child: Text('Backend status', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900))), const StatusPill(label: 'Connected', color: AppTheme.success)]),
                    const SizedBox(height: 18),
                    Row(children: [const _Kpi(value: '${data.projects.length}', label: 'Projets'), _Kpi(value: '$running', label: 'Agents actifs'), const _Kpi(value: 'API', label: 'Source')]),
                    const SizedBox(height: 20),
                    PremiumProgressBar(value: data.projects.isEmpty ? 0 : 0.68, color: AppTheme.accent2),
                    const SizedBox(height: 10),
                    const Text('Données chargées depuis le repository configuré', style: TextStyle(color: AppTheme.muted, fontSize: 13)),
                  ],
                ),
              ),
              const SizedBox(height: 22),
              Align(alignment: Alignment.centerLeft, child: Text('Projets récents', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900))),
              const SizedBox(height: 12),
              if (data.projects.isEmpty)
                const EmptyStateView(title: 'Aucun projet', message: 'Crée un projet depuis le chat IA.', icon: Icons.folder_off_rounded)
              else
                ...data.projects.take(3).map((project) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: PremiumCard(
                        child: Row(
                          children: [
                            Container(width: 46, height: 46, decoration: BoxDecoration(color: AppTheme.accent.withValues(alpha: 0.16), borderRadius: BorderRadius.circular(16)), child: const Icon(Icons.folder_rounded, color: AppTheme.accent2)),
                            const SizedBox(width: 14),
                            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(project.name, style: const TextStyle(fontWeight: FontWeight.w800)), const SizedBox(height: 4), Text('${project.framework} · ${project.lastActivity}', style: const TextStyle(color: AppTheme.muted, fontSize: 12))])),
                            Icon(Icons.chevron_right_rounded, color: Colors.white.withValues(alpha: 0.4)),
                          ],
                        ),
                      ),
                    )),
            ],
          );
        },
      ),
    );
  }
}

class _Kpi extends StatelessWidget {
  const _Kpi({required this.value, required this.label});
  final String value;
  final String label;
  @override
  Widget build(BuildContext context) {
    return Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(value, style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w900)), Text(label, style: const TextStyle(color: AppTheme.muted, fontSize: 12))]));
  }
}
