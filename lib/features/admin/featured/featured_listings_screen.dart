import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/app_states.dart';
import '../../../shared/mock_data/mock_properties.dart';

class FeaturedListingsScreen extends StatefulWidget {
  const FeaturedListingsScreen({super.key});

  @override
  State<FeaturedListingsScreen> createState() => _FeaturedListingsScreenState();
}

class _FeaturedListingsScreenState extends State<FeaturedListingsScreen> {
  late final Set<String> _featuredIds = MockProperties.all.where((p) => p.featured).map((p) => p.id).toSet();

  @override
  Widget build(BuildContext context) {
    final all = MockProperties.all;
    final featuredCount = _featuredIds.length;
    return Scaffold(
      appBar: AppBar(title: const Text('Featured Listings')),
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.all(AppSpacing.lg),
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(color: AppColors.accentLight, borderRadius: BorderRadius.circular(AppRadius.md)),
            child: Row(
              children: [
                const Icon(Icons.star_rounded, color: AppColors.accent),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Text(
                    '$featuredCount properties are currently featured on the Home screen.',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: all.isEmpty
                ? const EmptyState(icon: Icons.star_border_rounded, title: 'No Properties', message: 'Add properties to feature them here.')
                : ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                    itemCount: all.length,
                    separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.sm),
                    itemBuilder: (context, i) {
                      final p = all[i];
                      final featured = _featuredIds.contains(p.id);
                      return Container(
                        padding: const EdgeInsets.all(AppSpacing.sm),
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardTheme.color,
                          borderRadius: BorderRadius.circular(AppRadius.md),
                          border: Border.all(color: featured ? AppColors.accent : AppColors.lightBorder, width: featured ? 1.4 : 1),
                        ),
                        child: Row(
                          children: [
                            ClipRRect(borderRadius: BorderRadius.circular(10), child: CachedNetworkImage(imageUrl: p.images.first, height: 52, width: 52, fit: BoxFit.cover)),
                            const SizedBox(width: AppSpacing.sm),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(p.title, style: Theme.of(context).textTheme.titleSmall, maxLines: 1, overflow: TextOverflow.ellipsis),
                                  Text(p.priceLabel, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.accent)),
                                ],
                              ),
                            ),
                            Switch(
                              value: featured,
                              activeThumbColor: AppColors.accent,
                              onChanged: (v) => setState(() => v ? _featuredIds.add(p.id) : _featuredIds.remove(p.id)),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
