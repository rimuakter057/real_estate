import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_chip.dart';
import '../../../shared/mock_data/mock_categories.dart';
import '../../../shared/mock_data/mock_properties.dart';

class AdvancedFilterScreen extends StatefulWidget {
  const AdvancedFilterScreen({super.key});

  @override
  State<AdvancedFilterScreen> createState() => _AdvancedFilterScreenState();
}

class _AdvancedFilterScreenState extends State<AdvancedFilterScreen> {
  bool _isBuy = true;
  String? _type;
  RangeValues _price = const RangeValues(50000, 1500000);
  String? _location;
  int _bedrooms = 0;
  int _bathrooms = 0;
  RangeValues _area = const RangeValues(500, 8000);
  String _furnished = 'Any';
  final Set<String> _amenities = {};

  static const amenityOptions = [
    'Parking', 'Balcony', 'Security', 'Lift', 'Gym', 'Swimming Pool', 'Generator', 'Garden',
  ];

  void _reset() {
    setState(() {
      _isBuy = true;
      _type = null;
      _price = const RangeValues(50000, 1500000);
      _location = null;
      _bedrooms = 0;
      _bathrooms = 0;
      _area = const RangeValues(500, 8000);
      _furnished = 'Any';
      _amenities.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Advanced Filter'),
        actions: [
          TextButton(onPressed: _reset, child: const Text('Reset')),
          const SizedBox(width: AppSpacing.sm),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          children: [
            _label('Listing Type'),
            BuyRentToggle(isBuy: _isBuy, onChanged: (v) => setState(() => _isBuy = v)),
            const SizedBox(height: AppSpacing.xl),
            _label('Property Type'),
            Wrap(
              spacing: AppSpacing.sm,
              runSpacing: AppSpacing.sm,
              children: MockCategories.all
                  .map((c) => AppChip(
                        label: c.name,
                        icon: c.icon,
                        selected: _type == c.name,
                        onTap: () => setState(() => _type = _type == c.name ? null : c.name),
                      ))
                  .toList(),
            ),
            const SizedBox(height: AppSpacing.xl),
            _label('Price Range', trailing: '\$${_price.start.toInt()} - \$${_price.end.toInt()}'),
            RangeSlider(
              values: _price,
              min: 0,
              max: 3000000,
              divisions: 60,
              activeColor: AppColors.accent,
              onChanged: (v) => setState(() => _price = v),
            ),
            const SizedBox(height: AppSpacing.md),
            _label('Location'),
            Wrap(
              spacing: AppSpacing.sm,
              runSpacing: AppSpacing.sm,
              children: MockProperties.popularLocations
                  .map((l) => AppChip(
                        label: l,
                        icon: Icons.location_on_outlined,
                        selected: _location == l,
                        onTap: () => setState(() => _location = _location == l ? null : l),
                      ))
                  .toList(),
            ),
            const SizedBox(height: AppSpacing.xl),
            _label('Bedrooms'),
            _stepperRow(
              value: _bedrooms,
              onChanged: (v) => setState(() => _bedrooms = v),
            ),
            const SizedBox(height: AppSpacing.xl),
            _label('Bathrooms'),
            _stepperRow(
              value: _bathrooms,
              onChanged: (v) => setState(() => _bathrooms = v),
            ),
            const SizedBox(height: AppSpacing.xl),
            _label('Area (sqft)', trailing: '${_area.start.toInt()} - ${_area.end.toInt()}'),
            RangeSlider(
              values: _area,
              min: 200,
              max: 10000,
              divisions: 49,
              activeColor: AppColors.accent,
              onChanged: (v) => setState(() => _area = v),
            ),
            const SizedBox(height: AppSpacing.xl),
            _label('Furnishing'),
            Wrap(
              spacing: AppSpacing.sm,
              children: ['Any', 'Furnished', 'Semi-Furnished', 'Unfurnished']
                  .map((f) => AppChip(label: f, selected: _furnished == f, onTap: () => setState(() => _furnished = f)))
                  .toList(),
            ),
            const SizedBox(height: AppSpacing.xl),
            _label('Amenities'),
            Wrap(
              spacing: AppSpacing.sm,
              runSpacing: AppSpacing.sm,
              children: amenityOptions
                  .map((a) => AppChip(
                        label: a,
                        selected: _amenities.contains(a),
                        onTap: () => setState(() {
                          _amenities.contains(a) ? _amenities.remove(a) : _amenities.add(a);
                        }),
                      ))
                  .toList(),
            ),
            const SizedBox(height: AppSpacing.xxxl),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.sm, AppSpacing.lg, AppSpacing.sm),
          child: Row(
            children: [
              Expanded(child: SecondaryButton(label: 'Reset', onPressed: _reset)),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                flex: 2,
                child: PrimaryButton(label: 'Apply Filter', onPressed: () => Navigator.of(context).pop()),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _label(String text, {String? trailing}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Row(
        children: [
          Expanded(child: Text(text, style: Theme.of(context).textTheme.titleMedium)),
          if (trailing != null)
            Text(trailing, style: Theme.of(context).textTheme.labelMedium?.copyWith(color: AppColors.accent)),
        ],
      ),
    );
  }

  Widget _stepperRow({required int value, required ValueChanged<int> onChanged}) {
    return Row(
      children: [
        _stepButton(Icons.remove_rounded, () => onChanged(value > 0 ? value - 1 : 0)),
        Expanded(
          child: Center(
            child: Text(value == 0 ? 'Any' : '$value+', style: Theme.of(context).textTheme.titleMedium),
          ),
        ),
        _stepButton(Icons.add_rounded, () => onChanged(value + 1)),
      ],
    );
  }

  Widget _stepButton(IconData icon, VoidCallback onTap) {
    return Material(
      color: AppColors.lightSurfaceAlt,
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: Padding(padding: const EdgeInsets.all(10), child: Icon(icon, size: 18)),
      ),
    );
  }
}
