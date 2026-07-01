import 'package:flutter/material.dart';

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
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF9DFF00), brightness: Brightness.dark),
        fontFamily: 'Poppins',
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF050505),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Skoleom AI Studio', style: TextStyle(color: Color(0xFF9DFF00), letterSpacing: 2)),
              const SizedBox(height: 22),
              Text('Skoleom AI Studio', style: Theme.of(context).textTheme.displaySmall?.copyWith(fontWeight: FontWeight.w800)),
              const SizedBox(height: 16),
              Text('Corrige automatiquement le projet à partir de l\'échec GitHub Actions suivant.

Contexte:
- Repository: HamzaElKhatiri/skoleom-ai-studio
- Run GitHub Actions: 28505744773
- Jobs en échec: build: failure

Objectif:
- Anal', style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.white70)),
              const Spacer(),
              FilledButton(onPressed: () {}, child: const Text('Commencer')),
            ],
          ),
        ),
      ),
    );
  }
}
