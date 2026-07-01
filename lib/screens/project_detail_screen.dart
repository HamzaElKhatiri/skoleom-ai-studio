import 'package:flutter/material.dart';
import 'package:skoleom_ai_studio/models/project.dart';
import 'package:skoleom_ai_studio/services/repository_provider.dart';
import 'package:skoleom_ai_studio/theme/app_theme.dart';
import 'package:skoleom_ai_studio/widgets/gradient_button.dart';
import 'package:skoleom_ai_studio/widgets/premium_card.dart';
import 'package:skoleom_ai_studio/widgets/progress_bar.dart';
import 'package:skoleom_ai_studio/widgets/status_pill.dart';

class ProjectDetailScreen extends StatefulWidget {
  const ProjectDetailScreen({super.key, required this.project});

  final Project project;

  @override
  State<ProjectDetailScreen> createState() => _ProjectDetailScreenState();
}

class _ProjectDetailScreenState extends State<ProjectDetailScreen> {
  late Project _project = widget.project;
  bool _deploying = false;

  Color get _color => switch (_project.status) { ProjectStatus.live => AppTheme.success, ProjectStatus.building => AppTheme.accent2, ProjectStatus.paused => AppTheme.warning, ProjectStatus.error => AppTheme.danger };
  String get _label => switch (_project.status) { ProjectStatus.live => 'Live', ProjectStatus.building => 'Building', ProjectStatus.paused => 'Paused', ProjectStatus.error => 'Error' };

  Future<void> _redeploy() async {
    if (_deploying) return;
    setState(() => _deploying = true);
    try {
      final updated = await RepositoryProvider.instance.redeployProject(_project.id);
      if (!mounted) return;
      setState(() => _project = updated);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Déploiement relancé via API')));
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Impossible de relancer le déploiement')));
    } finally {
      if (mounted) setState(() => _deploying = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: AppTheme.screenGradient(),
        child: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 720),
              child: CustomScrollView(
                slivers: [
                  SliverAppBar(pinned: true, backgroundColor: AppTheme.background.withOpacity(0.78), title: Text(_project.name, style: const TextStyle(fontWeight: FontWeight.w900))),
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
                    sliver: SliverToBoxAdapter(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          PremiumCard(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Row(children: [StatusPill(label: _label, color: _color), const Spacer(), Text(_project.lastActivity, style: const TextStyle(color: AppTheme.muted))]), const SizedBox(height: 18), Text(_project.description, style: const TextStyle(color: AppTheme.muted, height: 1.5)), const SizedBox(height: 18), PremiumProgressBar(value: _project.progress, color: _color)])),
                          const SizedBox(height: 18),
                          PremiumCard(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [const Text('Preview', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 18)), const SizedBox(height: 16), Container(height: 320, decoration: BoxDecoration(borderRadius: BorderRadius.circular(32), gradient: const LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [Color(0xFF222842), Color(0xFF080A12)]), border: Border.all(color: Colors.white.withOpacity(0.1))), child: Padding(padding: const EdgeInsets.all(20), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Row(children: [Container(width: 48, height: 48, decoration: BoxDecoration(color: _color.withOpacity(0.2), borderRadius: BorderRadius.circular(16)), child: Icon(Icons.auto_awesome_rounded, color: _color)), const Spacer(), const Icon(Icons.more_horiz_rounded)]), const Spacer(), Text(_project.name, style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w900)), const SizedBox(height: 8), Text(_project.deployUrl.isEmpty ? 'URL de preview en attente' : _project.deployUrl, style: const TextStyle(color: AppTheme.muted)), const SizedBox(height: 18), Wrap(spacing: 8, runSpacing: 8, children: _project.stack.map((s) => Chip(label: Text(s), backgroundColor: Colors.white.withOpacity(0.08), side: BorderSide(color: Colors.white.withOpacity(0.1)))).toList())])))])),
                          const SizedBox(height: 20),
                          _deploying ? const Center(child: CircularProgressIndicator()) : GradientButton(label: 'Relancer un déploiement', icon: Icons.rocket_launch_rounded, onPressed: _redeploy),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
