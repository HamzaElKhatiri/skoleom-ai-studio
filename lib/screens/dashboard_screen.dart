import 'package:flutter/material.dart';
import 'package:skoleom_ai_studio/models/agent.dart';
import 'package:skoleom_ai_studio/models/project.dart';
import 'package:skoleom_ai_studio/services/mock_repository.dart';
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
  final MockRepository _repo = const MockRepository();
  late Future<({List<Project> projects, List<Agent> agents})> _future;

  @override
  void initState() {
    super.initState();
    _load();
  }

  void _load() {
    _future = Future.wait([_repo.getProjects(), _repo.getAgents()]).then((values) => (projects: values[0] as List<Project>, agents: values[1] as List<Agent>));
  }

  @override
  Widget build(BuildContext context) {
    return ScreenFrame(
      title: 'Studio',
      subtitle: 'Vue rapide de tes projets, agents et builds IA.',
      trailing: CircleAvatar(backgroundColor: AppTheme.accent.withOpacity(0.2), child: const Text('S', style: TextStyle(fontWeight: FontWeight.w900))),
      child: FutureBuilder<({List<Project> projects, List<Agent> agents})>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) return const SizedBox(height: 420, child: LoadingView(label: 'Synchronisation du studio'));
          if (snapshot.hasError) return SizedBox(height: 420, child: ErrorStateView(onRetry: () => setState(_load)));
          final data = snapshot.data!;
          final running = data.agents.where((a) => a.status == AgentStatus.running).length;
          return Column(
            children: [
              PremiumCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Expanded(child: Text('Build velocity', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900))),
                        StatusPill(label: 'Healthy', color: AppTheme.success),
                      ],
                    ),
                    const SizedBox(height: 18),
                    Row(
                      children: [
                        _Kpi(value: '${data.projects.length}', label: 'Projets'),
                        _Kpi(value: '$running', label: 'Agents actifs'),
                        const _Kpi(value: '12.8k', label: 'Crédits'),
                      ],
                    ),
                    const SizedBox(height: 20),
                    const PremiumProgressBar(value: 0.68, color: AppTheme.accent2),
                    const SizedBox(height: 10),
                    const Text('68% de capacité utilisée cette semaine', style: TextStyle(color: AppTheme.muted, fontSize: 13)),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              Row(
                children: [
                  Expanded(child: _ActionCard(icon: Icons.add_rounded, title: 'Nouveau projet', text: 'Prompt vers stack')),
                  const SizedBox(width: 14),
                  Expanded(child: _ActionCard(icon: Icons.chat_bubble_rounded, title: 'Nouveau chat', text: 'Coder avec IA')),
                ],
              ),
              const SizedBox(height: 22),
              Align(alignment: Alignment.centerLeft, child: Text('Projets récents', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900))),
              const SizedBox(height: 12),
              ...data.projects.take(3).map((project) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: PremiumCard(
                      child: Row(
                        children: [
                          Container(width: 46, height: 46, decoration: BoxDecoration(color: AppTheme.accent.withOpacity(0.16), borderRadius: BorderRadius.circular(16)), child: const Icon(Icons.folder_rounded, color: AppTheme.accent2)),
                          const SizedBox(width: 14),
                          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(project.name, style: const TextStyle(fontWeight: FontWeight.w800)), const SizedBox(height: 4), Text('${project.framework} · ${project.lastActivity}', style: const TextStyle(color: AppTheme.muted, fontSize: 12))])),
                          Icon(Icons.chevron_right_rounded, color: Colors.white.withOpacity(0.4)),
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

class _ActionCard extends StatelessWidget {
  const _ActionCard({required this.icon, required this.title, required this.text});
  final IconData icon;
  final String title;
  final String text;
  @override
  Widget build(BuildContext context) {
    return PremiumCard(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Icon(icon, color: AppTheme.accent2), const SizedBox(height: 16), Text(title, style: const TextStyle(fontWeight: FontWeight.w900)), const SizedBox(height: 4), Text(text, style: const TextStyle(color: AppTheme.muted, fontSize: 12))]),
    );
  }
}
