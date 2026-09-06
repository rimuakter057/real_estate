import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/widgets/status_badge.dart';
import '../models/property_model.dart';

/// Large horizontal-style property card used on Home, Explore, and
/// Favorites. Shows image, badge, favorite toggle, title, location,
/// price, quick facts, and a small agent strip.
class PropertyCard extends StatelessWidget {
  const PropertyCard({
    super.key,
    required this.property,
    required this.onTap,
    required this.isFavorite,
    required this.onFavoriteToggle,
    this.width,
  });

  final PropertyModel property;
  final VoidCallback onTap;
  final bool isFavorite;
  final VoidCallback onFavoriteToggle;
  final double? width;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        decoration: BoxDecoration(
          color: Theme.of(context).cardTheme.color,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          boxShadow: [
            BoxShadow(
              color: (isDark ? Colors.black : AppColors.navy).withValues(alpha: isDark ? 0.3 : 0.05),
              blurRadius: 20,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                AspectRatio(
                  aspectRatio: 16 / 11,
                  child: CachedNetworkImage(
                    imageUrl: property.images.first,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(color: AppColors.grey200),
                    errorWidget: (context, url, error) => Container(
                      color: AppColors.grey200,
                      child: const Icon(Icons.image_not_supported_outlined, color: AppColors.grey400),
                    ),
                  ),
                ),
                Positioned(
                  top: 12,
                  left: 12,
                  child: ListingBadge(
                    type: property.kind == ListingKind.sale ? ListingType.sale : ListingType.rent,
                  ),
                ),
                Positioned(
                  top: 10,
                  right: 10,
                  child: FavoriteButton(active: isFavorite, onTap: onFavoriteToggle, size: 34),
                ),
                Positioned(
                  bottom: 10,
                  left: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.45),
                      borderRadius: BorderRadius.circular(AppRadius.xs),
                    ),
                    child: RatingBadge(rating: property.rating),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.sm),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    property.title,
                    style: Theme.of(context).textTheme.titleMedium,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.location_on_outlined, size: 14, color: AppColors.grey400),
                      const SizedBox(width: 2),
                      Expanded(
                        child: Text(
                          property.location,
                          style: Theme.of(context).textTheme.bodySmall,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    property.priceLabel,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(color: AppColors.accent),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Row(
                    children: [
                      if (property.bedrooms > 0) ...[
                        _fact(context, Icons.bed_outlined, '${property.bedrooms}'),
                        const SizedBox(width: AppSpacing.sm),
                      ],
                      if (property.bathrooms > 0) ...[
                        _fact(context, Icons.bathtub_outlined, '${property.bathrooms}'),
                        const SizedBox(width: AppSpacing.sm),
                      ],
                      _fact(context, Icons.square_foot_rounded, '${property.areaSqft} sqft'),
                    ],
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: AppSpacing.sm),
                    child: Divider(height: 1),
                  ),
                  Row(
                    children: [
                      ClipOval(
                        child: CachedNetworkImage(
                          imageUrl: property.agent.avatarUrl,
                          height: 22,
                          width: 22,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          property.agent.name,
                          style: Theme.of(context).textTheme.labelMedium,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
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

  Widget _fact(BuildContext context, IconData icon, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 15, color: AppColors.grey500),
        const SizedBox(width: 3),
        Text(label, style: Theme.of(context).textTheme.labelMedium),
      ],
    );
  }
}
