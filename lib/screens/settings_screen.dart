import 'package:flutter/material.dart';
import 'package:skoleom_ai_studio/config/app_config.dart';
import 'package:skoleom_ai_studio/screens/billing_screen.dart';
import 'package:skoleom_ai_studio/screens/usage_screen.dart';
import 'package:skoleom_ai_studio/theme/app_theme.dart';
import 'package:skoleom_ai_studio/widgets/premium_card.dart';
import 'package:skoleom_ai_studio/widgets/screen_frame.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenFrame(
      title: 'Settings',
      subtitle: 'Configuration backend, sécurité, usage et facturation.',
      child: Column(
        children: [
          PremiumCard(child: Row(children: [CircleAvatar(radius: 28, backgroundColor: AppTheme.accent.withOpacity(0.22), child: const Text('SK', style: TextStyle(fontWeight: FontWeight.w900))), const SizedBox(width: 14), const Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('Skoleom Team', style: TextStyle(fontWeight: FontWeight.w900)), SizedBox(height: 4), Text('studio@skoleom.com', style: TextStyle(color: AppTheme.muted))])), const Icon(Icons.verified_rounded, color: AppTheme.accent2)])),
          const SizedBox(height: 16),
          _SettingTile(icon: Icons.analytics_rounded, title: 'Usage & rate limits', subtitle: 'Prompts, builds, déploiements', onTap: () => Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => const UsageScreen()))),
          _SettingTile(icon: Icons.credit_card_rounded, title: 'Plan & billing', subtitle: 'Plan actuel et crédits', onTap: () => Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => const BillingScreen()))),
          _SettingTile(icon: Icons.key_rounded, title: 'API access', subtitle: AppConfig.useApi ? AppConfig.apiBaseUrl : 'Fallback mock local actif', onTap: () {}),
          const SizedBox(height: 18),
          PremiumCard(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [const Text('Backend configuration', style: TextStyle(fontWeight: FontWeight.w900)), const SizedBox(height: 8), Text(AppConfig.useApi ? 'L’application utilise SKOLEOM_API_BASE_URL et les endpoints injectés par GitHub Secrets.' : 'Aucune API fournie au build. Le mode local reste fonctionnel pour développer.', style: const TextStyle(color: AppTheme.muted, height: 1.45)), const SizedBox(height: 14), SwitchListTile.adaptive(value: AppConfig.useApi, onChanged: (_) {}, title: const Text('API réelle activée'), contentPadding: EdgeInsets.zero)])),
        ],
      ),
    );
  }
}

class _SettingTile extends StatelessWidget {
  const _SettingTile({required this.icon, required this.title, required this.subtitle, required this.onTap});
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: PremiumCard(
        onTap: onTap,
        child: Row(children: [Container(width: 44, height: 44, decoration: BoxDecoration(color: AppTheme.accent.withOpacity(0.14), borderRadius: BorderRadius.circular(16)), child: Icon(icon, color: AppTheme.accent2)), const SizedBox(width: 14), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: const TextStyle(fontWeight: FontWeight.w900)), const SizedBox(height: 4), Text(subtitle, style: const TextStyle(color: AppTheme.muted, fontSize: 12))])), const Icon(Icons.chevron_right_rounded, color: AppTheme.muted)]),
      ),
    );
  }
}
