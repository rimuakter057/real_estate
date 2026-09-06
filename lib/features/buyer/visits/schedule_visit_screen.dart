import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_dialogs.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../shared/mock_data/mock_properties.dart';
import '../../../shared/mock_data/mock_users.dart';

class ScheduleVisitScreen extends StatefulWidget {
  const ScheduleVisitScreen({super.key, required this.propertyId});
  final String propertyId;

  @override
  State<ScheduleVisitScreen> createState() => _ScheduleVisitScreenState();
}

class _ScheduleVisitScreenState extends State<ScheduleVisitScreen> {
  DateTime _selectedDate = DateTime.now().add(const Duration(days: 2));
  String? _selectedSlot;
  final _nameController = TextEditingController(text: MockUsers.buyer.name);
  final _phoneController = TextEditingController(text: MockUsers.buyer.phone);
  final _noteController = TextEditingController();

  static const _slots = ['9:00 AM', '10:00 AM', '11:30 AM', '1:00 PM', '2:30 PM', '4:00 PM', '5:30 PM'];

  @override
  Widget build(BuildContext context) {
    final property = MockProperties.byId(widget.propertyId);
    final days = List.generate(14, (i) => DateTime.now().add(Duration(days: i)));

    return Scaffold(
      appBar: AppBar(title: const Text('Schedule Visit')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          children: [
            Container(
              padding: const EdgeInsets.all(AppSpacing.sm),
              decoration: BoxDecoration(color: AppColors.lightSurfaceAlt, borderRadius: BorderRadius.circular(AppRadius.md)),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: CachedNetworkImage(imageUrl: property.images.first, height: 56, width: 56, fit: BoxFit.cover),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(property.title, style: Theme.of(context).textTheme.titleMedium),
                        Text('${property.location}, ${property.city}', style: Theme.of(context).textTheme.bodySmall),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            Text('Select Date', style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: AppSpacing.sm),
            SizedBox(
              height: 78,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: days.length,
                separatorBuilder: (_, __) => const SizedBox(width: AppSpacing.sm),
                itemBuilder: (context, i) {
                  final day = days[i];
                  final selected = day.day == _selectedDate.day && day.month == _selectedDate.month;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedDate = day),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 150),
                      width: 56,
                      decoration: BoxDecoration(
                        color: selected ? AppColors.accent : AppColors.lightSurfaceAlt,
                        borderRadius: BorderRadius.circular(AppRadius.md),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(DateFormat('EEE').format(day),
                              style: TextStyle(color: selected ? Colors.white : AppColors.grey500, fontSize: 12)),
                          const SizedBox(height: 4),
                          Text('${day.day}',
                              style: TextStyle(
                                  color: selected ? Colors.white : AppColors.navy,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700)),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            Text('Select Time', style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: AppSpacing.sm),
            Wrap(
              spacing: AppSpacing.sm,
              runSpacing: AppSpacing.sm,
              children: _slots.map((s) {
                final selected = _selectedSlot == s;
                return GestureDetector(
                  onTap: () => setState(() => _selectedSlot = s),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
                    decoration: BoxDecoration(
                      color: selected ? AppColors.accent : AppColors.lightSurfaceAlt,
                      borderRadius: BorderRadius.circular(AppRadius.sm),
                    ),
                    child: Text(s, style: TextStyle(color: selected ? Colors.white : AppColors.navy, fontWeight: FontWeight.w600)),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: AppSpacing.xl),
            Text('Visitor Information', style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: AppSpacing.sm),
            AppTextField(label: 'Full Name', controller: _nameController, prefixIcon: Icons.person_outline_rounded),
            const SizedBox(height: AppSpacing.md),
            AppTextField(label: 'Phone Number', controller: _phoneController, prefixIcon: Icons.phone_outlined, keyboardType: TextInputType.phone),
            const SizedBox(height: AppSpacing.md),
            AppTextField(
              label: 'Note (optional)',
              controller: _noteController,
              hint: 'Anything specific you\'d like to know?',
              maxLines: 3,
            ),
            const SizedBox(height: AppSpacing.xl),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.sm, AppSpacing.lg, AppSpacing.sm),
          child: PrimaryButton(
            label: 'Confirm Visit',
            icon: Icons.check_circle_outline_rounded,
            onPressed: _selectedSlot == null
                ? null
                : () async {
                    final confirmed = await AppDialogs.confirm(
                      context,
                      title: 'Confirm Visit',
                      message:
                          'Schedule a visit to ${property.title} on ${DateFormat('MMM d').format(_selectedDate)} at $_selectedSlot?',
                      confirmLabel: 'Confirm',
                      icon: Icons.calendar_month_rounded,
                    );
                    if (confirmed && context.mounted) {
                      AppDialogs.success(context, 'Visit scheduled successfully!');
                      context.pop();
                    }
                  },
          ),
        ),
      ),
    );
  }
}
