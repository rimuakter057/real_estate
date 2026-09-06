import 'property_model.dart';

enum MessageType { text, image }

class ChatMessage {
  const ChatMessage({
    required this.id,
    required this.text,
    required this.isMe,
    required this.time,
    this.type = MessageType.text,
    this.imageUrl,
    this.read = true,
  });

  final String id;
  final String text;
  final bool isMe;
  final DateTime time;
  final MessageType type;
  final String? imageUrl;
  final bool read;
}

class ChatConversation {
  const ChatConversation({
    required this.id,
    required this.name,
    required this.avatarUrl,
    required this.lastMessage,
    required this.lastMessageTime,
    required this.online,
    required this.unreadCount,
    required this.property,
    required this.messages,
  });

  final String id;
  final String name;
  final String avatarUrl;
  final String lastMessage;
  final DateTime lastMessageTime;
  final bool online;
  final int unreadCount;
  final PropertyModel property;
  final List<ChatMessage> messages;
}
