import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/routing/route_paths.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_chip.dart';
import '../../../core/widgets/app_dialogs.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../shared/mock_data/mock_categories.dart';

class AddPropertyFlowScreen extends StatefulWidget {
  const AddPropertyFlowScreen({super.key});

  @override
  State<AddPropertyFlowScreen> createState() => _AddPropertyFlowScreenState();
}

class _StepData {
  // Step 1
  String title = '';
  bool isSale = true;
  String propertyType = 'Apartment';
  String price = '';

  // Step 2
  final List<String> images = [];

  // Step 3
  String address = '';
  String city = '';
  String area = '';

  // Step 4
  int bedrooms = 1;
  int bathrooms = 1;
  String areaSqft = '';
  String floor = '';
  String furnished = 'Semi-Furnished';
  String propertyAge = '0-1 years';

  // Step 5
  final Set<String> amenities = {};

  // Step 6
  String description = '';
}

const _samplePhotoPool = [
  'https://images.unsplash.com/photo-1613490493576-7fde63acd811?auto=format&fit=crop&w=800&q=80',
  'https://images.unsplash.com/photo-1600585154340-be6161a56a0c?auto=format&fit=crop&w=800&q=80',
  'https://images.unsplash.com/photo-1600607687939-ce8a6c25118c?auto=format&fit=crop&w=800&q=80',
  'https://images.unsplash.com/photo-1502672260266-1c1ef2d93688?auto=format&fit=crop&w=800&q=80',
  'https://images.unsplash.com/photo-1493809842364-78817add7ffb?auto=format&fit=crop&w=800&q=80',
  'https://images.unsplash.com/photo-1568605114967-8130f3a36994?auto=format&fit=crop&w=800&q=80',
];

class _AddPropertyFlowScreenState extends State<AddPropertyFlowScreen> {
  final _data = _StepData();
  final _pageController = PageController();
  int _step = 0;
  static const _totalSteps = 7; // 7 content steps; Publish is the final action

  final _titleController = TextEditingController();
  final _priceController = TextEditingController();
  final _addressController = TextEditingController();
  final _cityController = TextEditingController();
  final _areaController = TextEditingController();
  final _areaSqftController = TextEditingController();
  final _floorController = TextEditingController();
  final _descriptionController = TextEditingController();

  static const _stepTitles = [
    'Basic Information',
    'Photos',
    'Location',
    'Property Details',
    'Amenities',
    'Description',
    'Preview',
  ];

  void _next() {
    if (_step < _totalSteps - 1) {
      setState(() => _step++);
      _pageController.animateToPage(_step, duration: const Duration(milliseconds: 280), curve: Curves.easeOut);
    } else {
      _publish();
    }
  }

  void _back() {
    if (_step == 0) {
      context.pop();
      return;
    }
    setState(() => _step--);
    _pageController.animateToPage(_step, duration: const Duration(milliseconds: 280), curve: Curves.easeOut);
  }

  void _publish() async {
    final confirmed = await AppDialogs.confirm(
      context,
      title: 'Publish Property',
      message: 'Your listing will be submitted for review and go live once approved by the admin team.',
      confirmLabel: 'Publish',
      icon: Icons.rocket_launch_outlined,
    );
    if (!confirmed || !mounted) return;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.lg)),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: 72,
                width: 72,
                decoration: const BoxDecoration(color: AppColors.accentLight, shape: BoxShape.circle),
                child: const Icon(Icons.check_circle_rounded, color: AppColors.accent, size: 40),
              ),
              const SizedBox(height: AppSpacing.lg),
              Text('Property Submitted!', style: Theme.of(context).textTheme.headlineSmall, textAlign: TextAlign.center),
              const SizedBox(height: AppSpacing.xs),
              Text(
                'Your property is pending admin approval. You\'ll be notified once it\'s live.',
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.xl),
              PrimaryButton(
                label: 'Go to My Properties',
                onPressed: () {
                  context.pop();
                  context.go(RoutePaths.ownerProperties);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _back();
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(icon: const Icon(Icons.arrow_back_rounded), onPressed: _back),
          title: Text(_stepTitles[_step]),
        ),
        body: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.sm),
                child: Column(
                  children: [
                    Row(
                      children: List.generate(_totalSteps, (i) {
                        return Expanded(
                          child: Container(
                            margin: EdgeInsets.only(right: i == _totalSteps - 1 ? 0 : 4),
                            height: 5,
                            decoration: BoxDecoration(
                              color: i <= _step ? AppColors.accent : AppColors.grey200,
                              borderRadius: BorderRadius.circular(AppRadius.pill),
                            ),
                          ),
                        );
                      }),
                    ),
                    const SizedBox(height: 6),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text('Step ${_step + 1} of $_totalSteps', style: Theme.of(context).textTheme.labelMedium),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: PageView(
                  controller: _pageController,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    _basicInfoStep(),
                    _photosStep(),
                    _locationStep(),
                    _detailsStep(),
                    _amenitiesStep(),
                    _descriptionStep(),
                    _previewStep(),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.sm, AppSpacing.lg, AppSpacing.md),
                child: PrimaryButton(
                  label: _step == _totalSteps - 1 ? 'Publish Property' : 'Continue',
                  icon: _step == _totalSteps - 1 ? Icons.rocket_launch_outlined : Icons.arrow_forward_rounded,
                  onPressed: _next,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _stepScroll(List<Widget> children) {
    return ListView(padding: const EdgeInsets.all(AppSpacing.lg), children: children);
  }

  Widget _basicInfoStep() {
    return _stepScroll([
      AppTextField(
        label: 'Property Title',
        controller: _titleController,
        hint: 'e.g. Modern Skyline Villa',
        prefixIcon: Icons.title_rounded,
        onChanged: (v) => _data.title = v,
      ),
      const SizedBox(height: AppSpacing.lg),
      Text('Listing Type', style: Theme.of(context).textTheme.labelLarge),
      const SizedBox(height: AppSpacing.sm),
      BuyRentToggle(isBuy: _data.isSale, onChanged: (v) => setState(() => _data.isSale = v)),
      const SizedBox(height: AppSpacing.lg),
      Text('Property Type', style: Theme.of(context).textTheme.labelLarge),
      const SizedBox(height: AppSpacing.sm),
      Wrap(
        spacing: AppSpacing.sm,
        runSpacing: AppSpacing.sm,
        children: MockCategories.all
            .map((c) => AppChip(
                  label: c.name,
                  icon: c.icon,
                  selected: _data.propertyType == c.name,
                  onTap: () => setState(() => _data.propertyType = c.name),
                ))
            .toList(),
      ),
      const SizedBox(height: AppSpacing.lg),
      AppTextField(
        label: 'Price',
        controller: _priceController,
        hint: 'Enter amount in USD',
        prefixIcon: Icons.attach_money_rounded,
        keyboardType: TextInputType.number,
        onChanged: (v) => _data.price = v,
      ),
    ]);
  }

  Widget _photosStep() {
    return _stepScroll([
      Text('Add up to 10 photos. The first photo will be your cover image.', style: Theme.of(context).textTheme.bodyMedium),
      const SizedBox(height: AppSpacing.lg),
      GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: _data.images.length + 1,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: AppSpacing.sm,
          mainAxisSpacing: AppSpacing.sm,
        ),
        itemBuilder: (context, i) {
          if (i == _data.images.length) {
            return GestureDetector(
              onTap: () => setState(() {
                final next = _samplePhotoPool[_data.images.length % _samplePhotoPool.length];
                _data.images.add(next);
              }),
              child: DottedUploadTile(),
            );
          }
          final img = _data.images[i];
          return Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(AppRadius.sm),
                child: Image.network(img, fit: BoxFit.cover, width: double.infinity, height: double.infinity),
              ),
              if (i == 0)
                Positioned(
                  left: 4,
                  top: 4,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(color: AppColors.accent, borderRadius: BorderRadius.circular(4)),
                    child: const Text('Cover', style: TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.w700)),
                  ),
                ),
              Positioned(
                right: 4,
                top: 4,
                child: GestureDetector(
                  onTap: () => setState(() => _data.images.removeAt(i)),
                  child: Container(
                    padding: const EdgeInsets.all(3),
                    decoration: const BoxDecoration(color: Colors.black54, shape: BoxShape.circle),
                    child: const Icon(Icons.close_rounded, color: Colors.white, size: 14),
                  ),
                ),
              ),
            ],
          );
        },
      ),
      if (_data.images.length > 1) ...[
        const SizedBox(height: AppSpacing.lg),
        Text('Drag to reorder', style: Theme.of(context).textTheme.labelMedium),
        const SizedBox(height: AppSpacing.sm),
        SizedBox(
          height: 80,
          child: ReorderableListView(
            scrollDirection: Axis.horizontal,
            onReorder: (oldIndex, newIndex) => setState(() {
              if (newIndex > oldIndex) newIndex--;
              final item = _data.images.removeAt(oldIndex);
              _data.images.insert(newIndex, item);
            }),
            children: [
              for (int i = 0; i < _data.images.length; i++)
                Padding(
                  key: ValueKey(_data.images[i] + i.toString()),
                  padding: const EdgeInsets.only(right: AppSpacing.sm),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(AppRadius.sm),
                    child: Image.network(_data.images[i], width: 80, height: 80, fit: BoxFit.cover),
                  ),
                ),
            ],
          ),
        ),
      ],
    ]);
  }

  Widget _locationStep() {
    return _stepScroll([
      AppTextField(label: 'Address', controller: _addressController, prefixIcon: Icons.home_outlined, onChanged: (v) => _data.address = v),
      const SizedBox(height: AppSpacing.md),
      AppTextField(label: 'City', controller: _cityController, prefixIcon: Icons.location_city_rounded, onChanged: (v) => _data.city = v),
      const SizedBox(height: AppSpacing.md),
      AppTextField(label: 'Area / Community', controller: _areaController, prefixIcon: Icons.map_outlined, onChanged: (v) => _data.area = v),
      const SizedBox(height: AppSpacing.lg),
      Text('Pin Location on Map', style: Theme.of(context).textTheme.labelLarge),
      const SizedBox(height: AppSpacing.sm),
      Container(
        height: 160,
        decoration: BoxDecoration(color: AppColors.accentLight, borderRadius: BorderRadius.circular(AppRadius.md)),
        child: const Center(child: Icon(Icons.location_on_rounded, color: AppColors.accent, size: 40)),
      ),
    ]);
  }

  Widget _detailsStep() {
    return _stepScroll([
      Text('Bedrooms', style: Theme.of(context).textTheme.labelLarge),
      const SizedBox(height: AppSpacing.sm),
      _counterRow(_data.bedrooms, (v) => setState(() => _data.bedrooms = v)),
      const SizedBox(height: AppSpacing.lg),
      Text('Bathrooms', style: Theme.of(context).textTheme.labelLarge),
      const SizedBox(height: AppSpacing.sm),
      _counterRow(_data.bathrooms, (v) => setState(() => _data.bathrooms = v)),
      const SizedBox(height: AppSpacing.lg),
      AppTextField(label: 'Area (sqft)', controller: _areaSqftController, prefixIcon: Icons.square_foot_rounded, keyboardType: TextInputType.number, onChanged: (v) => _data.areaSqft = v),
      const SizedBox(height: AppSpacing.md),
      AppTextField(label: 'Floor', controller: _floorController, prefixIcon: Icons.layers_outlined, onChanged: (v) => _data.floor = v),
      const SizedBox(height: AppSpacing.lg),
      Text('Furnished Status', style: Theme.of(context).textTheme.labelLarge),
      const SizedBox(height: AppSpacing.sm),
      Wrap(
        spacing: AppSpacing.sm,
        children: ['Furnished', 'Semi-Furnished', 'Unfurnished']
            .map((f) => AppChip(label: f, selected: _data.furnished == f, onTap: () => setState(() => _data.furnished = f)))
            .toList(),
      ),
      const SizedBox(height: AppSpacing.lg),
      Text('Property Age', style: Theme.of(context).textTheme.labelLarge),
      const SizedBox(height: AppSpacing.sm),
      Wrap(
        spacing: AppSpacing.sm,
        children: ['0-1 years', '1-3 years', '3-5 years', '5+ years']
            .map((f) => AppChip(label: f, selected: _data.propertyAge == f, onTap: () => setState(() => _data.propertyAge = f)))
            .toList(),
      ),
    ]);
  }

  Widget _amenitiesStep() {
    const options = [
      ('Parking', Icons.local_parking_rounded),
      ('Balcony', Icons.balcony_rounded),
      ('Security', Icons.security_rounded),
      ('Lift', Icons.elevator_rounded),
      ('Gym', Icons.fitness_center_rounded),
      ('Swimming Pool', Icons.pool_rounded),
      ('Generator', Icons.electrical_services_rounded),
      ('Garden', Icons.park_rounded),
    ];
    return _stepScroll([
      Text('Select all amenities available at this property.', style: Theme.of(context).textTheme.bodyMedium),
      const SizedBox(height: AppSpacing.lg),
      GridView.count(
        crossAxisCount: 2,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisSpacing: AppSpacing.sm,
        mainAxisSpacing: AppSpacing.sm,
        childAspectRatio: 2.6,
        children: options.map((o) {
          final selected = _data.amenities.contains(o.$1);
          return GestureDetector(
            onTap: () => setState(() => selected ? _data.amenities.remove(o.$1) : _data.amenities.add(o.$1)),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
              decoration: BoxDecoration(
                color: selected ? AppColors.accentLight : AppColors.lightSurfaceAlt,
                borderRadius: BorderRadius.circular(AppRadius.md),
                border: Border.all(color: selected ? AppColors.accent : Colors.transparent, width: 1.4),
              ),
              child: Row(
                children: [
                  Icon(o.$2, size: 20, color: selected ? AppColors.accent : AppColors.grey500),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(child: Text(o.$1, style: Theme.of(context).textTheme.labelLarge)),
                  if (selected) const Icon(Icons.check_circle_rounded, color: AppColors.accent, size: 18),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    ]);
  }

  Widget _descriptionStep() {
    return _stepScroll([
      AppTextField(
        label: 'Property Description',
        controller: _descriptionController,
        hint: 'Describe the property, its highlights, and nearby landmarks...',
        maxLines: 10,
        minLines: 8,
        onChanged: (v) => _data.description = v,
      ),
    ]);
  }

  Widget _previewStep() {
    return _stepScroll([
      if (_data.images.isNotEmpty)
        ClipRRect(
          borderRadius: BorderRadius.circular(AppRadius.lg),
          child: Image.network(_data.images.first, height: 200, width: double.infinity, fit: BoxFit.cover),
        )
      else
        Container(
          height: 200,
          decoration: BoxDecoration(color: AppColors.grey100, borderRadius: BorderRadius.circular(AppRadius.lg)),
          child: const Center(child: Icon(Icons.image_outlined, size: 40, color: AppColors.grey400)),
        ),
      const SizedBox(height: AppSpacing.lg),
      Text(_data.title.isEmpty ? 'Untitled Property' : _data.title, style: Theme.of(context).textTheme.headlineSmall),
      const SizedBox(height: 4),
      Text('${_data.address.isEmpty ? "Address" : _data.address}, ${_data.city.isEmpty ? "City" : _data.city}',
          style: Theme.of(context).textTheme.bodyMedium),
      const SizedBox(height: AppSpacing.sm),
      Text(
        _data.price.isEmpty ? '\$0' : '\$${_data.price}',
        style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: AppColors.accent),
      ),
      const SizedBox(height: AppSpacing.lg),
      Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(color: AppColors.lightSurfaceAlt, borderRadius: BorderRadius.circular(AppRadius.md)),
        child: Column(
          children: [
            _previewRow('Listing Type', _data.isSale ? 'For Sale' : 'For Rent'),
            _previewRow('Property Type', _data.propertyType),
            _previewRow('Bedrooms', '${_data.bedrooms}'),
            _previewRow('Bathrooms', '${_data.bathrooms}'),
            _previewRow('Area', '${_data.areaSqft.isEmpty ? "-" : _data.areaSqft} sqft'),
            _previewRow('Furnishing', _data.furnished),
          ],
        ),
      ),
      const SizedBox(height: AppSpacing.lg),
      if (_data.amenities.isNotEmpty) ...[
        Text('Amenities', style: Theme.of(context).textTheme.labelLarge),
        const SizedBox(height: AppSpacing.sm),
        Wrap(spacing: AppSpacing.sm, runSpacing: AppSpacing.sm, children: _data.amenities.map((a) => AppChip(label: a)).toList()),
        const SizedBox(height: AppSpacing.lg),
      ],
      Text('Description', style: Theme.of(context).textTheme.labelLarge),
      const SizedBox(height: AppSpacing.sm),
      Text(
        _data.description.isEmpty ? 'No description added yet.' : _data.description,
        style: Theme.of(context).textTheme.bodyMedium,
      ),
    ]);
  }

  Widget _previewRow(String label, String value) {
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

  Widget _counterRow(int value, ValueChanged<int> onChanged) {
    return Row(
      children: [
        _counterButton(Icons.remove_rounded, () => onChanged(value > 0 ? value - 1 : 0)),
        Expanded(child: Center(child: Text('$value', style: Theme.of(context).textTheme.headlineSmall))),
        _counterButton(Icons.add_rounded, () => onChanged(value + 1)),
      ],
    );
  }

  Widget _counterButton(IconData icon, VoidCallback onTap) {
    return Material(
      color: AppColors.lightSurfaceAlt,
      shape: const CircleBorder(),
      child: InkWell(customBorder: const CircleBorder(), onTap: onTap, child: Padding(padding: const EdgeInsets.all(12), child: Icon(icon))),
    );
  }
}

class DottedUploadTile extends StatelessWidget {
  const DottedUploadTile({super.key});

  @override
  Widget build(BuildContext context) {
    return DottedBorder(
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add_a_photo_outlined, color: AppColors.accent, size: 22),
            SizedBox(height: 4),
            Text('Add Photo', style: TextStyle(fontSize: 10, color: AppColors.accent, fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }
}

class DottedBorder extends StatelessWidget {
  const DottedBorder({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _DashedBorderPainter(),
      child: child,
    );
  }
}

class _DashedBorderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.accent.withValues(alpha: 0.5)
      ..strokeWidth = 1.4
      ..style = PaintingStyle.stroke;
    final rrect = RRect.fromRectAndRadius(Offset.zero & size, const Radius.circular(AppRadius.sm));
    final path = Path()..addRRect(rrect);
    final dashPath = Path();
    for (final metric in path.computeMetrics()) {
      double distance = 0;
      while (distance < metric.length) {
        dashPath.addPath(metric.extractPath(distance, distance + 5), Offset.zero);
        distance += 9;
      }
    }
    canvas.drawPath(dashPath, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
