import 'package:flutter/material.dart';
import 'package:skoleom_ai_studio/config/app_config.dart';
import 'package:skoleom_ai_studio/screens/agents_screen.dart';
import 'package:skoleom_ai_studio/screens/chat_screen.dart';
import 'package:skoleom_ai_studio/screens/dashboard_screen.dart';
import 'package:skoleom_ai_studio/screens/projects_screen.dart';
import 'package:skoleom_ai_studio/screens/settings_screen.dart';
import 'package:skoleom_ai_studio/services/api_client.dart';
import 'package:skoleom_ai_studio/services/studio_repository.dart';
import 'package:skoleom_ai_studio/theme/app_theme.dart';

void main() {
  if (AppConfig.useApi) {
    RepositoryProvider.configure(ApiRepository(ApiClient()));
  } else {
    RepositoryProvider.configure(const MockRepository());
  }
  runApp(const SkoleomApp());
}

class SkoleomApp extends StatelessWidget {
  const SkoleomApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, title: 'Skoleom AI Studio', theme: AppTheme.darkTheme, home: const StudioShell());
  }
}

class StudioShell extends StatefulWidget {
  const StudioShell({super.key});

  @override
  State<StudioShell> createState() => _StudioShellState();
}

class _StudioShellState extends State<StudioShell> {
  int _index = 0;

  static const List<Widget> _screens = [DashboardScreen(), ChatScreen(), ProjectsScreen(), AgentsScreen(), SettingsScreen()];

  static const List<NavigationDestination> _destinations = [
    NavigationDestination(icon: Icon(Icons.dashboard_rounded), label: 'Studio'),
    NavigationDestination(icon: Icon(Icons.auto_awesome_rounded), label: 'Chat'),
    NavigationDestination(icon: Icon(Icons.folder_rounded), label: 'Projets'),
    NavigationDestination(icon: Icon(Icons.smart_toy_rounded), label: 'Agents'),
    NavigationDestination(icon: Icon(Icons.settings_rounded), label: 'Settings'),
  ];

  @override
  Widget build(BuildContext context) {
    final wide = MediaQuery.sizeOf(context).width >= 900;
    if (wide) {
      return Scaffold(
        body: Row(
          children: [
            NavigationRail(selectedIndex: _index, onDestinationSelected: (value) => setState(() => _index = value), labelType: NavigationRailLabelType.all, destinations: _destinations.map((item) => NavigationRailDestination(icon: item.icon, label: Text(item.label))).toList()),
            Expanded(child: _screens[_index]),
          ],
        ),
      );
    }
    return Scaffold(body: _screens[_index], bottomNavigationBar: NavigationBar(selectedIndex: _index, onDestinationSelected: (value) => setState(() => _index = value), destinations: _destinations));
  }
}
