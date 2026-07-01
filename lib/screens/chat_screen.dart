import 'package:flutter/material.dart';
import 'package:skoleom_ai_studio/models/chat_message.dart';
import 'package:skoleom_ai_studio/services/repository_provider.dart';
import 'package:skoleom_ai_studio/services/studio_repository.dart';
import 'package:skoleom_ai_studio/theme/app_theme.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final StudioRepository _repo = RepositoryProvider.instance;
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _sending = false;
  String? _error;
  final List<ChatMessage> _messages = [
    ChatMessage(id: 'hello', content: 'Salut, je suis Skoleom AI Studio. Le chat est maintenant branché au repository API. Décris le projet à créer.', isUser: false, time: DateTime.now(), suggestedStack: ['Backend API', 'Projects', 'Chat']),
  ];

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _send() async {
    final text = _controller.text.trim();
    if (text.isEmpty || _sending) return;
    setState(() {
      _messages.add(ChatMessage(id: DateTime.now().millisecondsSinceEpoch.toString(), content: text, isUser: true, time: DateTime.now()));
      _sending = true;
      _error = null;
      _controller.clear();
    });
    _scrollToBottom();
    try {
      final response = await _repo.sendPrompt(text);
      if (!mounted) return;
      setState(() => _messages.add(response));
    } catch (_) {
      if (!mounted) return;
      setState(() => _error = 'Le backend chat n’a pas répondu. Vérifie SKOLEOM_CHAT_ENDPOINT et le token.');
    } finally {
      if (mounted) {
        setState(() => _sending = false);
        _scrollToBottom();
      }
    }
  }

  void _newChat() {
    setState(() {
      _error = null;
      _messages
        ..clear()
        ..add(ChatMessage(id: 'new', content: 'Nouveau chat prêt. Donne-moi une idée, une cible utilisateur et le style souhaité.', isUser: false, time: DateTime.now(), suggestedStack: const ['API-ready', 'Project builder']));
    });
  }

  void _scrollToBottom() {
    Future<void>.delayed(const Duration(milliseconds: 120), () {
      if (_scrollController.hasClients) _scrollController.animateTo(_scrollController.position.maxScrollExtent, duration: const Duration(milliseconds: 260), curve: Curves.easeOut);
    });
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    return Scaffold(
      body: Container(
        decoration: AppTheme.screenGradient(),
        child: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: width > 760 ? 720 : double.infinity),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 18, 20, 10),
                    child: Row(
                      children: [
                        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('Vibe Coding', style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w900)), const SizedBox(height: 4), const Text('Chat connecté au backend existant.', style: TextStyle(color: AppTheme.muted))])),
                        IconButton.filledTonal(onPressed: _newChat, icon: const Icon(Icons.add_comment_rounded)),
                      ],
                    ),
                  ),
                  if (_error != null)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                      child: Text(_error!, style: const TextStyle(color: AppTheme.danger, fontWeight: FontWeight.w700)),
                    ),
                  Expanded(
                    child: ListView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.fromLTRB(20, 10, 20, 14),
                      itemCount: _messages.length + (_sending ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (_sending && index == _messages.length) return const _TypingBubble();
                        return _MessageBubble(message: _messages[index]);
                      },
                    ),
                  ),
                  SafeArea(
                    top: false,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 96),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(color: AppTheme.surface.withValues(alpha: 0.95), borderRadius: BorderRadius.circular(28), border: Border.all(color: Colors.white.withValues(alpha: 0.08))),
                        child: Row(
                          children: [
                            Expanded(child: TextField(controller: _controller, minLines: 1, maxLines: 4, decoration: const InputDecoration(hintText: 'Créer une app mobile pour...', border: InputBorder.none, filled: false), onSubmitted: (_) => _send())),
                            IconButton.filled(onPressed: _send, icon: const Icon(Icons.arrow_upward_rounded)),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _MessageBubble extends StatelessWidget {
  const _MessageBubble({required this.message});
  final ChatMessage message;
  @override
  Widget build(BuildContext context) {
    final align = message.isUser ? Alignment.centerRight : Alignment.centerLeft;
    final color = message.isUser ? AppTheme.accent : AppTheme.surfaceElevated;
    return Align(
      alignment: align,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 560),
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(24), border: Border.all(color: Colors.white.withValues(alpha: 0.07))),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(message.content, style: const TextStyle(height: 1.45)),
            if (message.suggestedStack.isNotEmpty) ...[
              const SizedBox(height: 12),
              Wrap(spacing: 8, runSpacing: 8, children: message.suggestedStack.map((s) => Chip(label: Text(s), backgroundColor: AppTheme.accent2.withValues(alpha: 0.12), side: BorderSide(color: AppTheme.accent2.withValues(alpha: 0.25)))).toList()),
            ],
          ],
        ),
      ),
    );
  }
}

class _TypingBubble extends StatelessWidget {
  const _TypingBubble();
  @override
  Widget build(BuildContext context) {
    return Align(alignment: Alignment.centerLeft, child: Container(margin: const EdgeInsets.only(bottom: 14), padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: AppTheme.surfaceElevated, borderRadius: BorderRadius.circular(24)), child: const Text('Skoleom appelle le backend...', style: TextStyle(color: AppTheme.muted))));
  }
}
