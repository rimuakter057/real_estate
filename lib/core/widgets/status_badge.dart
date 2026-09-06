import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';

enum ListingType { sale, rent }

class ListingBadge extends StatelessWidget {
  const ListingBadge({super.key, required this.type});
  final ListingType type;

  @override
  Widget build(BuildContext context) {
    final isSale = type == ListingType.sale;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: isSale ? AppColors.forSale : AppColors.forRent,
        borderRadius: BorderRadius.circular(AppRadius.xs),
      ),
      child: Text(
        isSale ? 'For Sale' : 'For Rent',
        style: const TextStyle(
          color: Colors.white,
          fontSize: 11,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.2,
        ),
      ),
    );
  }
}

enum AppStatus { active, pending, draft, sold, rejected, completed, cancelled, confirmed, verified }

class StatusChip extends StatelessWidget {
  const StatusChip({super.key, required this.status, this.label});
  final AppStatus status;
  final String? label;

  Color get _color => switch (status) {
        AppStatus.active || AppStatus.confirmed || AppStatus.completed || AppStatus.verified =>
          AppColors.success,
        AppStatus.pending => AppColors.warning,
        AppStatus.draft => AppColors.grey500,
        AppStatus.sold => AppColors.info,
        AppStatus.rejected || AppStatus.cancelled => AppColors.error,
      };

  String get _label => label ?? switch (status) {
        AppStatus.active => 'Active',
        AppStatus.pending => 'Pending',
        AppStatus.draft => 'Draft',
        AppStatus.sold => 'Sold / Rented',
        AppStatus.rejected => 'Rejected',
        AppStatus.completed => 'Completed',
        AppStatus.cancelled => 'Cancelled',
        AppStatus.confirmed => 'Confirmed',
        AppStatus.verified => 'Verified',
      };

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: 5),
      decoration: BoxDecoration(
        color: _color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(AppRadius.xs),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 6,
            width: 6,
            margin: const EdgeInsets.only(right: 6),
            decoration: BoxDecoration(color: _color, shape: BoxShape.circle),
          ),
          Text(
            _label,
            style: TextStyle(color: _color, fontSize: 11.5, fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}

class RatingBadge extends StatelessWidget {
  const RatingBadge({super.key, required this.rating, this.dense = false});
  final double rating;
  final bool dense;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(Icons.star_rounded, color: AppColors.goldStar, size: 16),
        const SizedBox(width: 2),
        Text(
          rating.toStringAsFixed(1),
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurface,
              ),
        ),
      ],
    );
  }
}

class FavoriteButton extends StatelessWidget {
  const FavoriteButton({super.key, required this.active, required this.onTap, this.size = 36});
  final bool active;
  final VoidCallback onTap;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: SizedBox(
          height: size,
          width: size,
          child: Icon(
            active ? Icons.favorite_rounded : Icons.favorite_border_rounded,
            size: size * 0.5,
            color: active ? AppColors.error : AppColors.navy,
          ),
        ),
      ),
    );
  }
}
