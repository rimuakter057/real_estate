import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/routing/route_paths.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_chip.dart';
import '../../../core/widgets/status_badge.dart';
import '../../../shared/mock_data/mock_properties.dart';
import '../../../shared/models/property_model.dart';

class PropertyPreviewScreen extends StatelessWidget {
  const PropertyPreviewScreen({super.key, required this.propertyId});
  final String propertyId;

  @override
  Widget build(BuildContext context) {
    final property = MockProperties.byId(propertyId);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Property Preview'),
        actions: [
          IconButton(icon: const Icon(Icons.edit_outlined), onPressed: () => context.push(RoutePaths.ownerPropertyEdit(property.id))),
          const SizedBox(width: AppSpacing.sm),
        ],
      ),
      body: ListView(
        children: [
          AspectRatio(
            aspectRatio: 16 / 10,
            child: PageView(
              children: property.images.map((img) => CachedNetworkImage(imageUrl: img, fit: BoxFit.cover)).toList(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    ListingBadge(type: property.kind == ListingKind.sale ? ListingType.sale : ListingType.rent),
                    const SizedBox(width: 8),
                    StatusChip(
                      status: switch (property.status) {
                        PropertyStatus.active => AppStatus.active,
                        PropertyStatus.pending => AppStatus.pending,
                        PropertyStatus.draft => AppStatus.draft,
                        PropertyStatus.sold => AppStatus.sold,
                      },
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(property.title, style: Theme.of(context).textTheme.headlineLarge),
                const SizedBox(height: 4),
                Text('${property.location}, ${property.city}', style: Theme.of(context).textTheme.bodyMedium),
                const SizedBox(height: AppSpacing.sm),
                Text(property.priceLabel, style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: AppColors.accent)),
                const SizedBox(height: AppSpacing.lg),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                  decoration: BoxDecoration(color: AppColors.lightSurfaceAlt, borderRadius: BorderRadius.circular(AppRadius.md)),
                  child: Row(
                    children: [
                      Expanded(child: _stat(context, '${property.views}', 'Views', Icons.visibility_outlined)),
                      Expanded(child: _stat(context, '${property.interested}', 'Interested', Icons.favorite_border_rounded)),
                      Expanded(child: _stat(context, property.rating.toStringAsFixed(1), 'Rating', Icons.star_rounded)),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.xl),
                Text('Details', style: Theme.of(context).textTheme.headlineSmall),
                const SizedBox(height: AppSpacing.sm),
                Wrap(spacing: AppSpacing.lg, runSpacing: AppSpacing.sm, children: [
                  _fact(context, Icons.bed_outlined, '${property.bedrooms} Beds'),
                  _fact(context, Icons.bathtub_outlined, '${property.bathrooms} Baths'),
                  _fact(context, Icons.square_foot_rounded, '${property.areaSqft} sqft'),
                  _fact(context, Icons.category_outlined, property.type.label),
                ]),
                const SizedBox(height: AppSpacing.xl),
                Text('Description', style: Theme.of(context).textTheme.headlineSmall),
                const SizedBox(height: AppSpacing.sm),
                Text(property.description, style: Theme.of(context).textTheme.bodyMedium),
                const SizedBox(height: AppSpacing.xl),
                Text('Amenities', style: Theme.of(context).textTheme.headlineSmall),
                const SizedBox(height: AppSpacing.sm),
                Wrap(spacing: AppSpacing.sm, runSpacing: AppSpacing.sm, children: property.amenities.map((a) => AppChip(label: a)).toList()),
                const SizedBox(height: AppSpacing.xxl),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.sm, AppSpacing.lg, AppSpacing.sm),
          child: Row(
            children: [
              Expanded(child: SecondaryButton(label: 'View Leads', icon: Icons.groups_outlined, onPressed: () => context.go(RoutePaths.ownerLeads))),
              const SizedBox(width: AppSpacing.sm),
              Expanded(child: PrimaryButton(label: 'Edit Property', icon: Icons.edit_outlined, onPressed: () => context.push(RoutePaths.ownerPropertyEdit(property.id)))),
            ],
          ),
        ),
      ),
    );
  }

  Widget _stat(BuildContext context, String value, String label, IconData icon) {
    return Column(children: [
      Icon(icon, color: AppColors.accent, size: 20),
      const SizedBox(height: 4),
      Text(value, style: Theme.of(context).textTheme.titleMedium),
      Text(label, style: Theme.of(context).textTheme.bodySmall),
    ]);
  }

  Widget _fact(BuildContext context, IconData icon, String label) {
    return Row(mainAxisSize: MainAxisSize.min, children: [
      Icon(icon, size: 18, color: AppColors.grey500),
      const SizedBox(width: 6),
      Text(label, style: Theme.of(context).textTheme.bodyMedium),
    ]);
  }
}
