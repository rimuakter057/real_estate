import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';

class Skeleton extends StatelessWidget {
  const Skeleton({super.key, this.width, this.height = 14, this.radius = 6});
  final double? width;
  final double height;
  final double radius;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Shimmer.fromColors(
      baseColor: isDark ? AppColors.darkSurfaceAlt : AppColors.grey200,
      highlightColor: isDark ? AppColors.darkBorder : AppColors.grey100,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(radius),
        ),
      ),
    );
  }
}

class PropertyCardSkeleton extends StatelessWidget {
  const PropertyCardSkeleton({super.key, this.width = 260});
  final double width;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Skeleton(width: width, height: 160, radius: AppRadius.lg),
          const SizedBox(height: AppSpacing.sm),
          Skeleton(width: width * 0.7, height: 16),
          const SizedBox(height: AppSpacing.xs),
          Skeleton(width: width * 0.5, height: 12),
          const SizedBox(height: AppSpacing.xs),
          Skeleton(width: width * 0.4, height: 14),
        ],
      ),
    );
  }
}

class ListTileSkeleton extends StatelessWidget {
  const ListTileSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      child: Row(
        children: [
          const Skeleton(width: 52, height: 52, radius: 26),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Skeleton(width: 140, height: 14),
                SizedBox(height: 8),
                Skeleton(width: 90, height: 12),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ProfileHeaderSkeleton extends StatelessWidget {
  const ProfileHeaderSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        Skeleton(width: 84, height: 84, radius: 42),
        SizedBox(height: AppSpacing.md),
        Skeleton(width: 160, height: 16),
        SizedBox(height: AppSpacing.xs),
        Skeleton(width: 120, height: 12),
      ],
    );
  }
}
