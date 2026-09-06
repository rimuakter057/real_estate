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
import '../../../shared/mock_data/mock_properties.dart';
import '../../../shared/mock_data/mock_reports.dart';
import '../../../shared/mock_data/mock_users.dart';
import '../../../shared/models/property_model.dart';
import '../../../shared/models/report_model.dart';

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final properties = MockProperties.all;
    final pending = properties.where((p) => p.status == PropertyStatus.pending || p.status == PropertyStatus.draft).length;
    final active = properties.where((p) => p.status == PropertyStatus.active).length;
    final sold = properties.where((p) => p.status == PropertyStatus.sold).length;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [
          IconButton(icon: const Icon(Icons.notifications_none_rounded), onPressed: () {}),
          const SizedBox(width: AppSpacing.sm),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        children: [
          LayoutBuilder(builder: (context, constraints) {
            final columns = constraints.maxWidth > 900 ? 4 : (constraints.maxWidth > 560 ? 3 : 2);
            final cards = [
              _statCard('Total Users', '${MockUsers.platformUsers.length + 128}', Icons.people_alt_rounded, AppColors.info),
              _statCard('Total Agents', '42', Icons.badge_rounded, AppColors.accent),
              _statCard('Total Properties', '${properties.length + 96}', Icons.apartment_rounded, AppColors.navySoft),
              _statCard('Active Listings', '${active + 88}', Icons.check_circle_rounded, AppColors.success),
              _statCard('Pending Approval', '$pending', Icons.pending_actions_rounded, AppColors.warning),
              _statCard('Sold / Rented', '${sold + 34}', Icons.sell_rounded, AppColors.grey600),
              _statCard('Total Visits', '312', Icons.event_available_rounded, AppColors.info),
              _statCard('Reported Properties', '${MockReports.all.length}', Icons.flag_rounded, AppColors.error),
            ];
            return GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: columns,
                mainAxisSpacing: AppSpacing.md,
                crossAxisSpacing: AppSpacing.md,
                mainAxisExtent: 128,
              ),
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: cards.length,
              itemBuilder: (context, index) => cards[index],
            );
          }),
          const SizedBox(height: AppSpacing.xl),
          LayoutBuilder(builder: (context, constraints) {
            final wide = constraints.maxWidth > 760;
            final propertyChart = _chartCard(
              context,
              title: 'Property Statistics',
              subtitle: 'New listings per month',
              child: BarChart(
                BarChartData(
                  gridData: const FlGridData(show: false),
                  borderData: FlBorderData(show: false),
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
                          return Padding(padding: const EdgeInsets.only(top: 6), child: Text(months[value.toInt()], style: Theme.of(context).textTheme.labelSmall));
                        },
                      ),
                    ),
                  ),
                  barGroups: [18, 24, 20, 30, 26, 34].asMap().entries.map((e) {
                    return BarChartGroupData(x: e.key, barRods: [
                      BarChartRodData(toY: e.value.toDouble(), color: AppColors.accent, width: 16, borderRadius: BorderRadius.circular(4)),
                    ]);
                  }).toList(),
                ),
              ),
            );
            final userChart = _chartCard(
              context,
              title: 'User Statistics',
              subtitle: 'Buyer vs Agent signups',
              child: PieChart(
                PieChartData(
                  sectionsSpace: 3,
                  centerSpaceRadius: 36,
                  sections: [
                    PieChartSectionData(value: 68, color: AppColors.accent, title: '68%', radius: 46, titleStyle: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w700)),
                    PieChartSectionData(value: 22, color: AppColors.info, title: '22%', radius: 46, titleStyle: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w700)),
                    PieChartSectionData(value: 10, color: AppColors.warning, title: '10%', radius: 46, titleStyle: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w700)),
                  ],
                ),
              ),
              legend: const [('Buyers', AppColors.accent), ('Agents', AppColors.info), ('Admins', AppColors.warning)],
            );
            if (wide) {
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [Expanded(child: propertyChart), const SizedBox(width: AppSpacing.md), Expanded(child: userChart)],
              );
            }
            return Column(children: [propertyChart, const SizedBox(height: AppSpacing.md), userChart]);
          }),
          const SizedBox(height: AppSpacing.xl),
          SectionHeader(title: 'Recent Properties', actionLabel: 'See all', onAction: () => context.go(RoutePaths.adminProperties)),
          const SizedBox(height: AppSpacing.sm),
          for (final p in MockProperties.recentlyAdded.take(3))
            Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.sm),
              child: GestureDetector(
                onTap: () => context.push(RoutePaths.adminPropertyDetails(p.id)),
                child: Container(
                  padding: const EdgeInsets.all(AppSpacing.sm),
                  decoration: BoxDecoration(color: Theme.of(context).cardTheme.color, borderRadius: BorderRadius.circular(AppRadius.md), border: Border.all(color: AppColors.lightBorder)),
                  child: Row(
                    children: [
                      ClipRRect(borderRadius: BorderRadius.circular(10), child: CachedNetworkImage(imageUrl: p.images.first, height: 52, width: 52, fit: BoxFit.cover)),
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(p.title, style: Theme.of(context).textTheme.titleSmall, maxLines: 1, overflow: TextOverflow.ellipsis),
                            Text('by ${p.agent.name}', style: Theme.of(context).textTheme.bodySmall),
                          ],
                        ),
                      ),
                      StatusChip(status: _statusFor(p.status)),
                    ],
                  ),
                ),
              ),
            ),
          const SizedBox(height: AppSpacing.lg),
          SectionHeader(title: 'Recent Users', actionLabel: 'See all', onAction: () => context.go(RoutePaths.adminUsers)),
          const SizedBox(height: AppSpacing.sm),
          for (final u in MockUsers.platformUsers.take(3))
            Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.sm),
              child: GestureDetector(
                onTap: () => context.push(RoutePaths.adminUserDetails(u.id)),
                child: Container(
                  padding: const EdgeInsets.all(AppSpacing.sm),
                  decoration: BoxDecoration(color: Theme.of(context).cardTheme.color, borderRadius: BorderRadius.circular(AppRadius.md), border: Border.all(color: AppColors.lightBorder)),
                  child: Row(
                    children: [
                      AppAvatar(imageUrl: u.avatarUrl, size: 40),
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(u.name, style: Theme.of(context).textTheme.titleSmall),
                            Text(
                              u.email,
                              style: Theme.of(context).textTheme.bodySmall,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      StatusChip(status: u.active ? AppStatus.active : AppStatus.rejected, label: u.active ? 'Active' : 'Deactivated'),
                    ],
                  ),
                ),
              ),
            ),
          const SizedBox(height: AppSpacing.lg),
          SectionHeader(title: 'Recent Reports', actionLabel: 'See all', onAction: () => context.go(RoutePaths.adminReports)),
          const SizedBox(height: AppSpacing.sm),
          for (final r in MockReports.all.take(2))
            Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.sm),
              child: Container(
                padding: const EdgeInsets.all(AppSpacing.sm),
                decoration: BoxDecoration(color: Theme.of(context).cardTheme.color, borderRadius: BorderRadius.circular(AppRadius.md), border: Border.all(color: AppColors.lightBorder)),
                child: Row(
                  children: [
                    Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(color: AppColors.error.withValues(alpha: 0.1), shape: BoxShape.circle),
                      child: const Icon(Icons.flag_rounded, color: AppColors.error, size: 18),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(r.reason, style: Theme.of(context).textTheme.titleSmall),
                          Text(r.property.title, style: Theme.of(context).textTheme.bodySmall, maxLines: 1, overflow: TextOverflow.ellipsis),
                        ],
                      ),
                    ),
                    StatusChip(status: r.status == ReportStatus.pending ? AppStatus.pending : AppStatus.completed),
                  ],
                ),
              ),
            ),
          const SizedBox(height: AppSpacing.xxl),
        ],
      ),
    );
  }

  AppStatus _statusFor(PropertyStatus status) => switch (status) {
        PropertyStatus.active => AppStatus.active,
        PropertyStatus.pending => AppStatus.pending,
        PropertyStatus.draft => AppStatus.draft,
        PropertyStatus.sold => AppStatus.sold,
      };

  Widget _statCard(String label, String value, IconData icon, Color color) {
    return Builder(builder: (context) {
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
              height: 32,
              width: 32,
              decoration: BoxDecoration(color: color.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(8)),
              child: Icon(icon, color: color, size: 16),
            ),
            const Spacer(),
            Text(value, style: Theme.of(context).textTheme.headlineSmall),
            Text(label, style: Theme.of(context).textTheme.bodySmall, maxLines: 1, overflow: TextOverflow.ellipsis),
          ],
        ),
      );
    });
  }

  Widget _chartCard(BuildContext context, {required String title, required String subtitle, required Widget child, List<(String, Color)>? legend}) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: AppColors.lightBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: Theme.of(context).textTheme.titleLarge),
          Text(subtitle, style: Theme.of(context).textTheme.bodySmall),
          const SizedBox(height: AppSpacing.md),
          SizedBox(height: 180, child: child),
          if (legend != null) ...[
            const SizedBox(height: AppSpacing.sm),
            Wrap(
              spacing: AppSpacing.md,
              children: legend
                  .map((l) => Row(mainAxisSize: MainAxisSize.min, children: [
                        Container(height: 8, width: 8, decoration: BoxDecoration(color: l.$2, shape: BoxShape.circle)),
                        const SizedBox(width: 4),
                        Text(l.$1, style: Theme.of(context).textTheme.labelSmall),
                      ]))
                  .toList(),
            ),
          ],
        ],
      ),
    );
  }
}
