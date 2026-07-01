import 'package:flutter/material.dart';
import 'package:skoleom_ai_studio/theme/app_theme.dart';

class PremiumProgressBar extends StatelessWidget {
  const PremiumProgressBar({super.key, required this.value, this.color = AppTheme.accent});

  final double value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final safeValue = value.clamp(0.0, 1.0);
    return ClipRRect(
      borderRadius: BorderRadius.circular(999),
      child: LinearProgressIndicator(
        minHeight: 10,
        value: safeValue,
        backgroundColor: Colors.white.withOpacity(0.08),
        valueColor: AlwaysStoppedAnimation<Color>(color),
      ),
    );
  }
}
