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
import '../../../shared/mock_data/mock_reports.dart';
import '../../../shared/models/report_model.dart';

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  late final List<ReportModel> _reports = List.of(MockReports.all);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Reports')),
      body: _reports.isEmpty
          ? const EmptyState(icon: Icons.flag_outlined, title: 'No Reports', message: 'Reported properties will show up here for review.')
          : ListView.separated(
              padding: const EdgeInsets.all(AppSpacing.lg),
              itemCount: _reports.length,
              separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.md),
              itemBuilder: (context, i) => _card(context, _reports[i]),
            ),
    );
  }

  Widget _card(BuildContext context, ReportModel r) {
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
              ClipRRect(borderRadius: BorderRadius.circular(10), child: CachedNetworkImage(imageUrl: r.property.images.first, height: 48, width: 48, fit: BoxFit.cover)),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(r.property.title, style: Theme.of(context).textTheme.titleSmall, maxLines: 1, overflow: TextOverflow.ellipsis),
                    Text(r.reason, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.error)),
                  ],
                ),
              ),
              StatusChip(status: _statusFor(r.status)),
            ],
          ),
          const Padding(padding: EdgeInsets.symmetric(vertical: AppSpacing.sm), child: Divider(height: 1)),
          if (r.details != null) ...[
            Text(r.details!, style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: AppSpacing.sm),
          ],
          Row(
            children: [
              AppAvatar(imageUrl: r.reporterAvatar, size: 26),
              const SizedBox(width: 6),
              Expanded(child: Text('Reported by ${r.reporterName}', style: Theme.of(context).textTheme.bodySmall)),
              Text(DateFormat('MMM d').format(r.date), style: Theme.of(context).textTheme.labelSmall),
            ],
          ),
          if (r.status == ReportStatus.pending) ...[
            const SizedBox(height: AppSpacing.md),
            Row(
              children: [
                Expanded(
                  child: SecondaryButton(
                    label: 'Dismiss',
                    size: AppButtonSize.small,
                    onPressed: () => _resolve(r, ReportStatus.dismissed),
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: PrimaryButton(
                    label: 'Resolve',
                    size: AppButtonSize.small,
                    onPressed: () => _resolve(r, ReportStatus.resolved),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  AppStatus _statusFor(ReportStatus status) => switch (status) {
        ReportStatus.pending => AppStatus.pending,
        ReportStatus.resolved => AppStatus.completed,
        ReportStatus.dismissed => AppStatus.rejected,
      };

  void _resolve(ReportModel report, ReportStatus status) async {
    final confirm = await AppDialogs.confirm(
      context,
      title: status == ReportStatus.resolved ? 'Resolve Report' : 'Dismiss Report',
      message: status == ReportStatus.resolved
          ? 'Mark this report as resolved and take action on the listing?'
          : 'Dismiss this report as invalid or already handled?',
      confirmLabel: status == ReportStatus.resolved ? 'Resolve' : 'Dismiss',
    );
    if (!confirm) return;
    setState(() {
      final index = _reports.indexWhere((r) => r.id == report.id);
      _reports[index] = ReportModel(
        id: report.id,
        property: report.property,
        reason: report.reason,
        reporterName: report.reporterName,
        reporterAvatar: report.reporterAvatar,
        date: report.date,
        status: status,
        details: report.details,
      );
    });
    if (mounted) AppDialogs.success(context, status == ReportStatus.resolved ? 'Report resolved' : 'Report dismissed');
  }
}
