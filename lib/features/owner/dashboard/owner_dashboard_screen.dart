import 'package:cached_network_image/cached_network_image.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/routing/route_paths.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/avatar.dart';
import '../../../core/widgets/section_header.dart';
import '../../../core/widgets/status_badge.dart';
import '../../../shared/mock_data/mock_agents.dart';
import '../../../shared/mock_data/mock_leads.dart';
import '../../../shared/mock_data/mock_properties.dart';
import '../../../shared/models/property_model.dart';

class OwnerDashboardScreen extends StatelessWidget {
  const OwnerDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final me = MockAgents.me;
    final myProperties = MockProperties.byAgent(me.id);
    final active = myProperties.where((p) => p.status == PropertyStatus.active).length;
    final totalViews = myProperties.fold<int>(0, (sum, p) => sum + p.views);
    final interested = myProperties.fold<int>(0, (sum, p) => sum + p.interested);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            AppAvatar(imageUrl: me.avatarUrl, size: 32),
            const SizedBox(width: AppSpacing.sm),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Welcome back,', style: Theme.of(context).textTheme.bodySmall),
                Text(me.name.split(' ').first, style: Theme.of(context).textTheme.titleMedium),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(icon: const Icon(Icons.chat_bubble_outline_rounded), onPressed: () => context.push(RoutePaths.ownerMessages)),
          IconButton(icon: const Icon(Icons.notifications_none_rounded), onPressed: () => context.push(RoutePaths.ownerNotifications)),
          const SizedBox(width: AppSpacing.sm),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        children: [
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: AppSpacing.md,
            crossAxisSpacing: AppSpacing.md,
            childAspectRatio: 1.5,
            children: [
              _statCard(context, 'Total Properties', '${myProperties.length}', Icons.apartment_rounded, AppColors.accent),
              _statCard(context, 'Active Listings', '$active', Icons.check_circle_outline_rounded, AppColors.success),
              _statCard(context, 'Total Views', '$totalViews', Icons.visibility_outlined, AppColors.info),
              _statCard(context, 'Interested Users', '$interested', Icons.favorite_border_rounded, AppColors.warning),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: AppColors.navy,
              borderRadius: BorderRadius.circular(AppRadius.lg),
            ),
            child: Row(
              children: [
                Container(
                  height: 44,
                  width: 44,
                  decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.12), shape: BoxShape.circle),
                  child: const Icon(Icons.pending_actions_rounded, color: Colors.white),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text('3 Pending Visits', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 15)),
                      Text('Review and confirm visit requests', style: TextStyle(color: Colors.white70, fontSize: 12)),
                    ],
                  ),
                ),
                TextButton(
                  onPressed: () => context.push(RoutePaths.ownerVisitRequests),
                  style: TextButton.styleFrom(foregroundColor: Colors.white, backgroundColor: Colors.white.withValues(alpha: 0.12)),
                  child: const Text('Review'),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          SectionHeader(title: 'Property Performance', subtitle: 'Views over the last 6 months'),
          const SizedBox(height: AppSpacing.md),
          Container(
            height: 200,
            padding: const EdgeInsets.fromLTRB(AppSpacing.sm, AppSpacing.lg, AppSpacing.md, AppSpacing.sm),
            decoration: BoxDecoration(
              color: Theme.of(context).cardTheme.color,
              borderRadius: BorderRadius.circular(AppRadius.lg),
              border: Border.all(color: AppColors.lightBorder),
            ),
            child: LineChart(
              LineChartData(
                gridData: const FlGridData(show: false),
                titlesData: FlTitlesData(
                  leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: 1,
                      getTitlesWidget: (value, meta) {
                        const months = ['Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep'];
                        if (value != value.roundToDouble() || value.toInt() < 0 || value.toInt() >= months.length) {
                          return const SizedBox();
                        }
                        return Padding(
                          padding: const EdgeInsets.only(top: 6),
                          child: Text(months[value.toInt()], style: Theme.of(context).textTheme.labelSmall),
                        );
                      },
                    ),
                  ),
                ),
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  LineChartBarData(
                    spots: const [
                      FlSpot(0, 320),
                      FlSpot(1, 480),
                      FlSpot(2, 410),
                      FlSpot(3, 610),
                      FlSpot(4, 740),
                      FlSpot(5, 860),
                    ],
                    isCurved: true,
                    color: AppColors.accent,
                    barWidth: 3,
                    dotData: const FlDotData(show: false),
                    belowBarData: BarAreaData(show: true, color: AppColors.accent.withValues(alpha: 0.12)),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          SectionHeader(title: 'Recent Leads', actionLabel: 'See all', onAction: () => context.go(RoutePaths.ownerLeads)),
          const SizedBox(height: AppSpacing.sm),
          for (final lead in MockLeads.all.take(3))
            Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.sm),
              child: GestureDetector(
                onTap: () => context.push(RoutePaths.ownerLeadDetails(lead.id)),
                child: Container(
                  padding: const EdgeInsets.all(AppSpacing.sm),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardTheme.color,
                    borderRadius: BorderRadius.circular(AppRadius.md),
                    border: Border.all(color: AppColors.lightBorder),
                  ),
                  child: Row(
                    children: [
                      AppAvatar(imageUrl: lead.customerAvatar, size: 40),
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(lead.customerName, style: Theme.of(context).textTheme.titleSmall),
                            Text(lead.property.title, style: Theme.of(context).textTheme.bodySmall, maxLines: 1, overflow: TextOverflow.ellipsis),
                          ],
                        ),
                      ),
                      StatusChip(status: _leadStatus(lead.status.name)),
                    ],
                  ),
                ),
              ),
            ),
          const SizedBox(height: AppSpacing.lg),
          SectionHeader(title: 'Recent Properties', actionLabel: 'See all', onAction: () => context.go(RoutePaths.ownerProperties)),
          const SizedBox(height: AppSpacing.sm),
          for (final p in myProperties.take(3))
            Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.sm),
              child: GestureDetector(
                onTap: () => context.push(RoutePaths.ownerPropertyPreview(p.id)),
                child: Container(
                  padding: const EdgeInsets.all(AppSpacing.sm),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardTheme.color,
                    borderRadius: BorderRadius.circular(AppRadius.md),
                    border: Border.all(color: AppColors.lightBorder),
                  ),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: CachedNetworkImage(imageUrl: p.images.first, height: 52, width: 52, fit: BoxFit.cover),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(p.title, style: Theme.of(context).textTheme.titleSmall, maxLines: 1, overflow: TextOverflow.ellipsis),
                            Text('${p.views} views • ${p.interested} interested', style: Theme.of(context).textTheme.bodySmall),
                          ],
                        ),
                      ),
                      Text(p.priceLabel, style: Theme.of(context).textTheme.titleSmall?.copyWith(color: AppColors.accent)),
                    ],
                  ),
                ),
              ),
            ),
          const SizedBox(height: AppSpacing.xxl),
        ],
      ),
    );
  }

  AppStatus _leadStatus(String status) => switch (status) {
        'newLead' => AppStatus.pending,
        'contacted' => AppStatus.active,
        'negotiating' => AppStatus.pending,
        'closed' => AppStatus.completed,
        _ => AppStatus.rejected,
      };

  Widget _statCard(BuildContext context, String label, String value, IconData icon, Color color) {
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
          Container(
            height: 34,
            width: 34,
            decoration: BoxDecoration(color: color.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(10)),
            child: Icon(icon, color: color, size: 18),
          ),
          const Spacer(),
          Text(value, style: Theme.of(context).textTheme.headlineMedium),
          Text(label, style: Theme.of(context).textTheme.bodySmall),
        ],
      ),
    );
  }
}
