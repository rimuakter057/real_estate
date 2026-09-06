import '../models/chat_model.dart';
import 'mock_properties.dart';

class MockChats {
  MockChats._();

  /// Conversations from the Buyer's point of view (chatting with agents).
  static final List<ChatConversation> buyerConversations = [
    ChatConversation(
      id: 'c1',
      name: 'Sofia Martinez',
      avatarUrl: 'https://randomuser.me/api/portraits/women/65.jpg',
      lastMessage: 'Sure! I can arrange a viewing this Saturday at 10 AM.',
      lastMessageTime: DateTime(2026, 9, 5, 18, 42),
      online: true,
      unreadCount: 2,
      property: MockProperties.byId('p1'),
      messages: [
        ChatMessage(id: 'm1', text: 'Hi Sofia, is the Skyline Villa still available?', isMe: true, time: DateTime(2026, 9, 5, 18, 30)),
        ChatMessage(id: 'm2', text: 'Yes it is! It just had a price update this week.', isMe: false, time: DateTime(2026, 9, 5, 18, 33)),
        ChatMessage(id: 'm3', text: 'Great, could I schedule a visit this weekend?', isMe: true, time: DateTime(2026, 9, 5, 18, 36)),
        ChatMessage(id: 'm4', text: 'Sure! I can arrange a viewing this Saturday at 10 AM.', isMe: false, time: DateTime(2026, 9, 5, 18, 42)),
      ],
    ),
    ChatConversation(
      id: 'c2',
      name: 'Daniel Cooper',
      avatarUrl: 'https://randomuser.me/api/portraits/men/32.jpg',
      lastMessage: 'Here\'s the floor plan you asked for 📎',
      lastMessageTime: DateTime(2026, 9, 4, 12, 5),
      online: false,
      unreadCount: 0,
      property: MockProperties.byId('p2'),
      messages: [
        ChatMessage(id: 'm1', text: 'Could you share the floor plan for the loft?', isMe: true, time: DateTime(2026, 9, 4, 11, 50)),
        ChatMessage(
          id: 'm2',
          text: '',
          isMe: false,
          time: DateTime(2026, 9, 4, 12, 4),
          type: MessageType.image,
          imageUrl: 'https://images.unsplash.com/photo-1600585154340-be6161a56a0c?auto=format&fit=crop&w=800&q=80',
        ),
        ChatMessage(id: 'm3', text: 'Here\'s the floor plan you asked for 📎', isMe: false, time: DateTime(2026, 9, 4, 12, 5)),
      ],
    ),
    ChatConversation(
      id: 'c3',
      name: 'Maria Gonzalez',
      avatarUrl: 'https://randomuser.me/api/portraits/women/68.jpg',
      lastMessage: 'You: Thank you, looking forward to it!',
      lastMessageTime: DateTime(2026, 9, 2, 9, 15),
      online: true,
      unreadCount: 0,
      property: MockProperties.byId('p9'),
      messages: [
        ChatMessage(id: 'm1', text: 'Your visit is confirmed for Sunday 3:30 PM.', isMe: false, time: DateTime(2026, 9, 2, 9, 10)),
        ChatMessage(id: 'm2', text: 'Thank you, looking forward to it!', isMe: true, time: DateTime(2026, 9, 2, 9, 15)),
      ],
    ),
    ChatConversation(
      id: 'c4',
      name: 'Ethan Brooks',
      avatarUrl: 'https://randomuser.me/api/portraits/men/76.jpg',
      lastMessage: 'The office space includes 2 dedicated parking spots.',
      lastMessageTime: DateTime(2026, 8, 29, 15, 0),
      online: false,
      unreadCount: 1,
      property: MockProperties.byId('p8'),
      messages: [
        ChatMessage(id: 'm1', text: 'Does the office come with parking?', isMe: true, time: DateTime(2026, 8, 29, 14, 55)),
        ChatMessage(id: 'm2', text: 'The office space includes 2 dedicated parking spots.', isMe: false, time: DateTime(2026, 8, 29, 15, 0)),
      ],
    ),
  ];

  /// Conversations from the Owner/Agent's point of view (chatting with leads).
  static final List<ChatConversation> ownerConversations = [
    ChatConversation(
      id: 'oc1',
      name: 'James Whitfield',
      avatarUrl: 'https://randomuser.me/api/portraits/men/45.jpg',
      lastMessage: 'Sounds good, see you Saturday!',
      lastMessageTime: DateTime(2026, 9, 5, 18, 45),
      online: true,
      unreadCount: 1,
      property: MockProperties.byId('p1'),
      messages: [
        ChatMessage(id: 'm1', text: 'Hi, is the Skyline Villa still available?', isMe: false, time: DateTime(2026, 9, 5, 18, 30)),
        ChatMessage(id: 'm2', text: 'Yes it is! It just had a price update this week.', isMe: true, time: DateTime(2026, 9, 5, 18, 33)),
        ChatMessage(id: 'm3', text: 'Great, could I schedule a visit this weekend?', isMe: false, time: DateTime(2026, 9, 5, 18, 36)),
        ChatMessage(id: 'm4', text: 'Sure! I can arrange a viewing this Saturday at 10 AM.', isMe: true, time: DateTime(2026, 9, 5, 18, 42)),
        ChatMessage(id: 'm5', text: 'Sounds good, see you Saturday!', isMe: false, time: DateTime(2026, 9, 5, 18, 45)),
      ],
    ),
    ChatConversation(
      id: 'oc2',
      name: 'Olivia Bennett',
      avatarUrl: 'https://randomuser.me/api/portraits/women/22.jpg',
      lastMessage: 'Could you share the maintenance fees?',
      lastMessageTime: DateTime(2026, 9, 3, 16, 10),
      online: false,
      unreadCount: 2,
      property: MockProperties.byId('p2'),
      messages: [
        ChatMessage(id: 'm1', text: 'Could you share the maintenance fees?', isMe: false, time: DateTime(2026, 9, 3, 16, 10)),
      ],
    ),
    ChatConversation(
      id: 'oc3',
      name: 'Priya Nair',
      avatarUrl: 'https://randomuser.me/api/portraits/women/33.jpg',
      lastMessage: 'You: Your visit is confirmed for Sunday 3:30 PM.',
      lastMessageTime: DateTime(2026, 9, 2, 9, 10),
      online: true,
      unreadCount: 0,
      property: MockProperties.byId('p9'),
      messages: [
        ChatMessage(id: 'm1', text: 'Your visit is confirmed for Sunday 3:30 PM.', isMe: true, time: DateTime(2026, 9, 2, 9, 10)),
      ],
    ),
  ];
}
