import 'package:flutter/material.dart';
import 'package:skoleom_ai_studio/models/studio_models.dart';
import 'package:skoleom_ai_studio/services/studio_repository.dart';
import 'package:skoleom_ai_studio/theme/app_theme.dart';
import 'package:skoleom_ai_studio/widgets/premium_widgets.dart';

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
      subtitle: 'Vue rapide synchronisée avec le backend ou le mock local.',
      trailing: CircleAvatar(backgroundColor: AppTheme.accent.withValues(alpha: 0.2), child: const Text('S', style: TextStyle(fontWeight: FontWeight.w900))),
      child: FutureBuilder<({List<Project> projects, List<Agent> agents})>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) return const SizedBox(height: 420, child: LoadingView(label: 'Synchronisation du studio'));
          if (snapshot.hasError) return SizedBox(height: 420, child: ErrorStateView(onRetry: () => setState(_load), message: 'Erreur API ou CORS'));
          final data = snapshot.data!;
          final running = data.agents.where((agent) => agent.status == AgentStatus.running).length;
          return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            PremiumCard(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Row(children: [Expanded(child: Text('Backend status', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900))), StatusPill(label: 'Ready', color: AppTheme.success)]),
              const SizedBox(height: 18),
              Row(children: [_Kpi(value: '${data.projects.length}', label: 'Projets'), _Kpi(value: '$running', label: 'Agents actifs'), const _Kpi(value: 'OK', label: 'Build web')]),
              const SizedBox(height: 20),
              const PremiumProgressBar(value: 0.78, color: AppTheme.accent2),
              const SizedBox(height: 10),
              const Text('Dépendances externes supprimées : http/google_fonts ne bloquent plus le build.', style: TextStyle(color: AppTheme.muted, fontSize: 13)),
            ])),
            const SizedBox(height: 22),
            Text('Projets récents', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900)),
            const SizedBox(height: 12),
            if (data.projects.isEmpty)
              const EmptyStateView(title: 'Aucun projet', message: 'Crée un projet depuis le chat IA.', icon: Icons.folder_off_rounded)
            else
              ...data.projects.take(3).map((project) => Padding(padding: const EdgeInsets.only(bottom: 12), child: PremiumCard(child: Row(children: [Container(width: 46, height: 46, decoration: BoxDecoration(color: AppTheme.accent.withValues(alpha: 0.16), borderRadius: BorderRadius.circular(16)), child: const Icon(Icons.folder_rounded, color: AppTheme.accent2)), const SizedBox(width: 14), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(project.name, style: const TextStyle(fontWeight: FontWeight.w800)), const SizedBox(height: 4), Text('${project.framework} · ${project.lastActivity}', style: const TextStyle(color: AppTheme.muted, fontSize: 12))])), Icon(Icons.chevron_right_rounded, color: Colors.white.withValues(alpha: 0.4))])))),
          ]);
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
