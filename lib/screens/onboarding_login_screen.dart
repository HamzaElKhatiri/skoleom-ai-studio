import 'package:flutter/material.dart';
import 'package:skoleom_ai_studio/config/app_config.dart';
import 'package:skoleom_ai_studio/theme/app_theme.dart';
import 'package:skoleom_ai_studio/widgets/gradient_button.dart';
import 'package:skoleom_ai_studio/widgets/premium_card.dart';

class OnboardingLoginScreen extends StatefulWidget {
  const OnboardingLoginScreen({super.key, required this.onLogin});

  final Future<String?> Function(String email, String password) onLogin;

  @override
  State<OnboardingLoginScreen> createState() => _OnboardingLoginScreenState();
}

class _OnboardingLoginScreenState extends State<OnboardingLoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _loading = false;
  String? _error;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_loading) return;
    setState(() {
      _loading = true;
      _error = null;
    });
    final error = await widget.onLogin(_emailController.text, _passwordController.text);
    if (!mounted) return;
    setState(() {
      _loading = false;
      _error = error;
    });
  }

  @override
  Widget build(BuildContext context) {
    final apiMode = AppConfig.useApi ? 'API backend configurée' : 'Mode preview local';
    return Scaffold(
      body: Container(
        decoration: AppTheme.screenGradient(),
        child: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 540),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 74,
                        height: 74,
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(24), gradient: const LinearGradient(colors: [AppTheme.accent, AppTheme.accent2])),
                        child: const Icon(Icons.auto_awesome_rounded, size: 36, color: Colors.white),
                      ),
                      const SizedBox(height: 26),
                      Text('Skoleom AI Studio', style: Theme.of(context).textTheme.displaySmall?.copyWith(fontWeight: FontWeight.w900, letterSpacing: -1.4)),
                      const SizedBox(height: 14),
                      const Text('Crée, pilote et déploie tes projets avec ton backend existant pour les chats, projets, agents, usage et billing.', style: TextStyle(color: AppTheme.muted, fontSize: 16, height: 1.55)),
                      const SizedBox(height: 24),
                      PremiumCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(children: [const Icon(Icons.cloud_done_rounded, color: AppTheme.accent2), const SizedBox(width: 10), Text(apiMode, style: const TextStyle(fontWeight: FontWeight.w900))]),
                            if (AppConfig.useApi && !AppConfig.hasStaticToken) ...[
                              const SizedBox(height: 18),
                              TextField(controller: _emailController, keyboardType: TextInputType.emailAddress, decoration: const InputDecoration(labelText: 'Email', hintText: 'studio@skoleom.com')),
                              const SizedBox(height: 12),
                              TextField(controller: _passwordController, obscureText: true, decoration: const InputDecoration(labelText: 'Mot de passe', hintText: '••••••••')),
                            ],
                            if (_error != null) ...[
                              const SizedBox(height: 14),
                              Text(_error!, style: const TextStyle(color: AppTheme.danger, fontWeight: FontWeight.w700)),
                            ],
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      _loading
                          ? const Center(child: CircularProgressIndicator())
                          : GradientButton(label: 'Entrer dans le Studio', icon: Icons.lock_open_rounded, onPressed: _submit),
                      const SizedBox(height: 12),
                      Center(child: Text(AppConfig.useApi ? 'Secrets injectés via --dart-define / GitHub Secrets' : 'Aucune API configurée : fallback local actif', style: TextStyle(color: AppTheme.muted.withOpacity(0.8), fontSize: 12))),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
