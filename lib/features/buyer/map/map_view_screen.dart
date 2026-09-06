import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/routing/route_paths.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/app_button.dart';
import '../../../shared/mock_data/mock_properties.dart';
import '../../../shared/models/property_model.dart';
import '../../../shared/widgets/property_card.dart';
import '../../../core/state/app_session.dart';

/// A stylized map surface (no external map SDK / API key required) that
/// plots property pins using normalized lat/lng so the flow is fully
/// navigable in this UI-only build.
class MapViewScreen extends StatefulWidget {
  const MapViewScreen({super.key});

  @override
  State<MapViewScreen> createState() => _MapViewScreenState();
}

class _MapViewScreenState extends State<MapViewScreen> {
  PropertyModel? _selected;

  Offset _positionFor(PropertyModel p, Size size) {
    final nx = ((p.lng - 55.05) / (55.30 - 55.05)).clamp(0.05, 0.95);
    final ny = 1 - ((p.lat - 25.0) / (25.22 - 25.0)).clamp(0.05, 0.95);
    return Offset(nx * size.width, ny * size.height);
  }

  @override
  Widget build(BuildContext context) {
    final properties = MockProperties.all;
    return Scaffold(
      appBar: AppBar(title: const Text('Map View')),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final size = Size(constraints.maxWidth, constraints.maxHeight);
          return Stack(
            children: [
              Container(color: AppColors.accentLight.withValues(alpha: 0.35)),
              CustomPaint(size: size, painter: _RoadPainter()),
              for (final p in properties)
                Builder(builder: (context) {
                  final pos = _positionFor(p, size);
                  final isSelected = _selected?.id == p.id;
                  return Positioned(
                    left: pos.dx - 22,
                    top: pos.dy - 44,
                    child: GestureDetector(
                      onTap: () => setState(() => _selected = p),
                      child: AnimatedScale(
                        scale: isSelected ? 1.15 : 1.0,
                        duration: const Duration(milliseconds: 150),
                        child: Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                              decoration: BoxDecoration(
                                color: isSelected ? AppColors.navy : Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.15), blurRadius: 8, offset: const Offset(0, 3))],
                              ),
                              child: Text(
                                p.priceLabel,
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w800,
                                  color: isSelected ? Colors.white : AppColors.navy,
                                ),
                              ),
                            ),
                            Icon(Icons.location_on_rounded,
                                color: isSelected ? AppColors.navy : AppColors.accent, size: 26),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
              Positioned(
                top: AppSpacing.md,
                right: AppSpacing.md,
                child: Column(
                  children: [
                    _mapButton(Icons.add_rounded),
                    const SizedBox(height: 8),
                    _mapButton(Icons.remove_rounded),
                    const SizedBox(height: 8),
                    _mapButton(Icons.my_location_rounded),
                  ],
                ),
              ),
              if (_selected != null)
                Positioned(
                  left: AppSpacing.lg,
                  right: AppSpacing.lg,
                  bottom: AppSpacing.lg,
                  child: AnimatedBuilder(
                    animation: AppSession.instance,
                    builder: (context, _) => PropertyCard(
                      property: _selected!,
                      isFavorite: AppSession.instance.isFavorite(_selected!.id),
                      onFavoriteToggle: () => AppSession.instance.toggleFavorite(_selected!.id),
                      onTap: () => context.push(RoutePaths.buyerPropertyDetails(_selected!.id)),
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  Widget _mapButton(IconData icon) {
    return GhostIconButton(icon: icon, background: Colors.white, size: 42);
  }
}

class _RoadPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 10
      ..style = PaintingStyle.stroke;
    final path = Path()
      ..moveTo(0, size.height * 0.25)
      ..cubicTo(size.width * 0.3, size.height * 0.1, size.width * 0.5, size.height * 0.5, size.width, size.height * 0.35);
    canvas.drawPath(path, paint);
    final path2 = Path()
      ..moveTo(size.width * 0.15, 0)
      ..cubicTo(size.width * 0.4, size.height * 0.4, size.width * 0.2, size.height * 0.7, size.width * 0.35, size.height);
    canvas.drawPath(path2, paint..strokeWidth = 7);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
