import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/routing/route_paths.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/app_dialogs.dart';
import '../../../core/widgets/app_states.dart';
import '../../../core/widgets/status_badge.dart';
import '../../../shared/mock_data/mock_agents.dart';
import '../../../shared/mock_data/mock_properties.dart';
import '../../../shared/models/property_model.dart';

class MyPropertiesScreen extends StatefulWidget {
  const MyPropertiesScreen({super.key});

  @override
  State<MyPropertiesScreen> createState() => _MyPropertiesScreenState();
}

class _MyPropertiesScreenState extends State<MyPropertiesScreen> with SingleTickerProviderStateMixin {
  late final _tabController = TabController(length: 4, vsync: this);

  @override
  Widget build(BuildContext context) {
    final mine = MockProperties.byAgent(MockAgents.me.id);
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Properties'),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          labelColor: AppColors.accent,
          unselectedLabelColor: AppColors.grey500,
          indicatorColor: AppColors.accent,
          tabs: const [Tab(text: 'Active'), Tab(text: 'Pending'), Tab(text: 'Draft'), Tab(text: 'Sold/Rented')],
        ),
        actions: [
          IconButton(icon: const Icon(Icons.add_rounded), onPressed: () => context.push(RoutePaths.ownerAddProperty)),
        ],
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _list(mine.where((p) => p.status == PropertyStatus.active).toList()),
          _list(mine.where((p) => p.status == PropertyStatus.pending).toList()),
          _list(mine.where((p) => p.status == PropertyStatus.draft).toList()),
          _list(mine.where((p) => p.status == PropertyStatus.sold).toList()),
        ],
      ),
    );
  }

  Widget _list(List<PropertyModel> properties) {
    if (properties.isEmpty) {
      return EmptyState(
        icon: Icons.apartment_outlined,
        title: 'No Properties Here',
        message: 'Properties in this category will show up here once added.',
        actionLabel: 'Add Property',
        onAction: () => context.push(RoutePaths.ownerAddProperty),
      );
    }
    return ListView.separated(
      padding: const EdgeInsets.all(AppSpacing.lg),
      itemCount: properties.length,
      separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.md),
      itemBuilder: (context, i) {
        final p = properties[i];
        return GestureDetector(
          onTap: () => context.push(RoutePaths.ownerPropertyPreview(p.id)),
          child: Container(
            padding: const EdgeInsets.all(AppSpacing.sm),
            decoration: BoxDecoration(
              color: Theme.of(context).cardTheme.color,
              borderRadius: BorderRadius.circular(AppRadius.md),
              border: Border.all(color: AppColors.lightBorder),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: CachedNetworkImage(imageUrl: p.images.first, height: 76, width: 76, fit: BoxFit.cover),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(child: Text(p.title, style: Theme.of(context).textTheme.titleMedium, maxLines: 1, overflow: TextOverflow.ellipsis)),
                              PopupMenuButton<String>(
                                icon: const Icon(Icons.more_vert_rounded, color: AppColors.grey500),
                                onSelected: (value) => _handleMenu(context, value, p),
                                itemBuilder: (context) => const [
                                  PopupMenuItem(value: 'edit', child: Text('Edit')),
                                  PopupMenuItem(value: 'duplicate', child: Text('Duplicate')),
                                  PopupMenuItem(value: 'sold', child: Text('Mark as Sold/Rented')),
                                  PopupMenuItem(value: 'delete', child: Text('Delete', style: TextStyle(color: AppColors.error))),
                                ],
                              ),
                            ],
                          ),
                          Text('${p.location}, ${p.city}', style: Theme.of(context).textTheme.bodySmall, maxLines: 1, overflow: TextOverflow.ellipsis),
                          const SizedBox(height: 4),
                          Text(p.priceLabel, style: Theme.of(context).textTheme.titleMedium?.copyWith(color: AppColors.accent)),
                        ],
                      ),
                    ),
                  ],
                ),
                const Padding(padding: EdgeInsets.symmetric(vertical: AppSpacing.sm), child: Divider(height: 1)),
                Row(
                  children: [
                    _statusFor(p.status),
                    const Spacer(),
                    const Icon(Icons.visibility_outlined, size: 14, color: AppColors.grey500),
                    const SizedBox(width: 3),
                    Text('${p.views}', style: Theme.of(context).textTheme.labelMedium),
                    const SizedBox(width: AppSpacing.sm),
                    const Icon(Icons.favorite_border_rounded, size: 14, color: AppColors.grey500),
                    const SizedBox(width: 3),
                    Text('${p.interested}', style: Theme.of(context).textTheme.labelMedium),
                    const SizedBox(width: AppSpacing.sm),
                    TextButton(
                      onPressed: () => context.push(RoutePaths.ownerPropertyEdit(p.id)),
                      style: TextButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 10)),
                      child: const Text('Edit'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _statusFor(PropertyStatus status) {
    final mapped = switch (status) {
      PropertyStatus.active => AppStatus.active,
      PropertyStatus.pending => AppStatus.pending,
      PropertyStatus.draft => AppStatus.draft,
      PropertyStatus.sold => AppStatus.sold,
    };
    return StatusChip(status: mapped);
  }

  void _handleMenu(BuildContext context, String value, PropertyModel p) async {
    switch (value) {
      case 'edit':
        context.push(RoutePaths.ownerPropertyEdit(p.id));
      case 'duplicate':
        AppDialogs.success(context, 'Property duplicated as a draft.');
      case 'sold':
        final confirm = await AppDialogs.confirm(
          context,
          title: 'Mark as Sold/Rented',
          message: 'This will remove "${p.title}" from active search results.',
          confirmLabel: 'Confirm',
        );
        if (confirm && context.mounted) AppDialogs.success(context, 'Property marked as Sold/Rented.');
      case 'delete':
        final confirm = await AppDialogs.confirm(
          context,
          title: 'Delete Property',
          message: 'Are you sure you want to permanently delete "${p.title}"? This cannot be undone.',
          confirmLabel: 'Delete',
          destructive: true,
          icon: Icons.delete_outline_rounded,
        );
        if (confirm && context.mounted) AppDialogs.success(context, 'Property deleted.');
    }
  }
}
