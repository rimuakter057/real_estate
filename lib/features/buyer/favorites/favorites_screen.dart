import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/routing/route_paths.dart';
import '../../../core/state/app_session.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/app_states.dart';
import '../../../shared/mock_data/mock_properties.dart';
import '../../../shared/widgets/property_card.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Favorites')),
      body: AnimatedBuilder(
        animation: AppSession.instance,
        builder: (context, _) {
          final favorites = MockProperties.all.where((p) => AppSession.instance.isFavorite(p.id)).toList();
          if (favorites.isEmpty) {
            return EmptyState(
              icon: Icons.favorite_border_rounded,
              title: 'No Favorites Yet',
              message: 'Tap the heart icon on any property to save it here for quick access.',
              actionLabel: 'Explore Properties',
              onAction: () => context.go(RoutePaths.buyerExplore),
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.all(AppSpacing.lg),
            itemCount: favorites.length,
            separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.md),
            itemBuilder: (context, i) {
              final p = favorites[i];
              return PropertyCard(
                property: p,
                width: double.infinity,
                isFavorite: true,
                onFavoriteToggle: () => AppSession.instance.toggleFavorite(p.id),
                onTap: () => context.push(RoutePaths.buyerPropertyDetails(p.id)),
              );
            },
          );
        },
      ),
    );
  }
}
