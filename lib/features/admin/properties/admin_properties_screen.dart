import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/routing/route_paths.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/app_chip.dart';
import '../../../core/widgets/app_states.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/status_badge.dart';
import '../../../shared/mock_data/mock_properties.dart';
import '../../../shared/models/property_model.dart';

class AdminPropertiesScreen extends StatefulWidget {
  const AdminPropertiesScreen({super.key});

  @override
  State<AdminPropertiesScreen> createState() => _AdminPropertiesScreenState();
}

class _AdminPropertiesScreenState extends State<AdminPropertiesScreen> {
  String _query = '';
  PropertyStatus? _status;

  @override
  Widget build(BuildContext context) {
    var properties = MockProperties.all;
    if (_status != null) properties = properties.where((p) => p.status == _status).toList();
    if (_query.isNotEmpty) {
      properties = properties.where((p) => p.title.toLowerCase().contains(_query.toLowerCase()) || p.location.toLowerCase().contains(_query.toLowerCase())).toList();
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Properties')),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppSearchField(hint: 'Search properties or location', onChanged: (v) => setState(() => _query = v)),
            const SizedBox(height: AppSpacing.md),
            SizedBox(
              height: 40,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  Padding(padding: const EdgeInsets.only(right: AppSpacing.sm), child: AppChip(label: 'All', selected: _status == null, onTap: () => setState(() => _status = null))),
                  for (final s in PropertyStatus.values)
                    Padding(
                      padding: const EdgeInsets.only(right: AppSpacing.sm),
                      child: AppChip(label: s.name[0].toUpperCase() + s.name.substring(1), selected: _status == s, onTap: () => setState(() => _status = s)),
                    ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Expanded(
              child: properties.isEmpty
                  ? const EmptyState(icon: Icons.apartment_outlined, title: 'No Properties Found', message: 'Try a different search term or filter.')
                  : ListView.separated(
                      itemCount: properties.length,
                      separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.sm),
                      itemBuilder: (context, i) => _tile(context, properties[i]),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _tile(BuildContext context, PropertyModel p) {
    return GestureDetector(
      onTap: () => context.push(RoutePaths.adminPropertyDetails(p.id)),
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.sm),
        decoration: BoxDecoration(
          color: Theme.of(context).cardTheme.color,
          borderRadius: BorderRadius.circular(AppRadius.md),
          border: Border.all(color: AppColors.lightBorder),
        ),
        child: Row(
          children: [
            ClipRRect(borderRadius: BorderRadius.circular(10), child: CachedNetworkImage(imageUrl: p.images.first, height: 60, width: 60, fit: BoxFit.cover)),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(p.title, style: Theme.of(context).textTheme.titleSmall, maxLines: 1, overflow: TextOverflow.ellipsis),
                  Text('${p.location}, ${p.city} • ${p.agent.name}', style: Theme.of(context).textTheme.bodySmall, maxLines: 1, overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 4),
                  Text(p.priceLabel, style: Theme.of(context).textTheme.titleSmall?.copyWith(color: AppColors.accent)),
                ],
              ),
            ),
            _statusFor(p.status),
          ],
        ),
      ),
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
}
