import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_dialogs.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../shared/mock_data/mock_categories.dart';
import '../../../shared/models/category_model.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  late final List<CategoryModel> _categories = List.of(MockCategories.all);

  void _addCategory() {
    final controller = TextEditingController();
    AppDialogs.sheet(
      context,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Add Category', style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: AppSpacing.md),
          AppTextField(label: 'Category Name', controller: controller, hint: 'e.g. Penthouse', prefixIcon: Icons.category_outlined),
          const SizedBox(height: AppSpacing.lg),
          PrimaryButton(
            label: 'Add Category',
            onPressed: () {
              if (controller.text.trim().isEmpty) return;
              setState(() {
                _categories.add(CategoryModel(
                  id: 'cat_${_categories.length + 1}',
                  name: controller.text.trim(),
                  icon: Icons.category_rounded,
                  count: 0,
                ));
              });
              Navigator.of(context).pop();
              AppDialogs.success(context, 'Category added');
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Categories'),
        actions: [IconButton(icon: const Icon(Icons.add_rounded), onPressed: _addCategory)],
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(AppSpacing.lg),
        itemCount: _categories.length,
        separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.sm),
        itemBuilder: (context, i) {
          final c = _categories[i];
          return Container(
            padding: const EdgeInsets.all(AppSpacing.sm),
            decoration: BoxDecoration(
              color: Theme.of(context).cardTheme.color,
              borderRadius: BorderRadius.circular(AppRadius.md),
              border: Border.all(color: AppColors.lightBorder),
            ),
            child: Row(
              children: [
                Container(
                  height: 42,
                  width: 42,
                  decoration: BoxDecoration(color: AppColors.accentLight, borderRadius: BorderRadius.circular(10)),
                  child: Icon(c.icon, color: AppColors.accent, size: 20),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(c.name, style: Theme.of(context).textTheme.titleMedium),
                      Text('${c.count} listings', style: Theme.of(context).textTheme.bodySmall),
                    ],
                  ),
                ),
                Switch(
                  value: c.active,
                  activeThumbColor: AppColors.accent,
                  onChanged: (v) => setState(() {
                    _categories[i] = CategoryModel(id: c.id, name: c.name, icon: c.icon, count: c.count, active: v);
                  }),
                ),
                PopupMenuButton<String>(
                  icon: const Icon(Icons.more_vert_rounded, color: AppColors.grey500),
                  onSelected: (v) async {
                    if (v == 'delete') {
                      final confirm = await AppDialogs.confirm(
                        context,
                        title: 'Delete Category',
                        message: 'Are you sure you want to delete "${c.name}"?',
                        confirmLabel: 'Delete',
                        destructive: true,
                      );
                      if (confirm) setState(() => _categories.removeAt(i));
                    }
                  },
                  itemBuilder: (context) => const [
                    PopupMenuItem(value: 'delete', child: Text('Delete', style: TextStyle(color: AppColors.error))),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
