import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../core/routing/route_paths.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/app_states.dart';
import '../../../core/widgets/avatar.dart';
import '../../../core/widgets/status_badge.dart';
import '../../../shared/mock_data/mock_leads.dart';
import '../../../shared/models/lead_model.dart';

class LeadsScreen extends StatelessWidget {
  const LeadsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final leads = MockLeads.all;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Leads'),
        actions: [
          IconButton(icon: const Icon(Icons.event_available_outlined), onPressed: () => context.push(RoutePaths.ownerVisitRequests)),
          const SizedBox(width: AppSpacing.sm),
        ],
      ),
      body: leads.isEmpty
          ? const EmptyState(
              icon: Icons.groups_outlined,
              title: 'No Leads Yet',
              message: 'Interested buyers who contact you about your listings will show up here.',
            )
          : ListView.separated(
              padding: const EdgeInsets.all(AppSpacing.lg),
              itemCount: leads.length,
              separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.md),
              itemBuilder: (context, i) => _leadCard(context, leads[i]),
            ),
    );
  }

  Widget _leadCard(BuildContext context, LeadModel lead) {
    return GestureDetector(
      onTap: () => context.push(RoutePaths.ownerLeadDetails(lead.id)),
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: Theme.of(context).cardTheme.color,
          borderRadius: BorderRadius.circular(AppRadius.md),
          border: Border.all(color: AppColors.lightBorder),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                AppAvatar(imageUrl: lead.customerAvatar, size: 44),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(lead.customerName, style: Theme.of(context).textTheme.titleMedium),
                      Text(lead.property.title, style: Theme.of(context).textTheme.bodySmall, maxLines: 1, overflow: TextOverflow.ellipsis),
                    ],
                  ),
                ),
                StatusChip(status: _statusFor(lead.status), label: lead.status.label),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(lead.message, style: Theme.of(context).textTheme.bodyMedium, maxLines: 2, overflow: TextOverflow.ellipsis),
            const SizedBox(height: AppSpacing.sm),
            Row(
              children: [
                const Icon(Icons.access_time_rounded, size: 13, color: AppColors.grey500),
                const SizedBox(width: 4),
                Text(DateFormat('MMM d, h:mm a').format(lead.contactDate), style: Theme.of(context).textTheme.labelSmall),
                const Spacer(),
                IconButton(
                  visualDensity: VisualDensity.compact,
                  icon: const Icon(Icons.call_outlined, size: 20, color: AppColors.accent),
                  onPressed: () => _call(context, lead),
                ),
                IconButton(
                  visualDensity: VisualDensity.compact,
                  icon: const Icon(Icons.chat_bubble_outline_rounded, size: 20, color: AppColors.accent),
                  onPressed: () => context.push(RoutePaths.ownerChatDetail('oc1')),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  AppStatus _statusFor(LeadStatus status) => switch (status) {
        LeadStatus.newLead => AppStatus.pending,
        LeadStatus.contacted => AppStatus.active,
        LeadStatus.negotiating => AppStatus.pending,
        LeadStatus.closed => AppStatus.completed,
        LeadStatus.lost => AppStatus.rejected,
      };

  void _call(BuildContext context, LeadModel lead) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.lg)),
        title: Text('Call ${lead.customerName}'),
        content: Text(lead.customerPhone),
        actions: [
          TextButton(onPressed: () => context.pop(), child: const Text('Cancel')),
          FilledButton(onPressed: () => context.pop(), child: const Text('Call')),
        ],
      ),
    );
  }
}
