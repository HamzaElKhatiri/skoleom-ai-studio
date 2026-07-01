import 'package:flutter/material.dart';
import 'package:skoleom_ai_studio/config/app_config.dart';
import 'package:skoleom_ai_studio/models/studio_models.dart';
import 'package:skoleom_ai_studio/services/studio_repository.dart';
import 'package:skoleom_ai_studio/theme/app_theme.dart';
import 'package:skoleom_ai_studio/widgets/premium_widgets.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final StudioRepository _repo = RepositoryProvider.instance;
  late Future<({List<UsageMetric> usage, BillingPlan plan})> _future;

  @override
  void initState() {
    super.initState();
    _load();
  }

  void _load() {
    _future = Future.wait<Object>([_repo.getUsage(), _repo.getCurrentPlan()]).then((values) => (usage: values[0] as List<UsageMetric>, plan: values[1] as BillingPlan));
  }

  @override
  Widget build(BuildContext context) {
    return ScreenFrame(title: 'Settings', subtitle: 'Configuration backend, usage et facturation.', trailing: IconButton.filled(onPressed: () => setState(_load), icon: const Icon(Icons.refresh_rounded)), child: FutureBuilder<({List<UsageMetric> usage, BillingPlan plan})>(future: _future, builder: (context, snapshot) {
      if (snapshot.connectionState != ConnectionState.done) return const SizedBox(height: 420, child: LoadingView(label: 'Chargement settings'));
      if (snapshot.hasError) return SizedBox(height: 420, child: ErrorStateView(onRetry: () => setState(_load)));
      final data = snapshot.data!;
      return Column(children: [
        PremiumCard(child: Row(children: [CircleAvatar(radius: 28, backgroundColor: AppTheme.accent.withValues(alpha: 0.22), child: const Text('SK', style: TextStyle(fontWeight: FontWeight.w900))), const SizedBox(width: 14), const Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('Skoleom Team', style: TextStyle(fontWeight: FontWeight.w900)), SizedBox(height: 4), Text('studio@skoleom.com', style: TextStyle(color: AppTheme.muted))])), const Icon(Icons.verified_rounded, color: AppTheme.accent2)])),
        const SizedBox(height: 16),
        PremiumCard(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [const Text('Backend configuration', style: TextStyle(fontWeight: FontWeight.w900)), const SizedBox(height: 8), Text(AppConfig.useApi ? AppConfig.apiBaseUrl : 'Fallback mock local actif', style: const TextStyle(color: AppTheme.muted, height: 1.45)), const SizedBox(height: 14), SwitchListTile.adaptive(value: AppConfig.useApi, onChanged: null, title: const Text('API réelle activée'), contentPadding: EdgeInsets.zero)])),
        const SizedBox(height: 16),
        PremiumCard(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [const Text('Plan actuel', style: TextStyle(color: AppTheme.muted)), const SizedBox(height: 8), Text(data.plan.name, style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w900)), const SizedBox(height: 8), Text(data.plan.price, style: const TextStyle(color: AppTheme.accent2, fontWeight: FontWeight.w800)), const SizedBox(height: 12), Text('${data.plan.credits} crédits disponibles', style: const TextStyle(fontWeight: FontWeight.w800))])),
        const SizedBox(height: 16),
        ...data.usage.map((metric) => Padding(padding: const EdgeInsets.only(bottom: 12), child: PremiumCard(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Row(children: [Expanded(child: Text(metric.label, style: const TextStyle(fontWeight: FontWeight.w900))), Text('${metric.used}/${metric.limit}', style: const TextStyle(color: AppTheme.muted))]), const SizedBox(height: 12), PremiumProgressBar(value: metric.ratio, color: metric.ratio > 0.85 ? AppTheme.warning : AppTheme.accent2)]))))
      ]);
    }));
  }
}
