import 'package:flutter/material.dart';
import 'package:skoleom_ai_studio/models/agent.dart';
import 'package:skoleom_ai_studio/services/mock_repository.dart';
import 'package:skoleom_ai_studio/theme/app_theme.dart';
import 'package:skoleom_ai_studio/widgets/premium_card.dart';
import 'package:skoleom_ai_studio/widgets/progress_bar.dart';
import 'package:skoleom_ai_studio/widgets/screen_frame.dart';
import 'package:skoleom_ai_studio/widgets/state_views.dart';
import 'package:skoleom_ai_studio/widgets/status_pill.dart';

class AgentsScreen extends StatefulWidget {
  const AgentsScreen({super.key});

  @override
  State<AgentsScreen> createState() => _AgentsScreenState();
}

class _AgentsScreenState extends State<AgentsScreen> {
  final MockRepository _repo = const MockRepository();
  late Future<List<Agent>> _future;

  @override
  void initState() {
    super.initState();
    _future = _repo.getAgents();
  }

  Color _color(AgentStatus status) => switch (status) { AgentStatus.running => AppTheme.success, AgentStatus.stopped => AppTheme.warning, AgentStatus.draft => AppTheme.muted };
  String _label(AgentStatus status) => switch (status) { AgentStatus.running => 'Running', AgentStatus.stopped => 'Stopped', AgentStatus.draft => 'Draft' };

  @override
  Widget build(BuildContext context) {
    return ScreenFrame(
      title: 'Agents IA',
      subtitle: 'Configure les spécialistes qui construisent avec toi.',
      trailing: IconButton.filled(onPressed: () {}, icon: const Icon(Icons.add_rounded)),
      child: FutureBuilder<List<Agent>>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) return const SizedBox(height: 420, child: LoadingView(label: 'Démarrage des agents'));
          if (snapshot.hasError) return SizedBox(height: 420, child: ErrorStateView(onRetry: () => setState(() => _future = _repo.getAgents())));
          final agents = snapshot.data ?? [];
          if (agents.isEmpty) return const SizedBox(height: 420, child: EmptyStateView(title: 'Aucun agent', message: 'Crée un agent pour automatiser ton studio.', icon: Icons.smart_toy_outlined));
          return Column(
            children: agents.map((agent) {
              final color = _color(agent.status);
              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: PremiumCard(
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Row(children: [Container(width: 48, height: 48, decoration: BoxDecoration(color: color.withOpacity(0.14), borderRadius: BorderRadius.circular(17)), child: Icon(Icons.smart_toy_rounded, color: color)), const SizedBox(width: 14), Expanded(child: Text(agent.name, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900))), StatusPill(label: _label(agent.status), color: color)]),
                    const SizedBox(height: 12),
                    Text(agent.role, style: const TextStyle(color: AppTheme.muted, height: 1.45)),
                    const SizedBox(height: 16),
                    Row(children: [Text('${agent.tasksToday} tâches aujourd’hui', style: const TextStyle(fontWeight: FontWeight.w700)), const Spacer(), Text('${(agent.successRate * 100).round()}%', style: TextStyle(color: color, fontWeight: FontWeight.w900))]),
                    const SizedBox(height: 10),
                    PremiumProgressBar(value: agent.successRate, color: color),
                  ]),
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
