import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../core/routing/route_paths.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/avatar.dart';
import '../../../core/widgets/status_badge.dart';
import '../../../shared/mock_data/mock_leads.dart';
import '../../../shared/models/lead_model.dart';

class LeadDetailsScreen extends StatelessWidget {
  const LeadDetailsScreen({super.key, required this.leadId});
  final String leadId;

  @override
  Widget build(BuildContext context) {
    final lead = MockLeads.all.firstWhere((l) => l.id == leadId, orElse: () => MockLeads.all.first);
    return Scaffold(
      appBar: AppBar(title: const Text('Lead Details')),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        children: [
          Center(
            child: Column(
              children: [
                AppAvatar(imageUrl: lead.customerAvatar, size: 80),
                const SizedBox(height: AppSpacing.sm),
                Text(lead.customerName, style: Theme.of(context).textTheme.headlineSmall),
                const SizedBox(height: 4),
                StatusChip(status: _statusFor(lead.status), label: lead.status.label),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          Row(
            children: [
              Expanded(
                child: SecondaryButton(
                  label: 'Call',
                  icon: Icons.call_outlined,
                  onPressed: () => showDialog(
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
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: PrimaryButton(
                  label: 'Message',
                  icon: Icons.chat_bubble_outline_rounded,
                  onPressed: () => context.push(RoutePaths.ownerChatDetail('oc1')),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xl),
          Text('Contact Information', style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: AppSpacing.sm),
          _infoRow(context, Icons.phone_outlined, 'Phone', lead.customerPhone),
          _infoRow(context, Icons.calendar_today_outlined, 'Contacted On', DateFormat('MMM d, yyyy • h:mm a').format(lead.contactDate)),
          const SizedBox(height: AppSpacing.xl),
          Text('Message', style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: AppSpacing.sm),
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(color: AppColors.lightSurfaceAlt, borderRadius: BorderRadius.circular(AppRadius.md)),
            child: Text(lead.message, style: Theme.of(context).textTheme.bodyMedium),
          ),
          const SizedBox(height: AppSpacing.xl),
          Text('Interested Property', style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: AppSpacing.sm),
          GestureDetector(
            onTap: () => context.push(RoutePaths.ownerPropertyPreview(lead.property.id)),
            child: Container(
              padding: const EdgeInsets.all(AppSpacing.sm),
              decoration: BoxDecoration(border: Border.all(color: AppColors.lightBorder), borderRadius: BorderRadius.circular(AppRadius.md)),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: CachedNetworkImage(imageUrl: lead.property.images.first, height: 56, width: 56, fit: BoxFit.cover),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(lead.property.title, style: Theme.of(context).textTheme.titleSmall),
                        Text(lead.property.priceLabel, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.accent)),
                      ],
                    ),
                  ),
                  const Icon(Icons.chevron_right_rounded, color: AppColors.grey400),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          Text('Update Status', style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: AppSpacing.sm),
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: LeadStatus.values
                .map((s) => ChoiceChip(
                      label: Text(s.label),
                      selected: lead.status == s,
                      onSelected: (_) => ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Lead marked as ${s.label}')),
                      ),
                      selectedColor: AppColors.accent,
                      labelStyle: TextStyle(color: lead.status == s ? Colors.white : AppColors.navy, fontWeight: FontWeight.w600),
                      backgroundColor: AppColors.lightSurfaceAlt,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.pill), side: BorderSide.none),
                    ))
                .toList(),
          ),
        ],
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

  Widget _infoRow(BuildContext context, IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 18, color: AppColors.grey500),
          const SizedBox(width: AppSpacing.sm),
          Expanded(child: Text(label, style: Theme.of(context).textTheme.bodyMedium)),
          Text(value, style: Theme.of(context).textTheme.titleSmall),
        ],
      ),
    );
  }
}
