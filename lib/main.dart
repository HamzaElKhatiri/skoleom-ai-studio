import 'package:flutter/material.dart';
import 'package:skoleom_ai_studio/screens/agents_screen.dart';
import 'package:skoleom_ai_studio/screens/chat_screen.dart';
import 'package:skoleom_ai_studio/screens/dashboard_screen.dart';
import 'package:skoleom_ai_studio/screens/onboarding_login_screen.dart';
import 'package:skoleom_ai_studio/screens/projects_screen.dart';
import 'package:skoleom_ai_studio/screens/settings_screen.dart';
import 'package:skoleom_ai_studio/theme/app_theme.dart';

void main() {
  runApp(const SkoleomApp());
}

class SkoleomApp extends StatefulWidget {
  const SkoleomApp({super.key});

  @override
  State<SkoleomApp> createState() => _SkoleomAppState();
}

class _SkoleomAppState extends State<SkoleomApp> {
  bool _loggedIn = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Skoleom AI Studio',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      home: _loggedIn
          ? const AppShell()
          : OnboardingLoginScreen(onLogin: () => setState(() => _loggedIn = true)),
    );
  }
}

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _index = 0;

  final List<Widget> _screens = const [
    DashboardScreen(),
    ChatScreen(),
    ProjectsScreen(),
    AgentsScreen(),
    SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 280),
        child: KeyedSubtree(key: ValueKey<int>(_index), child: _screens[_index]),
      ),
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.fromLTRB(16, 0, 16, 14),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(28),
          child: NavigationBar(
            selectedIndex: _index,
            height: 72,
            backgroundColor: AppTheme.surface.withOpacity(0.92),
            indicatorColor: AppTheme.accent.withOpacity(0.18),
            labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
            onDestinationSelected: (value) => setState(() => _index = value),
            destinations: const [
              NavigationDestination(icon: Icon(Icons.dashboard_rounded), label: 'Home'),
              NavigationDestination(icon: Icon(Icons.auto_awesome_rounded), label: 'Chat'),
              NavigationDestination(icon: Icon(Icons.folder_rounded), label: 'Projects'),
              NavigationDestination(icon: Icon(Icons.smart_toy_rounded), label: 'Agents'),
              NavigationDestination(icon: Icon(Icons.tune_rounded), label: 'Settings'),
            ],
          ),
        ),
      ),
    );
  }
}
