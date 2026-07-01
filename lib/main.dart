import 'package:flutter/material.dart';
import 'package:skoleom_ai_studio/screens/agents_screen.dart';
import 'package:skoleom_ai_studio/screens/chat_screen.dart';
import 'package:skoleom_ai_studio/screens/dashboard_screen.dart';
import 'package:skoleom_ai_studio/screens/onboarding_login_screen.dart';
import 'package:skoleom_ai_studio/screens/projects_screen.dart';
import 'package:skoleom_ai_studio/screens/settings_screen.dart';
import 'package:skoleom_ai_studio/theme/app_theme.dart';

void main() {
  runApp(const SkoleomGeneratedApp());
}

class SkoleomGeneratedApp extends StatelessWidget {
  const SkoleomGeneratedApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Skoleom AI Studio',
      theme: AppTheme.darkTheme,
      home: const AppRoot(),
    );
  }
}

class AppRoot extends StatefulWidget {
  const AppRoot({super.key});

  @override
  State<AppRoot> createState() => _AppRootState();
}

class _AppRootState extends State<AppRoot> {
  bool _isLoggedIn = false;

  @override
  Widget build(BuildContext context) {
    if (!_isLoggedIn) {
      return OnboardingLoginScreen(
        onLogin: () => setState(() => _isLoggedIn = true),
      );
    }

    return const StudioShell();
  }
}

class StudioShell extends StatefulWidget {
  const StudioShell({super.key});

  @override
  State<StudioShell> createState() => _StudioShellState();
}

class _StudioShellState extends State<StudioShell> {
  int _selectedIndex = 0;

  static const List<_StudioDestination> _destinations = [
    _StudioDestination(
      label: 'Studio',
      icon: Icons.dashboard_outlined,
      selectedIcon: Icons.dashboard_rounded,
      screen: DashboardScreen(),
    ),
    _StudioDestination(
      label: 'Chat',
      icon: Icons.auto_awesome_outlined,
      selectedIcon: Icons.auto_awesome_rounded,
      screen: ChatScreen(),
    ),
    _StudioDestination(
      label: 'Projets',
      icon: Icons.folder_outlined,
      selectedIcon: Icons.folder_rounded,
      screen: ProjectsScreen(),
    ),
    _StudioDestination(
      label: 'Agents',
      icon: Icons.smart_toy_outlined,
      selectedIcon: Icons.smart_toy_rounded,
      screen: AgentsScreen(),
    ),
    _StudioDestination(
      label: 'Settings',
      icon: Icons.settings_outlined,
      selectedIcon: Icons.settings_rounded,
      screen: SettingsScreen(),
    ),
  ];

  void _select(int index) {
    if (_selectedIndex == index) return;
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final useRail = width >= 900;

    if (useRail) {
      return Scaffold(
        backgroundColor: AppTheme.background,
        body: Row(
          children: [
            NavigationRail(
              selectedIndex: _selectedIndex,
              onDestinationSelected: _select,
              extended: width >= 1180,
              minExtendedWidth: 224,
              backgroundColor: AppTheme.backgroundSoft.withOpacity(0.96),
              indicatorColor: AppTheme.accent.withOpacity(0.18),
              selectedIconTheme: const IconThemeData(color: AppTheme.accent2),
              unselectedIconTheme: const IconThemeData(color: AppTheme.muted),
              selectedLabelTextStyle: const TextStyle(
                color: AppTheme.text,
                fontWeight: FontWeight.w800,
              ),
              unselectedLabelTextStyle: const TextStyle(color: AppTheme.muted),
              leading: Padding(
                padding: const EdgeInsets.symmetric(vertical: 22),
                child: _StudioMark(extended: width >= 1180),
              ),
              destinations: _destinations
                  .map(
                    (destination) => NavigationRailDestination(
                      icon: Icon(destination.icon),
                      selectedIcon: Icon(destination.selectedIcon),
                      label: Text(destination.label),
                    ),
                  )
                  .toList(),
            ),
            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 240),
                child: KeyedSubtree(
                  key: ValueKey<int>(_selectedIndex),
                  child: _destinations[_selectedIndex].screen,
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 220),
        child: KeyedSubtree(
          key: ValueKey<int>(_selectedIndex),
          child: _destinations[_selectedIndex].screen,
        ),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: _select,
        backgroundColor: AppTheme.backgroundSoft.withOpacity(0.98),
        indicatorColor: AppTheme.accent.withOpacity(0.18),
        destinations: _destinations
            .map(
              (destination) => NavigationDestination(
                icon: Icon(destination.icon),
                selectedIcon: Icon(destination.selectedIcon),
                label: destination.label,
              ),
            )
            .toList(),
      ),
    );
  }
}

class _StudioDestination {
  const _StudioDestination({
    required this.label,
    required this.icon,
    required this.selectedIcon,
    required this.screen,
  });

  final String label;
  final IconData icon;
  final IconData selectedIcon;
  final Widget screen;
}

class _StudioMark extends StatelessWidget {
  const _StudioMark({required this.extended});

  final bool extended;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: const LinearGradient(
              colors: [AppTheme.accent, AppTheme.accent2],
            ),
          ),
          child: const Icon(Icons.auto_awesome_rounded, color: Colors.white),
        ),
        if (extended) ...[
          const SizedBox(width: 12),
          const Text(
            'Skoleom',
            style: TextStyle(fontWeight: FontWeight.w900, fontSize: 18),
          ),
        ],
      ],
    );
  }
}
