import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/routing/route_paths.dart';
import '../../../core/state/app_session.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/app_chip.dart';
import '../../../core/widgets/app_states.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/skeletons.dart';
import '../../../shared/mock_data/mock_categories.dart';
import '../../../shared/mock_data/mock_properties.dart';
import '../../../shared/models/property_model.dart';
import '../../../shared/widgets/property_card.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  final _searchController = TextEditingController();
  String? _selectedCategory;
  bool _loading = false;
  String _query = '';

  List<PropertyModel> get _results {
    var list = MockProperties.all;
    if (_selectedCategory != null) {
      list = list.where((p) => p.type.label == _selectedCategory).toList();
    }
    if (_query.isNotEmpty) {
      list = list
          .where((p) =>
              p.title.toLowerCase().contains(_query.toLowerCase()) ||
              p.location.toLowerCase().contains(_query.toLowerCase()))
          .toList();
    }
    return list;
  }

  void _search(String value) {
    setState(() {
      _query = value;
      _loading = true;
    });
    Future.delayed(const Duration(milliseconds: 400), () {
      if (mounted) setState(() => _loading = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    final results = _results;
    return Scaffold(
      appBar: AppBar(title: const Text('Explore')),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              child: AppSearchField(
                controller: _searchController,
                hint: 'Search properties, locations...',
                onChanged: _search,
                onFilterTap: () => context.push(RoutePaths.buyerFilter),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            SizedBox(
              height: 42,
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                scrollDirection: Axis.horizontal,
                itemCount: MockCategories.all.length + 1,
                separatorBuilder: (_, __) => const SizedBox(width: AppSpacing.sm),
                itemBuilder: (context, i) {
                  if (i == 0) {
                    return AppChip(
                      label: 'All',
                      selected: _selectedCategory == null,
                      onTap: () => setState(() => _selectedCategory = null),
                    );
                  }
                  final cat = MockCategories.all[i - 1];
                  return AppChip(
                    label: cat.name,
                    icon: cat.icon,
                    selected: _selectedCategory == cat.name,
                    onTap: () => setState(() => _selectedCategory = cat.name),
                  );
                },
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              child: Row(
                children: [
                  Text('${results.length} properties found', style: Theme.of(context).textTheme.bodyMedium),
                  const Spacer(),
                  GestureDetector(
                    onTap: () => context.push(RoutePaths.buyerMap),
                    child: Row(
                      children: const [
                        Icon(Icons.map_outlined, size: 18, color: AppColors.accent),
                        SizedBox(width: 4),
                        Text('Map View', style: TextStyle(color: AppColors.accent, fontWeight: FontWeight.w600)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Expanded(
              child: _loading
                  ? ListView(
                      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                      children: const [
                        PropertyCardSkeleton(width: double.infinity),
                        SizedBox(height: AppSpacing.md),
                        PropertyCardSkeleton(width: double.infinity),
                      ],
                    )
                  : results.isEmpty
                      ? EmptyState(
                          icon: Icons.search_off_rounded,
                          title: 'No properties found',
                          message: 'Try adjusting your search or filters to find more results.',
                          actionLabel: 'Reset Filters',
                          onAction: () => setState(() {
                            _selectedCategory = null;
                            _query = '';
                            _searchController.clear();
                          }),
                        )
                      : ListView.separated(
                          padding: const EdgeInsets.fromLTRB(AppSpacing.lg, 0, AppSpacing.lg, AppSpacing.xxl),
                          itemCount: results.length,
                          separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.md),
                          itemBuilder: (context, i) {
                            final p = results[i];
                            return AnimatedBuilder(
                              animation: AppSession.instance,
                              builder: (context, _) => PropertyCard(
                                property: p,
                                width: double.infinity,
                                isFavorite: AppSession.instance.isFavorite(p.id),
                                onFavoriteToggle: () => AppSession.instance.toggleFavorite(p.id),
                                onTap: () => context.push(RoutePaths.buyerPropertyDetails(p.id)),
                              ),
                            );
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }
}
