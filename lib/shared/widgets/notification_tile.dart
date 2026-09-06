import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../models/notification_model.dart';

IconData iconForNotification(NotificationKind kind) => switch (kind) {
      NotificationKind.message => Icons.chat_bubble_rounded,
      NotificationKind.visit => Icons.calendar_month_rounded,
      NotificationKind.favorite => Icons.favorite_rounded,
      NotificationKind.price => Icons.trending_down_rounded,
      NotificationKind.system => Icons.info_rounded,
      NotificationKind.lead => Icons.person_add_alt_1_rounded,
      NotificationKind.approval => Icons.verified_rounded,
    };

class NotificationTile extends StatelessWidget {
  const NotificationTile({super.key, required this.notification});
  final AppNotification notification;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: notification.read
            ? Colors.transparent
            : (isDark ? AppColors.darkSurfaceAlt : AppColors.accentLight.withValues(alpha: 0.5)),
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 42,
            width: 42,
            decoration: BoxDecoration(color: AppColors.accent.withValues(alpha: 0.12), shape: BoxShape.circle),
            child: Icon(iconForNotification(notification.kind), color: AppColors.accent, size: 20),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(notification.title, style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 2),
                Text(notification.body, style: Theme.of(context).textTheme.bodyMedium),
                const SizedBox(height: 4),
                Text(DateFormat('MMM d, h:mm a').format(notification.time), style: Theme.of(context).textTheme.labelSmall),
              ],
            ),
          ),
          if (!notification.read)
            Container(
              margin: const EdgeInsets.only(top: 4),
              height: 8,
              width: 8,
              decoration: const BoxDecoration(color: AppColors.accent, shape: BoxShape.circle),
            ),
        ],
      ),
    );
  }
}
