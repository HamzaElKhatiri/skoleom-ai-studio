import 'package:flutter/material.dart';
import 'package:skoleom_ai_studio/theme/app_theme.dart';
import 'package:skoleom_ai_studio/widgets/premium_card.dart';

class LoadingView extends StatelessWidget {
  const LoadingView({super.key, this.label = 'Chargement'});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: PremiumCard(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 16),
            Text(label, style: const TextStyle(color: AppTheme.muted)),
          ],
        ),
      ),
    );
  }
}

class EmptyStateView extends StatelessWidget {
  const EmptyStateView({super.key, required this.title, required this.message, required this.icon});

  final String title;
  final String message;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: PremiumCard(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 42, color: AppTheme.accent2),
            const SizedBox(height: 14),
            Text(title, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800)),
            const SizedBox(height: 8),
            Text(message, textAlign: TextAlign.center, style: const TextStyle(color: AppTheme.muted)),
          ],
        ),
      ),
    );
  }
}

class ErrorStateView extends StatelessWidget {
  const ErrorStateView({super.key, required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: PremiumCard(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.warning_rounded, color: AppTheme.danger, size: 40),
            const SizedBox(height: 12),
            const Text('Impossible de charger les données', style: TextStyle(fontWeight: FontWeight.w800)),
            const SizedBox(height: 14),
            ElevatedButton(onPressed: onRetry, child: const Text('Réessayer')),
          ],
        ),
      ),
    );
  }
}
