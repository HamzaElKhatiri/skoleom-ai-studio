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
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        color: AppTheme.surface.withOpacity(0.88),
        border: Border.all(color: Colors.white.withOpacity(0.08)),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.22), blurRadius: 28, offset: const Offset(0, 16))],
      ),
      child: child,
    );
    if (onTap == null) return card;
    return InkWell(borderRadius: BorderRadius.circular(28), onTap: onTap, child: card);
  }
}
