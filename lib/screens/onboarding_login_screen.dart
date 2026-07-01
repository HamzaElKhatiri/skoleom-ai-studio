import 'package:flutter/material.dart';
import 'package:skoleom_ai_studio/theme/app_theme.dart';
import 'package:skoleom_ai_studio/widgets/gradient_button.dart';
import 'package:skoleom_ai_studio/widgets/premium_card.dart';

class OnboardingLoginScreen extends StatelessWidget {
  const OnboardingLoginScreen({super.key, required this.onLogin});

  final VoidCallback onLogin;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: AppTheme.screenGradient(),
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 520),
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Spacer(),
                        Container(
                          width: 74,
                          height: 74,
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(24), gradient: const LinearGradient(colors: [AppTheme.accent, AppTheme.accent2])),
                          child: const Icon(Icons.auto_awesome_rounded, size: 36, color: Colors.white),
                        ),
                        const SizedBox(height: 26),
                        Text('Skoleom AI Studio', style: Theme.of(context).textTheme.displaySmall?.copyWith(fontWeight: FontWeight.w900, letterSpacing: -1.4)),
                        const SizedBox(height: 14),
                        const Text('Crée, pilote et déploie tes projets avec une IA pensée pour une expérience mobile premium.', style: TextStyle(color: AppTheme.muted, fontSize: 16, height: 1.55)),
                        const SizedBox(height: 28),
                        const PremiumCard(
                          child: Column(
                            children: [
                              _Benefit(icon: Icons.bolt_rounded, title: 'Vibe coding instantané', text: 'Décris ton idée, Skoleom choisit la stack et prépare le projet.'),
                              SizedBox(height: 16),
                              _Benefit(icon: Icons.smart_toy_rounded, title: 'Agents IA dédiés', text: 'Builder, Reviewer et Deploy Pilot travaillent ensemble.'),
                              SizedBox(height: 16),
                              _Benefit(icon: Icons.analytics_rounded, title: 'Usage maîtrisé', text: 'Crédits, limites et déploiements visibles en temps réel.'),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),
                        GradientButton(label: 'Entrer dans le Studio', icon: Icons.lock_open_rounded, onPressed: onLogin),
                        const SizedBox(height: 12),
                        Center(child: Text('Mode preview avec données locales mockées', style: TextStyle(color: AppTheme.muted.withOpacity(0.8), fontSize: 12))),
                        const Spacer(),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _Benefit extends StatelessWidget {
  const _Benefit({required this.icon, required this.title, required this.text});

  final IconData icon;
  final String title;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: AppTheme.accent2),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.w800)),
              const SizedBox(height: 4),
              Text(text, style: const TextStyle(color: AppTheme.muted, height: 1.35)),
            ],
          ),
        ),
      ],
    );
  }
}
