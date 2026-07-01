import 'package:flutter/material.dart';
import 'package:skoleom_ai_studio/theme/app_theme.dart';

class ScreenFrame extends StatelessWidget {
  const ScreenFrame({super.key, required this.title, required this.subtitle, required this.child, this.trailing});

  final String title;
  final String subtitle;
  final Widget child;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final maxWidth = width > 760 ? 720.0 : double.infinity;
    return Container(
      decoration: AppTheme.screenGradient(),
      child: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: maxWidth),
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 18, 20, 16),
                    child: Row(children: [Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w900, letterSpacing: -0.8)), const SizedBox(height: 6), Text(subtitle, style: const TextStyle(color: AppTheme.muted, height: 1.45))])), if (trailing != null) trailing!]),
                  ),
                ),
                SliverPadding(padding: const EdgeInsets.fromLTRB(20, 0, 20, 112), sliver: SliverToBoxAdapter(child: child)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
