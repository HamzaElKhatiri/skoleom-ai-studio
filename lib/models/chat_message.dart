class ChatMessage {
  const ChatMessage({
    required this.id,
    required this.content,
    required this.isUser,
    required this.time,
    this.suggestedStack = const [],
  });

  final String id;
  final String content;
  final bool isUser;
  final DateTime time;
  final List<String> suggestedStack;
}
