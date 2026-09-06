import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_chip.dart';
import '../../../core/widgets/app_dialogs.dart';
import '../../../shared/mock_data/mock_properties.dart';
import '../../../shared/models/property_model.dart';

class ApprovalDetailsScreen extends StatelessWidget {
  const ApprovalDetailsScreen({super.key, required this.propertyId});
  final String propertyId;

  @override
  Widget build(BuildContext context) {
    final property = MockProperties.byId(propertyId);
    return Scaffold(
      appBar: AppBar(title: const Text('Review Submission')),
      body: ListView(
        children: [
          SizedBox(
            height: 220,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              scrollDirection: Axis.horizontal,
              itemCount: property.images.length,
              separatorBuilder: (_, __) => const SizedBox(width: AppSpacing.sm),
              itemBuilder: (context, i) => ClipRRect(
                borderRadius: BorderRadius.circular(AppRadius.md),
                child: CachedNetworkImage(imageUrl: property.images[i], width: 280, fit: BoxFit.cover),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(property.title, style: Theme.of(context).textTheme.headlineLarge),
                const SizedBox(height: 4),
                Text('${property.location}, ${property.city}', style: Theme.of(context).textTheme.bodyMedium),
                const SizedBox(height: AppSpacing.sm),
                Text(property.priceLabel, style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: AppColors.accent)),
                const SizedBox(height: AppSpacing.lg),
                Container(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  decoration: BoxDecoration(color: AppColors.lightSurfaceAlt, borderRadius: BorderRadius.circular(AppRadius.md)),
                  child: Column(
                    children: [
                      _row(context, 'Owner / Agent', property.agent.name),
                      _row(context, 'Property Type', property.type.label),
                      _row(context, 'Listing Type', property.kind == ListingKind.sale ? 'For Sale' : 'For Rent'),
                      _row(context, 'Submitted On', DateFormat('MMM d, yyyy').format(property.postedDate ?? DateTime.now())),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.xl),
                Text('Property Details', style: Theme.of(context).textTheme.headlineSmall),
                const SizedBox(height: AppSpacing.sm),
                Wrap(spacing: AppSpacing.lg, runSpacing: AppSpacing.sm, children: [
                  _fact(context, Icons.bed_outlined, '${property.bedrooms} Beds'),
                  _fact(context, Icons.bathtub_outlined, '${property.bathrooms} Baths'),
                  _fact(context, Icons.square_foot_rounded, '${property.areaSqft} sqft'),
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
              Expanded(
                child: SecondaryButton(
                  label: 'Reject',
                  icon: Icons.cancel_outlined,
                  onPressed: () async {
                    final confirm = await AppDialogs.confirm(
                      context,
                      title: 'Reject Property',
                      message: '"${property.title}" will be rejected and the owner notified.',
                      confirmLabel: 'Reject',
                      destructive: true,
                    );
                    if (confirm && context.mounted) {
                      AppDialogs.success(context, 'Property rejected');
                      context.pop();
                    }
                  },
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: PrimaryButton(
                  label: 'Approve',
                  icon: Icons.check_circle_outline_rounded,
                  onPressed: () async {
                    final confirm = await AppDialogs.confirm(
                      context,
                      title: 'Approve Property',
                      message: '"${property.title}" will go live and be visible to all buyers.',
                      confirmLabel: 'Approve',
                    );
                    if (confirm && context.mounted) {
                      AppDialogs.success(context, 'Property approved and published');
                      context.pop();
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _row(BuildContext context, String label, String value) {
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

  Widget _fact(BuildContext context, IconData icon, String label) {
    return Row(mainAxisSize: MainAxisSize.min, children: [
      Icon(icon, size: 18, color: AppColors.grey500),
      const SizedBox(width: 6),
      Text(label, style: Theme.of(context).textTheme.bodyMedium),
    ]);
  }
}
