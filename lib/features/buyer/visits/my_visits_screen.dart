import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../core/routing/route_paths.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/app_states.dart';
import '../../../core/widgets/status_badge.dart';
import '../../../shared/mock_data/mock_visits.dart';
import '../../../shared/models/visit_model.dart';

class MyVisitsScreen extends StatefulWidget {
  const MyVisitsScreen({super.key});

  @override
  State<MyVisitsScreen> createState() => _MyVisitsScreenState();
}

class _MyVisitsScreenState extends State<MyVisitsScreen> with SingleTickerProviderStateMixin {
  late final _tabController = TabController(length: 3, vsync: this);

  @override
  Widget build(BuildContext context) {
    final visits = MockVisits.myVisits;
    final upcoming = visits.where((v) => v.status == VisitStatus.upcoming).toList();
    final completed = visits.where((v) => v.status == VisitStatus.completed).toList();
    final cancelled = visits.where((v) => v.status == VisitStatus.cancelled).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Visits'),
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColors.accent,
          unselectedLabelColor: AppColors.grey500,
          indicatorColor: AppColors.accent,
          tabs: const [Tab(text: 'Upcoming'), Tab(text: 'Completed'), Tab(text: 'Cancelled')],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _list(upcoming, 'No Upcoming Visits', 'Schedule a visit from any property to see it here.'),
          _list(completed, 'No Completed Visits', 'Your visit history will appear here once completed.'),
          _list(cancelled, 'No Cancelled Visits', 'Cancelled visits will be listed here.'),
        ],
      ),
    );
  }

  Widget _list(List<VisitModel> visits, String emptyTitle, String emptyMessage) {
    if (visits.isEmpty) {
      return EmptyState(icon: Icons.event_busy_rounded, title: emptyTitle, message: emptyMessage);
    }
    return ListView.separated(
      padding: const EdgeInsets.all(AppSpacing.lg),
      itemCount: visits.length,
      separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.md),
      itemBuilder: (context, i) {
        final v = visits[i];
        return GestureDetector(
          onTap: () => context.push(RoutePaths.buyerPropertyDetails(v.property.id)),
          child: Container(
            padding: const EdgeInsets.all(AppSpacing.sm),
            decoration: BoxDecoration(
              color: Theme.of(context).cardTheme.color,
              borderRadius: BorderRadius.circular(AppRadius.md),
              border: Border.all(color: AppColors.lightBorder),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: CachedNetworkImage(imageUrl: v.property.images.first, height: 64, width: 64, fit: BoxFit.cover),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(v.property.title, style: Theme.of(context).textTheme.titleMedium, maxLines: 1, overflow: TextOverflow.ellipsis),
                      const SizedBox(height: 4),
                      Row(children: [
                        const Icon(Icons.calendar_today_outlined, size: 13, color: AppColors.grey500),
                        const SizedBox(width: 4),
                        Text('${DateFormat('MMM d, yyyy').format(v.date)} • ${v.timeSlot}', style: Theme.of(context).textTheme.bodySmall),
                      ]),
                      const SizedBox(height: 6),
                      _statusChip(v.status),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _statusChip(VisitStatus status) {
    final mapped = switch (status) {
      VisitStatus.upcoming => AppStatus.confirmed,
      VisitStatus.completed => AppStatus.completed,
      VisitStatus.cancelled => AppStatus.cancelled,
      VisitStatus.pending => AppStatus.pending,
      VisitStatus.confirmed => AppStatus.confirmed,
    };
    return StatusChip(status: mapped, label: status == VisitStatus.upcoming ? 'Upcoming' : null);
  }
}
