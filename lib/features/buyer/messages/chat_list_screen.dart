import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../core/routing/route_paths.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/app_states.dart';
import '../../../core/widgets/avatar.dart';
import '../../../shared/mock_data/mock_chats.dart';

class ChatListScreen extends StatelessWidget {
  const ChatListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final conversations = MockChats.buyerConversations;
    return Scaffold(
      appBar: AppBar(title: const Text('Messages')),
      body: conversations.isEmpty
          ? const EmptyState(
              icon: Icons.chat_bubble_outline_rounded,
              title: 'No Messages Yet',
              message: 'Start a conversation with an agent from any property listing.',
            )
          : ListView.separated(
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
              itemCount: conversations.length,
              separatorBuilder: (_, __) => const Divider(height: 1, indent: 82),
              itemBuilder: (context, i) {
                final c = conversations[i];
                return ListTile(
                  onTap: () => context.push(RoutePaths.buyerChatDetail(c.id)),
                  contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.xs),
                  leading: AppAvatar(imageUrl: c.avatarUrl, online: c.online),
                  title: Text(c.name, style: Theme.of(context).textTheme.titleMedium),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: CachedNetworkImage(imageUrl: c.property.images.first, height: 16, width: 16, fit: BoxFit.cover),
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              c.lastMessage,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    fontWeight: c.unreadCount > 0 ? FontWeight.w700 : FontWeight.w400,
                                    color: c.unreadCount > 0 ? Theme.of(context).colorScheme.onSurface : null,
                                  ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  trailing: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(DateFormat('h:mm a').format(c.lastMessageTime), style: Theme.of(context).textTheme.labelSmall),
                      const SizedBox(height: 6),
                      if (c.unreadCount > 0)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                          decoration: BoxDecoration(color: AppColors.accent, borderRadius: BorderRadius.circular(AppRadius.pill)),
                          child: Text('${c.unreadCount}', style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w700)),
                        ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
