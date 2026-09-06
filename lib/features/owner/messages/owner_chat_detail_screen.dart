import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../core/routing/route_paths.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/avatar.dart';
import '../../../shared/mock_data/mock_chats.dart';
import '../../../shared/models/chat_model.dart';

class OwnerChatDetailScreen extends StatefulWidget {
  const OwnerChatDetailScreen({super.key, required this.conversationId});
  final String conversationId;

  @override
  State<OwnerChatDetailScreen> createState() => _OwnerChatDetailScreenState();
}

class _OwnerChatDetailScreenState extends State<OwnerChatDetailScreen> {
  final _controller = TextEditingController();
  late List<ChatMessage> _messages;
  late ChatConversation _conversation;

  @override
  void initState() {
    super.initState();
    _conversation = MockChats.ownerConversations.firstWhere(
      (c) => c.id == widget.conversationId,
      orElse: () => MockChats.ownerConversations.first,
    );
    _messages = List.of(_conversation.messages);
  }

  void _send() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    setState(() {
      _messages.add(ChatMessage(id: 'local_${_messages.length}', text: text, isMe: true, time: DateTime.now()));
      _controller.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: Row(
          children: [
            AppAvatar(imageUrl: _conversation.avatarUrl, size: 38, online: _conversation.online),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(_conversation.name, style: Theme.of(context).textTheme.titleMedium, overflow: TextOverflow.ellipsis),
                  Text(
                    _conversation.online ? 'Online' : 'Offline',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: _conversation.online ? AppColors.success : AppColors.grey400,
                        ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          IconButton(icon: const Icon(Icons.call_outlined), onPressed: () => _callDialog(context)),
          const SizedBox(width: AppSpacing.xs),
        ],
      ),
      body: Column(
        children: [
          GestureDetector(
            onTap: () => context.push(RoutePaths.ownerPropertyPreview(_conversation.property.id)),
            child: Container(
              margin: const EdgeInsets.all(AppSpacing.sm),
              padding: const EdgeInsets.all(AppSpacing.xs),
              decoration: BoxDecoration(color: AppColors.lightSurfaceAlt, borderRadius: BorderRadius.circular(AppRadius.md)),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: CachedNetworkImage(imageUrl: _conversation.property.images.first, height: 44, width: 44, fit: BoxFit.cover),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(_conversation.property.title, style: Theme.of(context).textTheme.titleSmall, maxLines: 1, overflow: TextOverflow.ellipsis),
                        Text(_conversation.property.priceLabel, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.accent)),
                      ],
                    ),
                  ),
                  const Icon(Icons.chevron_right_rounded, color: AppColors.grey400),
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.sm),
              itemCount: _messages.length,
              itemBuilder: (context, i) => _bubble(_messages[i]),
            ),
          ),
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(AppSpacing.sm, AppSpacing.xs, AppSpacing.sm, AppSpacing.sm),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.add_photo_alternate_outlined, color: AppColors.grey500),
                    onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Image attached (demo)')),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(color: AppColors.lightSurfaceAlt, borderRadius: BorderRadius.circular(AppRadius.pill)),
                      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                      child: TextField(
                        controller: _controller,
                        textInputAction: TextInputAction.send,
                        onSubmitted: (_) => _send(),
                        decoration: const InputDecoration(hintText: 'Type a message...', border: InputBorder.none, filled: false),
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.xs),
                  Material(
                    color: AppColors.accent,
                    shape: const CircleBorder(),
                    child: InkWell(
                      customBorder: const CircleBorder(),
                      onTap: _send,
                      child: const Padding(padding: EdgeInsets.all(12), child: Icon(Icons.send_rounded, color: Colors.white, size: 20)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _bubble(ChatMessage message) {
    final isMe = message.isMe;
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        constraints: const BoxConstraints(maxWidth: 260),
        padding: message.type == MessageType.image ? const EdgeInsets.all(4) : const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: isMe ? AppColors.accent : AppColors.lightSurfaceAlt,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: Radius.circular(isMe ? 16 : 4),
            bottomRight: Radius.circular(isMe ? 4 : 16),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            if (message.type == MessageType.image)
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: CachedNetworkImage(imageUrl: message.imageUrl!, height: 160, width: 200, fit: BoxFit.cover),
              )
            else
              Text(message.text, style: TextStyle(color: isMe ? Colors.white : AppColors.navy, fontSize: 14)),
            const SizedBox(height: 3),
            Text(
              DateFormat('h:mm a').format(message.time),
              style: TextStyle(fontSize: 10, color: isMe ? Colors.white.withValues(alpha: 0.7) : AppColors.grey500),
            ),
          ],
        ),
      ),
    );
  }

  void _callDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.lg)),
        title: Text('Call ${_conversation.name}'),
        content: const Text('+1 (415) 555-0134'),
        actions: [
          TextButton(onPressed: () => context.pop(), child: const Text('Cancel')),
          FilledButton(onPressed: () => context.pop(), child: const Text('Call')),
        ],
      ),
    );
  }
}
