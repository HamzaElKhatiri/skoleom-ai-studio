import 'package:flutter/material.dart';
import 'package:skoleom_ai_studio/theme/app_theme.dart';

class PremiumCard extends StatelessWidget {
  const PremiumCard({super.key, required this.child, this.padding = const EdgeInsets.all(20), this.onTap});

  final Widget child;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final card = Container(
      padding: padding,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(28), color: AppTheme.surface.withValues(alpha: 0.9), border: Border.all(color: Colors.white.withValues(alpha: 0.08)), boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.22), blurRadius: 28, offset: const Offset(0, 16))]),
      child: child,
    );
    if (onTap == null) return card;
    return InkWell(borderRadius: BorderRadius.circular(28), onTap: onTap, child: card);
  }
}

class GradientButton extends StatelessWidget {
  const GradientButton({super.key, required this.label, required this.onPressed, this.icon});

  final String label;
  final VoidCallback onPressed;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(22), gradient: const LinearGradient(colors: [AppTheme.accent, AppTheme.accent2]), boxShadow: [BoxShadow(color: AppTheme.accent.withValues(alpha: 0.28), blurRadius: 24, offset: const Offset(0, 12))]),
      child: ElevatedButton.icon(onPressed: onPressed, icon: Icon(icon ?? Icons.arrow_forward_rounded), label: Text(label), style: ElevatedButton.styleFrom(backgroundColor: Colors.transparent, shadowColor: Colors.transparent, minimumSize: const Size.fromHeight(56))),
    );
  }
}

class StatusPill extends StatelessWidget {
  const StatusPill({super.key, required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(color: color.withValues(alpha: 0.14), borderRadius: BorderRadius.circular(999), border: Border.all(color: color.withValues(alpha: 0.35))),
      child: Row(mainAxisSize: MainAxisSize.min, children: [Container(width: 7, height: 7, decoration: BoxDecoration(color: color, shape: BoxShape.circle)), const SizedBox(width: 7), Text(label, style: const TextStyle(color: AppTheme.text, fontSize: 12, fontWeight: FontWeight.w700))]),
    );
  }
}

class PremiumProgressBar extends StatelessWidget {
  const PremiumProgressBar({super.key, required this.value, this.color = AppTheme.accent});

  final double value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(borderRadius: BorderRadius.circular(999), child: LinearProgressIndicator(minHeight: 10, value: value.clamp(0.0, 1.0), backgroundColor: Colors.white.withValues(alpha: 0.08), valueColor: AlwaysStoppedAnimation<Color>(color)));
  }
}

class ScreenFrame extends StatelessWidget {
  const ScreenFrame({super.key, required this.title, required this.subtitle, required this.child, this.trailing});

  final String title;
  final String subtitle;
  final Widget child;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    return Container(
      decoration: AppTheme.screenGradient(),
      child: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: width > 760 ? 720 : double.infinity),
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                SliverToBoxAdapter(child: Padding(padding: const EdgeInsets.fromLTRB(20, 18, 20, 16), child: Row(children: [Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w900, letterSpacing: -0.8)), const SizedBox(height: 6), Text(subtitle, style: const TextStyle(color: AppTheme.muted, height: 1.45))])), if (trailing != null) trailing!]))),
                SliverPadding(padding: const EdgeInsets.fromLTRB(20, 0, 20, 112), sliver: SliverToBoxAdapter(child: child)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class LoadingView extends StatelessWidget {
  const LoadingView({super.key, this.label = 'Chargement'});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Center(child: PremiumCard(child: Column(mainAxisSize: MainAxisSize.min, children: [const CircularProgressIndicator(), const SizedBox(height: 16), Text(label, style: const TextStyle(color: AppTheme.muted))])));
  }
}

class EmptyStateView extends StatelessWidget {
  const EmptyStateView({super.key, required this.title, required this.message, required this.icon});

  final String title;
  final String message;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Center(child: PremiumCard(child: Column(mainAxisSize: MainAxisSize.min, children: [Icon(icon, size: 42, color: AppTheme.accent2), const SizedBox(height: 14), Text(title, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800)), const SizedBox(height: 8), Text(message, textAlign: TextAlign.center, style: const TextStyle(color: AppTheme.muted))])));
  }
}

class ErrorStateView extends StatelessWidget {
  const ErrorStateView({super.key, required this.onRetry, this.message = 'Impossible de charger les données'});

  final VoidCallback onRetry;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(child: PremiumCard(child: Column(mainAxisSize: MainAxisSize.min, children: [const Icon(Icons.warning_rounded, color: AppTheme.danger, size: 40), const SizedBox(height: 12), Text(message, textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.w800)), const SizedBox(height: 14), ElevatedButton(onPressed: onRetry, child: const Text('Réessayer'))])));
  }
}
