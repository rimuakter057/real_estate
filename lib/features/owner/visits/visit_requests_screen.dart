import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_dialogs.dart';
import '../../../core/widgets/app_states.dart';
import '../../../core/widgets/avatar.dart';
import '../../../core/widgets/status_badge.dart';
import '../../../shared/mock_data/mock_visits.dart';
import '../../../shared/models/visit_model.dart';

class VisitRequestsScreen extends StatefulWidget {
  const VisitRequestsScreen({super.key});

  @override
  State<VisitRequestsScreen> createState() => _VisitRequestsScreenState();
}

class _VisitRequestsScreenState extends State<VisitRequestsScreen> with SingleTickerProviderStateMixin {
  late final _tabController = TabController(length: 4, vsync: this);
  final List<VisitModel> _requests = List.of(MockVisits.requests);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Visit Requests'),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          labelColor: AppColors.accent,
          unselectedLabelColor: AppColors.grey500,
          indicatorColor: AppColors.accent,
          tabs: const [Tab(text: 'Pending'), Tab(text: 'Confirmed'), Tab(text: 'Completed'), Tab(text: 'Cancelled')],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _list(_requests.where((v) => v.status == VisitStatus.pending).toList(), true),
          _list(_requests.where((v) => v.status == VisitStatus.confirmed).toList(), false),
          _list(_requests.where((v) => v.status == VisitStatus.completed).toList(), false),
          _list(_requests.where((v) => v.status == VisitStatus.cancelled).toList(), false),
        ],
      ),
    );
  }

  Widget _list(List<VisitModel> visits, bool pending) {
    if (visits.isEmpty) {
      return const EmptyState(
        icon: Icons.event_note_outlined,
        title: 'No Visit Requests',
        message: 'Visit requests from interested buyers will appear here.',
      );
    }
    return ListView.separated(
      padding: const EdgeInsets.all(AppSpacing.lg),
      itemCount: visits.length,
      separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.md),
      itemBuilder: (context, i) {
        final v = visits[i];
        return Container(
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
                  AppAvatar(imageUrl: v.visitorAvatar, size: 40),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(v.visitorName, style: Theme.of(context).textTheme.titleMedium),
                        Text(v.visitorPhone, style: Theme.of(context).textTheme.bodySmall),
                      ],
                    ),
                  ),
                  StatusChip(status: _statusFor(v.status)),
                ],
              ),
              const Padding(padding: EdgeInsets.symmetric(vertical: AppSpacing.sm), child: Divider(height: 1)),
              Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: CachedNetworkImage(imageUrl: v.property.images.first, height: 44, width: 44, fit: BoxFit.cover),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(v.property.title, style: Theme.of(context).textTheme.titleSmall, maxLines: 1, overflow: TextOverflow.ellipsis),
                        Text('${DateFormat('MMM d').format(v.date)} • ${v.timeSlot}', style: Theme.of(context).textTheme.bodySmall),
                      ],
                    ),
                  ),
                ],
              ),
              if (v.note != null) ...[
                const SizedBox(height: AppSpacing.sm),
                Text(v.note!, style: Theme.of(context).textTheme.bodySmall?.copyWith(fontStyle: FontStyle.italic)),
              ],
              if (pending) ...[
                const SizedBox(height: AppSpacing.md),
                Row(
                  children: [
                    Expanded(
                      child: SecondaryButton(
                        label: 'Reject',
                        size: AppButtonSize.small,
                        onPressed: () => _updateStatus(v, VisitStatus.cancelled),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: SecondaryButton(
                        label: 'Reschedule',
                        size: AppButtonSize.small,
                        onPressed: () => _reschedule(v),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: PrimaryButton(
                        label: 'Accept',
                        size: AppButtonSize.small,
                        onPressed: () => _updateStatus(v, VisitStatus.confirmed),
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  AppStatus _statusFor(VisitStatus status) => switch (status) {
        VisitStatus.pending => AppStatus.pending,
        VisitStatus.confirmed => AppStatus.confirmed,
        VisitStatus.completed => AppStatus.completed,
        VisitStatus.cancelled => AppStatus.cancelled,
        VisitStatus.upcoming => AppStatus.confirmed,
      };

  void _updateStatus(VisitModel visit, VisitStatus status) async {
    final confirm = await AppDialogs.confirm(
      context,
      title: status == VisitStatus.confirmed ? 'Accept Visit' : 'Reject Visit',
      message: status == VisitStatus.confirmed
          ? 'Confirm the visit with ${visit.visitorName} on ${DateFormat('MMM d').format(visit.date)}?'
          : 'Reject the visit request from ${visit.visitorName}?',
      confirmLabel: status == VisitStatus.confirmed ? 'Accept' : 'Reject',
      destructive: status != VisitStatus.confirmed,
    );
    if (!confirm) return;
    setState(() {
      final index = _requests.indexWhere((r) => r.id == visit.id);
      _requests[index] = VisitModel(
        id: visit.id,
        property: visit.property,
        date: visit.date,
        timeSlot: visit.timeSlot,
        status: status,
        visitorName: visit.visitorName,
        visitorAvatar: visit.visitorAvatar,
        visitorPhone: visit.visitorPhone,
        note: visit.note,
      );
    });
    if (mounted) {
      AppDialogs.success(context, status == VisitStatus.confirmed ? 'Visit accepted' : 'Visit rejected');
    }
  }

  void _reschedule(VisitModel visit) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => AppBottomSheet(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Propose New Time', style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: AppSpacing.md),
            Wrap(
              spacing: AppSpacing.sm,
              runSpacing: AppSpacing.sm,
              children: ['10:00 AM', '11:30 AM', '1:00 PM', '3:00 PM', '4:30 PM']
                  .map((t) => ActionChip(
                        label: Text(t),
                        onPressed: () {
                          Navigator.of(context).pop();
                          AppDialogs.success(context, 'Reschedule proposal sent to ${visit.visitorName}');
                        },
                      ))
                  .toList(),
            ),
            const SizedBox(height: AppSpacing.md),
          ],
        ),
      ),
    );
  }
}
