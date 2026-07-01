import 'package:flutter/material.dart';
import 'package:skoleom_ai_studio/theme/app_theme.dart';

class GradientButton extends StatelessWidget {
  const GradientButton({super.key, required this.label, required this.onPressed, this.icon});

  final String label;
  final VoidCallback onPressed;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(22), gradient: const LinearGradient(colors: [AppTheme.accent, AppTheme.accent2]), boxShadow: [BoxShadow(color: AppTheme.accent.withOpacity(0.28), blurRadius: 24, offset: const Offset(0, 12))]),
      child: ElevatedButton.icon(onPressed: onPressed, icon: Icon(icon ?? Icons.arrow_forward_rounded), label: Text(label), style: ElevatedButton.styleFrom(backgroundColor: Colors.transparent, shadowColor: Colors.transparent, minimumSize: const Size.fromHeight(56))),
    );
  }
}
