import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/routing/route_paths.dart';
import '../../../core/state/app_session.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_chip.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/section_header.dart';
import '../../../core/widgets/skeletons.dart';
import '../../../shared/mock_data/mock_properties.dart';
import '../../../shared/mock_data/mock_users.dart';
import '../../../shared/models/property_model.dart';
import '../../../shared/widgets/property_card.dart';

class BuyerHomeScreen extends StatefulWidget {
  const BuyerHomeScreen({super.key});

  @override
  State<BuyerHomeScreen> createState() => _BuyerHomeScreenState();
}

class _BuyerHomeScreenState extends State<BuyerHomeScreen> {
  bool _isBuy = true;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 900), () {
      if (mounted) setState(() => _loading = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = MockUsers.buyer;
    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          color: AppColors.accent,
          onRefresh: () async {
            setState(() => _loading = true);
            await Future.delayed(const Duration(milliseconds: 900));
            if (mounted) setState(() => _loading = false);
          },
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg).copyWith(bottom: AppSpacing.xxl),
            children: [
              const SizedBox(height: AppSpacing.sm),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: const [
                            Icon(Icons.location_on_rounded, size: 16, color: AppColors.accent),
                            SizedBox(width: 4),
                            Text('Dubai, UAE', style: TextStyle(fontWeight: FontWeight.w700)),
                            Icon(Icons.keyboard_arrow_down_rounded, size: 18, color: AppColors.grey500),
                          ],
                        ),
                        const SizedBox(height: 2),
                        Text('Good morning, ${user.name.split(' ').first} 👋',
                            style: Theme.of(context).textTheme.headlineSmall),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () => context.push(RoutePaths.buyerNotifications),
                    child: GhostIconButton(
                      icon: Icons.notifications_none_rounded,
                      badge: true,
                      onPressed: () => context.push(RoutePaths.buyerNotifications),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.lg),
              AppSearchField(
                hint: 'Search by city, project or community',
                readOnly: true,
                onTap: () => context.push(RoutePaths.buyerExplore),
                onFilterTap: () => context.push(RoutePaths.buyerFilter),
              ),
              const SizedBox(height: AppSpacing.md),
              BuyRentToggle(isBuy: _isBuy, onChanged: (v) => setState(() => _isBuy = v)),
              const SizedBox(height: AppSpacing.xl),
              SectionHeader(
                title: 'Featured Properties',
                actionLabel: 'See all',
                onAction: () => context.push(RoutePaths.buyerExplore),
              ),
              const SizedBox(height: AppSpacing.md),
              SizedBox(
                height: 360,
                child: _loading
                    ? ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: 3,
                        separatorBuilder: (_, __) => const SizedBox(width: AppSpacing.md),
                        itemBuilder: (context, i) => const PropertyCardSkeleton(),
                      )
                    : ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: MockProperties.featured.length,
                        separatorBuilder: (_, __) => const SizedBox(width: AppSpacing.md),
                        itemBuilder: (context, i) => SizedBox(
                          width: 260,
                          child: _card(MockProperties.featured[i]),
                        ),
                      ),
              ),
              const SizedBox(height: AppSpacing.xl),
              SectionHeader(
                title: 'Popular Locations',
                subtitle: 'Most searched areas this week',
              ),
              const SizedBox(height: AppSpacing.md),
              SizedBox(
                height: 42,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: MockProperties.popularLocations.length,
                  separatorBuilder: (_, __) => const SizedBox(width: AppSpacing.sm),
                  itemBuilder: (context, i) => AppChip(
                    label: MockProperties.popularLocations[i],
                    icon: Icons.location_on_outlined,
                    onTap: () => context.push(RoutePaths.buyerExplore),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              SectionHeader(
                title: 'Recommended for You',
                actionLabel: 'See all',
                onAction: () => context.push(RoutePaths.buyerExplore),
              ),
              const SizedBox(height: AppSpacing.md),
              _loading
                  ? const PropertyCardSkeleton(width: double.infinity)
                  : _verticalList(MockProperties.recommended.take(2).toList()),
              const SizedBox(height: AppSpacing.xl),
              SectionHeader(
                title: 'Nearby Properties',
                subtitle: 'Within 5 km of your location',
                actionLabel: 'View map',
                onAction: () => context.push(RoutePaths.buyerMap),
              ),
              const SizedBox(height: AppSpacing.md),
              SizedBox(
                height: 360,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: MockProperties.nearby.length,
                  separatorBuilder: (_, __) => const SizedBox(width: AppSpacing.md),
                  itemBuilder: (context, i) => SizedBox(width: 260, child: _card(MockProperties.nearby[i])),
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              SectionHeader(title: 'Recently Added', actionLabel: 'See all', onAction: () => context.push(RoutePaths.buyerExplore)),
              const SizedBox(height: AppSpacing.md),
              _verticalList(MockProperties.recentlyAdded.take(3).toList()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _verticalList(List<PropertyModel> items) {
    return Column(
      children: [
        for (final p in items) ...[
          _card(p, width: double.infinity),
          const SizedBox(height: AppSpacing.md),
        ],
      ],
    );
  }

  Widget _card(PropertyModel property, {double? width}) {
    return AnimatedBuilder(
      animation: AppSession.instance,
      builder: (context, _) => PropertyCard(
        property: property,
        width: width,
        isFavorite: AppSession.instance.isFavorite(property.id),
        onFavoriteToggle: () => AppSession.instance.toggleFavorite(property.id),
        onTap: () => context.push(RoutePaths.buyerPropertyDetails(property.id)),
      ),
    );
  }
}
