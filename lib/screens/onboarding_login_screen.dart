import 'package:flutter/material.dart';
import 'package:skoleom_ai_studio/config/app_config.dart';
import 'package:skoleom_ai_studio/theme/app_theme.dart';
import 'package:skoleom_ai_studio/widgets/gradient_button.dart';
import 'package:skoleom_ai_studio/widgets/premium_card.dart';

class OnboardingLoginScreen extends StatefulWidget {
  const OnboardingLoginScreen({super.key, required this.onLogin, required this.onRegister});

  final Future<String?> Function({required String email, required String password}) onLogin;
  final Future<String?> Function({required String plan, required String name, required String organization, required String phone, required String email, required String password}) onRegister;

  @override
  State<OnboardingLoginScreen> createState() => _OnboardingLoginScreenState();
}

class _OnboardingLoginScreenState extends State<OnboardingLoginScreen> {
  final TextEditingController _nameController = TextEditingController(text: 'Hz Technology');
  final TextEditingController _organizationController = TextEditingController(text: 'Hz Technology');
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _createAccount = true;
  bool _loading = false;
  String _selectedPlan = 'hobby';
  String? _error;

  @override
  void dispose() {
    _nameController.dispose();
    _organizationController.dispose();
    _phoneController.dispose();
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
    final error = _createAccount
        ? await widget.onRegister(
            plan: _selectedPlan,
            name: _nameController.text,
            organization: _organizationController.text,
            phone: _phoneController.text,
            email: _emailController.text,
            password: _passwordController.text,
          )
        : await widget.onLogin(email: _emailController.text, password: _passwordController.text);
    if (!mounted) return;
    setState(() {
      _loading = false;
      _error = error;
    });
  }

  @override
  Widget build(BuildContext context) {
    final wide = MediaQuery.sizeOf(context).width >= 920;
    final apiMode = AppConfig.useApi ? 'API backend configurée' : 'Mode preview local';
    return Scaffold(
      body: Container(
        decoration: AppTheme.screenGradient(),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1120),
                child: wide
                    ? Row(crossAxisAlignment: CrossAxisAlignment.center, children: [Expanded(child: _HeroPanel(apiMode: apiMode)), const SizedBox(width: 28), Expanded(child: _AuthCard())])
                    : Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [_HeroPanel(apiMode: apiMode), const SizedBox(height: 20), _AuthCard()]),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _AuthCard() {
    return PremiumCard(
      padding: const EdgeInsets.all(22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(child: Text(_createAccount ? 'Créer un compte' : 'Se connecter', style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w900, letterSpacing: -0.6))),
              SegmentedButton<bool>(
                segments: const [ButtonSegment(value: true, label: Text('Créer')), ButtonSegment(value: false, label: Text('Login'))],
                selected: {_createAccount},
                onSelectionChanged: (value) => setState(() => _createAccount = value.first),
                showSelectedIcon: false,
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(_createAccount ? 'Choisis ton plan puis renseigne les informations de Hz Technology.' : 'Connecte-toi pour récupérer ton token avant d’utiliser l’API.', style: const TextStyle(color: AppTheme.muted, height: 1.45)),
          if (_createAccount) ...[
            const SizedBox(height: 20),
            _PlanSelector(selectedPlan: _selectedPlan, onChanged: (plan) => setState(() => _selectedPlan = plan)),
            const SizedBox(height: 18),
            TextField(controller: _nameController, textInputAction: TextInputAction.next, decoration: const InputDecoration(labelText: 'Nom', hintText: 'Hz Technology')),
            const SizedBox(height: 12),
            TextField(controller: _organizationController, textInputAction: TextInputAction.next, decoration: const InputDecoration(labelText: 'Organisation', hintText: 'Hz Technology')),
            const SizedBox(height: 12),
            TextField(controller: _phoneController, keyboardType: TextInputType.phone, textInputAction: TextInputAction.next, decoration: const InputDecoration(labelText: 'Téléphone', hintText: '+33 6 00 00 00 00')),
          ],
          const SizedBox(height: 12),
          TextField(controller: _emailController, keyboardType: TextInputType.emailAddress, textInputAction: TextInputAction.next, decoration: const InputDecoration(labelText: 'Email', hintText: 'contact@hz-technology.com')),
          const SizedBox(height: 12),
          TextField(controller: _passwordController, obscureText: true, decoration: const InputDecoration(labelText: 'Mot de passe', hintText: 'Minimum 6 caractères'), onSubmitted: (_) => _submit()),
          if (_error != null) ...[
            const SizedBox(height: 14),
            Container(width: double.infinity, padding: const EdgeInsets.all(14), decoration: BoxDecoration(color: AppTheme.danger.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(18), border: Border.all(color: AppTheme.danger.withValues(alpha: 0.35))), child: Text(_error!, style: const TextStyle(color: AppTheme.danger, fontWeight: FontWeight.w700))),
          ],
          const SizedBox(height: 20),
          _loading ? const Center(child: CircularProgressIndicator()) : GradientButton(label: _createAccount ? 'Créer le compte et entrer' : 'Se connecter', icon: _createAccount ? Icons.person_add_alt_1_rounded : Icons.lock_open_rounded, onPressed: _submit),
          const SizedBox(height: 12),
          Center(child: Text(AppConfig.useApi ? 'Login: ${AppConfig.authLoginEndpoint} · Register: ${AppConfig.authRegisterEndpoint}' : 'Preview locale : aucun appel réseau requis', style: TextStyle(color: AppTheme.muted.withValues(alpha: 0.8), fontSize: 12))),
        ],
      ),
    );
  }
}

class _HeroPanel extends StatelessWidget {
  const _HeroPanel({required this.apiMode});

  final String apiMode;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(width: 76, height: 76, decoration: BoxDecoration(borderRadius: BorderRadius.circular(26), gradient: const LinearGradient(colors: [AppTheme.accent, AppTheme.accent2])), child: const Icon(Icons.auto_awesome_rounded, size: 38, color: Colors.white)),
          const SizedBox(height: 26),
          Text('Skoleom AI Studio', style: Theme.of(context).textTheme.displaySmall?.copyWith(fontWeight: FontWeight.w900, letterSpacing: -1.4)),
          const SizedBox(height: 14),
          const Text('Ton API requiert une authentification avant les projets, agents, chats et métriques. L’accès au Studio est donc protégé par connexion ou création de compte.', style: TextStyle(color: AppTheme.muted, fontSize: 16, height: 1.55)),
          const SizedBox(height: 22),
          Wrap(spacing: 10, runSpacing: 10, children: [
            _HeroBadge(icon: Icons.cloud_done_rounded, label: apiMode),
            const _HeroBadge(icon: Icons.workspace_premium_rounded, label: 'Plans Hobby · Pro · Studio'),
            const _HeroBadge(icon: Icons.business_rounded, label: 'Hz Technology ready'),
          ]),
        ],
      ),
    );
  }
}

class _HeroBadge extends StatelessWidget {
  const _HeroBadge({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.07), borderRadius: BorderRadius.circular(999), border: Border.all(color: Colors.white.withValues(alpha: 0.1))),
      child: Row(mainAxisSize: MainAxisSize.min, children: [Icon(icon, size: 18, color: AppTheme.accent2), const SizedBox(width: 8), Text(label, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12))]),
    );
  }
}

class _PlanSelector extends StatelessWidget {
  const _PlanSelector({required this.selectedPlan, required this.onChanged});

  final String selectedPlan;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    const plans = [
      _PlanOption(id: 'hobby', title: 'Hobby', price: '0€', subtitle: 'Pour démarrer vite'),
      _PlanOption(id: 'pro', title: 'Pro', price: '29€', subtitle: 'Pour équipes actives'),
      _PlanOption(id: 'studio', title: 'Studio', price: '99€', subtitle: 'Usage intensif'),
    ];
    return LayoutBuilder(builder: (context, constraints) {
      final compact = constraints.maxWidth < 560;
      return Flex(
        direction: compact ? Axis.vertical : Axis.horizontal,
        children: plans.map((plan) {
          final selected = selectedPlan == plan.id;
          final card = InkWell(
            borderRadius: BorderRadius.circular(22),
            onTap: () => onChanged(plan.id),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              curve: Curves.easeOut,
              width: compact ? double.infinity : null,
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(22),
                color: selected ? AppTheme.accent.withValues(alpha: 0.18) : Colors.white.withValues(alpha: 0.055),
                border: Border.all(color: selected ? AppTheme.accent2 : Colors.white.withValues(alpha: 0.09), width: selected ? 1.4 : 1),
              ),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(children: [Expanded(child: Text(plan.title, style: const TextStyle(fontWeight: FontWeight.w900))), if (selected) const Icon(Icons.check_circle_rounded, color: AppTheme.accent2, size: 20)]),
                const SizedBox(height: 6),
                Text(plan.price, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900)),
                const SizedBox(height: 4),
                Text(plan.subtitle, style: const TextStyle(color: AppTheme.muted, fontSize: 12)),
              ]),
            ),
          );
          return compact ? Padding(padding: const EdgeInsets.only(bottom: 10), child: card) : Expanded(child: Padding(padding: const EdgeInsets.only(right: 10), child: card));
        }).toList(),
      );
    });
  }
}

class _PlanOption {
  const _PlanOption({required this.id, required this.title, required this.price, required this.subtitle});

  final String id;
  final String title;
  final String price;
  final String subtitle;
}
