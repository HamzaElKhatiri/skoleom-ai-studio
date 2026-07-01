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

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    final rawStack = json['suggestedStack'] ?? json['stack'] ?? json['technologies'] ?? const <dynamic>[];
    final stack = rawStack is List ? rawStack.map((item) => item.toString()).toList() : <String>[];
    final role = (json['role'] ?? json['sender'] ?? json['type'] ?? '').toString().toLowerCase();
    return ChatMessage(
      id: (json['id'] ?? json['_id'] ?? DateTime.now().microsecondsSinceEpoch).toString(),
      content: (json['content'] ?? json['message'] ?? json['response'] ?? json['text'] ?? '').toString(),
      isUser: role.contains('user') || json['isUser'] == true,
      time: DateTime.tryParse((json['createdAt'] ?? json['time'] ?? '').toString()) ?? DateTime.now(),
      suggestedStack: stack,
    );
  }
}
