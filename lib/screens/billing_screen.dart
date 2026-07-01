import 'package:flutter/material.dart';
import 'package:skoleom_ai_studio/models/usage.dart';
import 'package:skoleom_ai_studio/services/mock_repository.dart';
import 'package:skoleom_ai_studio/theme/app_theme.dart';
import 'package:skoleom_ai_studio/widgets/gradient_button.dart';
import 'package:skoleom_ai_studio/widgets/premium_card.dart';
import 'package:skoleom_ai_studio/widgets/state_views.dart';

class BillingScreen extends StatefulWidget {
  const BillingScreen({super.key});

  @override
  State<BillingScreen> createState() => _BillingScreenState();
}

class _BillingScreenState extends State<BillingScreen> {
  final MockRepository _repo = const MockRepository();
  late Future<BillingPlan> _future;

  @override
  void initState() {
    super.initState();
    _future = _repo.getCurrentPlan();
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
                  const SliverAppBar(pinned: true, backgroundColor: Colors.transparent, title: Text('Plan & billing', style: TextStyle(fontWeight: FontWeight.w900))),
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
                    sliver: SliverToBoxAdapter(
                      child: FutureBuilder<BillingPlan>(
                        future: _future,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState != ConnectionState.done) return const SizedBox(height: 420, child: LoadingView(label: 'Chargement du plan'));
                          if (snapshot.hasError) return SizedBox(height: 420, child: ErrorStateView(onRetry: () => setState(() => _future = _repo.getCurrentPlan())));
                          final plan = snapshot.data!;
                          return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                            PremiumCard(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [const Text('Plan actuel', style: TextStyle(color: AppTheme.muted)), const SizedBox(height: 8), Text(plan.name, style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w900)), const SizedBox(height: 8), Text(plan.price, style: const TextStyle(color: AppTheme.accent2, fontWeight: FontWeight.w800)), const SizedBox(height: 18), Text('${plan.credits} crédits disponibles', style: const TextStyle(fontWeight: FontWeight.w800)), const SizedBox(height: 16), ...plan.features.map((f) => Padding(padding: const EdgeInsets.only(bottom: 10), child: Row(children: [const Icon(Icons.check_circle_rounded, color: AppTheme.success, size: 20), const SizedBox(width: 10), Expanded(child: Text(f))])))])),
                            const SizedBox(height: 18),
                            PremiumCard(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [const Text('Crédits supplémentaires', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 18)), const SizedBox(height: 12), const Text('Ajoute un pack de crédits pour absorber les pics de génération et de déploiement.', style: TextStyle(color: AppTheme.muted, height: 1.45)), const SizedBox(height: 18), Row(children: const [Expanded(child: _CreditPack(label: '5k', price: '19€')), SizedBox(width: 12), Expanded(child: _CreditPack(label: '20k', price: '59€'))])])),
                            const SizedBox(height: 20),
                            GradientButton(label: 'Gérer le paiement', icon: Icons.credit_card_rounded, onPressed: () {}),
                          ]);
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

class _CreditPack extends StatelessWidget {
  const _CreditPack({required this.label, required this.price});
  final String label;
  final String price;
  @override
  Widget build(BuildContext context) {
    return Container(padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: Colors.white.withOpacity(0.06), borderRadius: BorderRadius.circular(22), border: Border.all(color: Colors.white.withOpacity(0.08))), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(label, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 20)), const SizedBox(height: 4), Text(price, style: const TextStyle(color: AppTheme.muted))]));
  }
}
