import 'dart:async';
import 'package:skoleom_ai_studio/models/agent.dart';
import 'package:skoleom_ai_studio/models/chat_message.dart';
import 'package:skoleom_ai_studio/models/project.dart';
import 'package:skoleom_ai_studio/models/usage.dart';

class MockRepository {
  const MockRepository();

  Future<List<Project>> getProjects() async {
    await Future<void>.delayed(const Duration(milliseconds: 450));
    return const [
      Project(id: 'p1', name: 'LearnFlow Mobile', description: 'Plateforme micro-learning IA pour cohortes premium.', framework: 'Flutter', status: ProjectStatus.live, lastActivity: 'il y a 8 min', progress: 1, deployUrl: 'learnflow.skoleom.app', stack: ['Flutter', 'Firebase-ready', 'Stripe-ready']),
      Project(id: 'p2', name: 'AgentOps Console', description: 'Dashboard pour piloter agents, jobs et déploiements.', framework: 'Next.js', status: ProjectStatus.building, lastActivity: 'il y a 22 min', progress: 0.72, deployUrl: 'agentops.preview.app', stack: ['Next.js', 'Supabase-ready', 'Tailwind']),
      Project(id: 'p3', name: 'Campus CRM', description: 'CRM mobile-first pour équipes pédagogiques.', framework: 'Laravel', status: ProjectStatus.paused, lastActivity: 'hier', progress: 0.43, deployUrl: 'campus-crm.local', stack: ['Laravel', 'MySQL', 'Vue']),
      Project(id: 'p4', name: 'Studio Landing', description: 'Landing cinématique pour lancement produit.', framework: 'Astro', status: ProjectStatus.error, lastActivity: 'lundi', progress: 0.18, deployUrl: 'studio-landing.preview', stack: ['Astro', 'CSS', 'Analytics']),
    ];
  }

  Future<List<Agent>> getAgents() async {
    await Future<void>.delayed(const Duration(milliseconds: 380));
    return const [
      Agent(id: 'a1', name: 'Builder', role: 'Génération de projets Flutter, SaaS et dashboards', status: AgentStatus.running, tasksToday: 18, successRate: 0.96),
      Agent(id: 'a2', name: 'Reviewer', role: 'Audit UI, sécurité et performance', status: AgentStatus.running, tasksToday: 11, successRate: 0.91),
      Agent(id: 'a3', name: 'Deploy Pilot', role: 'Prépare les previews et checks de livraison', status: AgentStatus.stopped, tasksToday: 4, successRate: 0.88),
      Agent(id: 'a4', name: 'Course Architect', role: 'Structure contenus pédagogiques assistés par IA', status: AgentStatus.draft, tasksToday: 0, successRate: 0.0),
    ];
  }

  Future<List<UsageMetric>> getUsage() async {
    await Future<void>.delayed(const Duration(milliseconds: 360));
    return const [
      UsageMetric(label: 'Prompts aujourd’hui', used: 74, limit: 120),
      UsageMetric(label: 'Build minutes', used: 410, limit: 800),
      UsageMetric(label: 'Déploiements semaine', used: 17, limit: 30),
      UsageMetric(label: 'Agents actifs', used: 2, limit: 6),
    ];
  }

  Future<BillingPlan> getCurrentPlan() async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    return const BillingPlan(
      name: 'Studio Pro',
      price: '49€ / mois',
      credits: 12840,
      features: ['Agents IA avancés', 'Builds Flutter Web', 'Déploiements preview', 'Support prioritaire'],
    );
  }

  Future<ChatMessage> sendPrompt(String prompt) async {
    await Future<void>.delayed(const Duration(milliseconds: 800));
    final lower = prompt.toLowerCase();
    final stack = <String>[];
    if (lower.contains('mobile') || lower.contains('app') || lower.contains('ios')) {
      stack.addAll(['Flutter', 'Material 3', 'API-ready']);
    } else if (lower.contains('saas') || lower.contains('dashboard')) {
      stack.addAll(['Next.js', 'PostgreSQL-ready', 'Stripe-ready']);
    } else if (lower.contains('landing')) {
      stack.addAll(['Astro', 'CSS premium', 'Analytics-ready']);
    } else {
      stack.addAll(['Flutter', 'Mock data', 'Responsive Web']);
    }
    return ChatMessage(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      content: 'J’ai analysé ton prompt. Je recommande ${stack.join(', ')}. Je peux générer la structure, les écrans, les composants premium et préparer les points de branchement API.',
      isUser: false,
      time: DateTime.now(),
      suggestedStack: stack,
    );
  }
}
