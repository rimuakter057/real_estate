import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_chip.dart';
import '../../../core/widgets/app_dialogs.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../shared/mock_data/mock_categories.dart';
import '../../../shared/mock_data/mock_properties.dart';
import '../../../shared/models/property_model.dart';

class EditPropertyScreen extends StatefulWidget {
  const EditPropertyScreen({super.key, required this.propertyId});
  final String propertyId;

  @override
  State<EditPropertyScreen> createState() => _EditPropertyScreenState();
}

class _EditPropertyScreenState extends State<EditPropertyScreen> {
  late PropertyModel _property;
  late final TextEditingController _title;
  late final TextEditingController _price;
  late final TextEditingController _location;
  late final TextEditingController _description;
  late ListingKind _kind;
  late String _type;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _property = MockProperties.byId(widget.propertyId);
    _title = TextEditingController(text: _property.title);
    _price = TextEditingController(text: _property.price.toStringAsFixed(0));
    _location = TextEditingController(text: _property.location);
    _description = TextEditingController(text: _property.description);
    _kind = _property.kind;
    _type = _property.type.label;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Property')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          children: [
            SizedBox(
              height: 100,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: _property.images.length,
                separatorBuilder: (_, __) => const SizedBox(width: AppSpacing.sm),
                itemBuilder: (context, i) => ClipRRect(
                  borderRadius: BorderRadius.circular(AppRadius.md),
                  child: Image.network(_property.images[i], height: 100, width: 100, fit: BoxFit.cover),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            AppTextField(label: 'Property Title', controller: _title, prefixIcon: Icons.title_rounded),
            const SizedBox(height: AppSpacing.md),
            Text('Listing Type', style: Theme.of(context).textTheme.labelLarge),
            const SizedBox(height: AppSpacing.sm),
            BuyRentToggle(isBuy: _kind == ListingKind.sale, onChanged: (v) => setState(() => _kind = v ? ListingKind.sale : ListingKind.rent)),
            const SizedBox(height: AppSpacing.md),
            Text('Property Type', style: Theme.of(context).textTheme.labelLarge),
            const SizedBox(height: AppSpacing.sm),
            Wrap(
              spacing: AppSpacing.sm,
              runSpacing: AppSpacing.sm,
              children: MockCategories.all.map((c) => AppChip(label: c.name, icon: c.icon, selected: _type == c.name, onTap: () => setState(() => _type = c.name))).toList(),
            ),
            const SizedBox(height: AppSpacing.md),
            AppTextField(label: 'Price', controller: _price, prefixIcon: Icons.attach_money_rounded, keyboardType: TextInputType.number),
            const SizedBox(height: AppSpacing.md),
            AppTextField(label: 'Location', controller: _location, prefixIcon: Icons.location_on_outlined),
            const SizedBox(height: AppSpacing.md),
            AppTextField(label: 'Description', controller: _description, maxLines: 5),
            const SizedBox(height: AppSpacing.xl),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.sm, AppSpacing.lg, AppSpacing.sm),
          child: PrimaryButton(
            label: 'Save Changes',
            loading: _saving,
            onPressed: () async {
              setState(() => _saving = true);
              await Future.delayed(const Duration(milliseconds: 700));
              if (!mounted) return;
              setState(() => _saving = false);
              AppDialogs.success(context, 'Property updated successfully!');
              context.pop();
            },
          ),
        ),
      ),
    );
  }
}
