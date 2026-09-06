import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../core/routing/route_paths.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_dialogs.dart';
import '../../../core/widgets/app_states.dart';
import '../../../shared/mock_data/mock_properties.dart';
import '../../../shared/models/property_model.dart';

class PendingApprovalScreen extends StatefulWidget {
  const PendingApprovalScreen({super.key});

  @override
  State<PendingApprovalScreen> createState() => _PendingApprovalScreenState();
}

class _PendingApprovalScreenState extends State<PendingApprovalScreen> {
  late final List<PropertyModel> _pending =
      MockProperties.all.where((p) => p.status == PropertyStatus.pending || p.status == PropertyStatus.draft).toList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pending Approval')),
      body: _pending.isEmpty
          ? const EmptyState(
              icon: Icons.task_alt_rounded,
              title: 'All Caught Up',
              message: 'There are no properties waiting for approval right now.',
            )
          : ListView.separated(
              padding: const EdgeInsets.all(AppSpacing.lg),
              itemCount: _pending.length,
              separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.md),
              itemBuilder: (context, i) => _card(context, _pending[i]),
            ),
    );
  }

  Widget _card(BuildContext context, PropertyModel p) {
    return GestureDetector(
      onTap: () => context.push(RoutePaths.adminApprovalDetails(p.id)),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).cardTheme.color,
          borderRadius: BorderRadius.circular(AppRadius.md),
          border: Border.all(color: AppColors.lightBorder),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(aspectRatio: 16 / 8, child: CachedNetworkImage(imageUrl: p.images.first, fit: BoxFit.cover)),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(p.title, style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 2),
                  Text('${p.location}, ${p.city} • ${p.type.label}', style: Theme.of(context).textTheme.bodySmall),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(p.priceLabel, style: Theme.of(context).textTheme.titleMedium?.copyWith(color: AppColors.accent)),
                      const Spacer(),
                      Text('by ${p.agent.name}', style: Theme.of(context).textTheme.bodySmall),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Submitted ${DateFormat('MMM d, yyyy').format(p.postedDate ?? DateTime.now())}',
                    style: Theme.of(context).textTheme.labelSmall,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Row(
                    children: [
                      Expanded(
                        child: SecondaryButton(
                          label: 'Reject',
                          size: AppButtonSize.small,
                          onPressed: () => _decide(context, p, approve: false),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(
                        child: PrimaryButton(
                          label: 'Approve',
                          size: AppButtonSize.small,
                          onPressed: () => _decide(context, p, approve: true),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _decide(BuildContext context, PropertyModel p, {required bool approve}) async {
    final confirm = await AppDialogs.confirm(
      context,
      title: approve ? 'Approve Property' : 'Reject Property',
      message: approve
          ? '"${p.title}" will go live and be visible to all buyers.'
          : '"${p.title}" will be rejected and the owner will be notified.',
      confirmLabel: approve ? 'Approve' : 'Reject',
      destructive: !approve,
      icon: approve ? Icons.check_circle_outline_rounded : Icons.cancel_outlined,
    );
    if (!confirm) return;
    setState(() => _pending.removeWhere((e) => e.id == p.id));
    if (mounted) AppDialogs.success(context, approve ? 'Property approved and published' : 'Property rejected');
  }
}
