import 'package:flutter/material.dart';
import 'package:skoleom_ai_studio/models/usage.dart';
import 'package:skoleom_ai_studio/services/mock_repository.dart';
import 'package:skoleom_ai_studio/theme/app_theme.dart';
import 'package:skoleom_ai_studio/widgets/premium_card.dart';
import 'package:skoleom_ai_studio/widgets/progress_bar.dart';
import 'package:skoleom_ai_studio/widgets/state_views.dart';

class UsageScreen extends StatefulWidget {
  const UsageScreen({super.key});

  @override
  State<UsageScreen> createState() => _UsageScreenState();
}

class _UsageScreenState extends State<UsageScreen> {
  final MockRepository _repo = const MockRepository();
  late Future<List<UsageMetric>> _future;

  @override
  void initState() {
    super.initState();
    _future = _repo.getUsage();
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
                  const SliverAppBar(
                    pinned: true,
                    backgroundColor: Colors.transparent,
                    title: Text('Usage & limits', style: TextStyle(fontWeight: FontWeight.w900)),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
                    sliver: SliverToBoxAdapter(
                      child: FutureBuilder<List<UsageMetric>>(
                        future: _future,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState != ConnectionState.done) {
                            return const SizedBox(
                              height: 420,
                              child: LoadingView(label: 'Lecture des limites'),
                            );
                          }
                          if (snapshot.hasError) {
                            return SizedBox(
                              height: 420,
                              child: ErrorStateView(onRetry: () => setState(() => _future = _repo.getUsage())),
                            );
                          }
                          final usage = snapshot.data ?? [];
                          return Column(
                            children: usage.map((metric) {
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 16),
                                child: PremiumCard(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              metric.label,
                                              style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 17),
                                            ),
                                          ),
                                          Text(
                                            '${metric.used}/${metric.limit}',
                                            style: const TextStyle(color: AppTheme.muted),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 14),
                                      PremiumProgressBar(
                                        value: metric.ratio,
                                        color: metric.ratio > 0.85 ? AppTheme.warning : AppTheme.accent2,
                                      ),
                                      const SizedBox(height: 10),
                                      Text(
                                        '${(metric.ratio * 100).round()}% utilisé',
                                        style: const TextStyle(color: AppTheme.muted, fontSize: 12),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }).toList(),
                          );
                        },
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
