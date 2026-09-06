import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/routing/route_paths.dart';
import '../../../core/state/app_session.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_chip.dart';
import '../../../core/widgets/status_badge.dart';
import '../../../shared/mock_data/mock_properties.dart';
import '../../../shared/models/property_model.dart';

const _amenityIcons = {
  'Parking': Icons.local_parking_rounded,
  'Balcony': Icons.balcony_rounded,
  'Security': Icons.security_rounded,
  'Lift': Icons.elevator_rounded,
  'Gym': Icons.fitness_center_rounded,
  'Swimming Pool': Icons.pool_rounded,
  'Generator': Icons.electrical_services_rounded,
  'Garden': Icons.park_rounded,
};

class PropertyDetailsScreen extends StatefulWidget {
  const PropertyDetailsScreen({super.key, required this.propertyId});
  final String propertyId;

  @override
  State<PropertyDetailsScreen> createState() => _PropertyDetailsScreenState();
}

class _PropertyDetailsScreenState extends State<PropertyDetailsScreen> {
  final _pageController = PageController();
  int _page = 0;

  @override
  Widget build(BuildContext context) {
    final property = MockProperties.byId(widget.propertyId);
    return Scaffold(
      body: AnimatedBuilder(
        animation: AppSession.instance,
        builder: (context, _) {
          return CustomScrollView(
            slivers: [
              SliverToBoxAdapter(child: _gallery(context, property)),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(children: [
                                  ListingBadge(type: property.kind == ListingKind.sale ? ListingType.sale : ListingType.rent),
                                  const SizedBox(width: 8),
                                  RatingBadge(rating: property.rating),
                                ]),
                                const SizedBox(height: AppSpacing.sm),
                                Text(property.title, style: Theme.of(context).textTheme.headlineLarge),
                              ],
                            ),
                          ),
                          Text(property.priceLabel,
                              style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: AppColors.accent)),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Row(
                        children: [
                          const Icon(Icons.location_on_outlined, size: 16, color: AppColors.grey500),
                          const SizedBox(width: 4),
                          Expanded(child: Text('${property.location}, ${property.city}', style: Theme.of(context).textTheme.bodyMedium)),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                        decoration: BoxDecoration(
                          color: Theme.of(context).brightness == Brightness.dark
                              ? AppColors.darkSurfaceAlt
                              : AppColors.lightSurfaceAlt,
                          borderRadius: BorderRadius.circular(AppRadius.md),
                        ),
                        child: Row(
                          children: [
                            if (property.bedrooms > 0)
                              Expanded(child: _stat(context, Icons.bed_outlined, '${property.bedrooms}', 'Beds')),
                            if (property.bathrooms > 0)
                              Expanded(child: _stat(context, Icons.bathtub_outlined, '${property.bathrooms}', 'Baths')),
                            Expanded(child: _stat(context, Icons.square_foot_rounded, '${property.areaSqft}', 'Sqft')),
                            Expanded(child: _stat(context, Icons.calendar_today_outlined, property.propertyAge, 'Age')),
                          ],
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xl),
                      Text('Description', style: Theme.of(context).textTheme.headlineSmall),
                      const SizedBox(height: AppSpacing.sm),
                      Text(property.description, style: Theme.of(context).textTheme.bodyMedium),
                      const SizedBox(height: AppSpacing.xl),
                      Text('Amenities', style: Theme.of(context).textTheme.headlineSmall),
                      const SizedBox(height: AppSpacing.sm),
                      Wrap(
                        spacing: AppSpacing.sm,
                        runSpacing: AppSpacing.sm,
                        children: property.amenities
                            .map((a) => AppChip(label: a, icon: _amenityIcons[a] ?? Icons.check_circle_outline_rounded))
                            .toList(),
                      ),
                      const SizedBox(height: AppSpacing.xl),
                      Text('Property Features', style: Theme.of(context).textTheme.headlineSmall),
                      const SizedBox(height: AppSpacing.sm),
                      _featureRow('Property Type', property.type.label),
                      _featureRow('Furnishing', property.furnished),
                      if (property.floor != null) _featureRow('Floor', property.floor!),
                      _featureRow('Property Age', property.propertyAge),
                      const SizedBox(height: AppSpacing.xl),
                      Text('Location', style: Theme.of(context).textTheme.headlineSmall),
                      const SizedBox(height: AppSpacing.sm),
                      GestureDetector(
                        onTap: () => context.push(RoutePaths.buyerMap, extra: property),
                        child: Container(
                          height: 150,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(AppRadius.md),
                            color: AppColors.accentLight,
                          ),
                          clipBehavior: Clip.antiAlias,
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              CustomPaint(painter: _MapGridPainter()),
                              const Center(child: Icon(Icons.location_on_rounded, color: AppColors.accent, size: 42)),
                              Positioned(
                                right: 10,
                                bottom: 10,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
                                  child: const Text('Open Map', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12)),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xl),
                      Text('Listed By', style: Theme.of(context).textTheme.headlineSmall),
                      const SizedBox(height: AppSpacing.sm),
                      GestureDetector(
                        onTap: () => context.push(RoutePaths.buyerAgentProfile(property.agent.id)),
                        child: Container(
                          padding: const EdgeInsets.all(AppSpacing.md),
                          decoration: BoxDecoration(
                            border: Border.all(color: AppColors.lightBorder),
                            borderRadius: BorderRadius.circular(AppRadius.md),
                          ),
                          child: Row(
                            children: [
                              ClipOval(
                                child: CachedNetworkImage(imageUrl: property.agent.avatarUrl, height: 48, width: 48, fit: BoxFit.cover),
                              ),
                              const SizedBox(width: AppSpacing.sm),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(property.agent.name, style: Theme.of(context).textTheme.titleMedium),
                                    Text(property.agent.title, style: Theme.of(context).textTheme.bodySmall),
                                  ],
                                ),
                              ),
                              const Icon(Icons.chevron_right_rounded, color: AppColors.grey400),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 100),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.sm, AppSpacing.lg, AppSpacing.sm),
          child: Row(
            children: [
              GhostIconButton(icon: Icons.call_outlined, size: 52, onPressed: () => _showCallSheet(context, property)),
              const SizedBox(width: AppSpacing.sm),
              GhostIconButton(icon: Icons.chat_bubble_outline_rounded, size: 52, onPressed: () => context.push(RoutePaths.buyerChatDetail('c1'))),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: PrimaryButton(
                  label: 'Schedule Visit',
                  icon: Icons.calendar_month_outlined,
                  onPressed: () => context.push(RoutePaths.buyerScheduleVisit(property.id)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _gallery(BuildContext context, PropertyModel property) {
    return Stack(
      children: [
        AspectRatio(
          aspectRatio: 4 / 3.2,
          child: GestureDetector(
            onTap: () => context.push(RoutePaths.buyerPropertyGallery(property.id)),
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: (i) => setState(() => _page = i),
              itemCount: property.images.length,
              itemBuilder: (context, i) => CachedNetworkImage(imageUrl: property.images[i], fit: BoxFit.cover),
            ),
          ),
        ),
        Positioned(
          top: 48,
          left: AppSpacing.lg,
          child: GhostIconButton(icon: Icons.arrow_back_rounded, onPressed: () => context.pop()),
        ),
        Positioned(
          top: 48,
          right: AppSpacing.lg,
          child: FavoriteButton(
            active: AppSession.instance.isFavorite(property.id),
            onTap: () => AppSession.instance.toggleFavorite(property.id),
          ),
        ),
        Positioned(
          bottom: 14,
          left: 0,
          right: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              property.images.length,
              (i) => AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: const EdgeInsets.symmetric(horizontal: 3),
                height: 6,
                width: i == _page ? 18 : 6,
                decoration: BoxDecoration(
                  color: i == _page ? Colors.white : Colors.white.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 14,
          right: AppSpacing.lg,
          child: GestureDetector(
            onTap: () => context.push(RoutePaths.buyerPropertyGallery(property.id)),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(color: Colors.black.withValues(alpha: 0.5), borderRadius: BorderRadius.circular(8)),
              child: Row(mainAxisSize: MainAxisSize.min, children: [
                const Icon(Icons.photo_library_outlined, color: Colors.white, size: 14),
                const SizedBox(width: 4),
                Text('${property.images.length} photos', style: const TextStyle(color: Colors.white, fontSize: 12)),
              ]),
            ),
          ),
        ),
      ],
    );
  }

  Widget _stat(BuildContext context, IconData icon, String value, String label) {
    return Column(
      children: [
        Icon(icon, color: AppColors.accent, size: 20),
        const SizedBox(height: 4),
        Text(value, style: Theme.of(context).textTheme.titleMedium),
        Text(label, style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }

  Widget _featureRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(child: Text(label, style: Theme.of(context).textTheme.bodyMedium)),
          Text(value, style: Theme.of(context).textTheme.titleSmall),
        ],
      ),
    );
  }

  void _showCallSheet(BuildContext context, PropertyModel property) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.lg)),
        title: const Text('Call Agent'),
        content: Text('Call ${property.agent.name} at ${property.agent.phone}?'),
        actions: [
          TextButton(onPressed: () => context.pop(), child: const Text('Cancel')),
          FilledButton(onPressed: () => context.pop(), child: const Text('Call')),
        ],
      ),
    );
  }
}

class _MapGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.accent.withValues(alpha: 0.15)
      ..strokeWidth = 1;
    for (double x = 0; x < size.width; x += 24) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y < size.height; y += 24) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
