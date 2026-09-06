import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/routing/route_paths.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/app_states.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/avatar.dart';
import '../../../core/widgets/status_badge.dart';
import '../../../shared/mock_data/mock_users.dart';
import '../../../shared/models/user_model.dart';

class UsersScreen extends StatefulWidget {
  const UsersScreen({super.key});

  @override
  State<UsersScreen> createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
  String _query = '';
  String _filter = 'All';

  @override
  Widget build(BuildContext context) {
    var users = MockUsers.platformUsers;
    if (_filter == 'Active') users = users.where((u) => u.active).toList();
    if (_filter == 'Deactivated') users = users.where((u) => !u.active).toList();
    if (_query.isNotEmpty) {
      users = users.where((u) => u.name.toLowerCase().contains(_query.toLowerCase()) || u.email.toLowerCase().contains(_query.toLowerCase())).toList();
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Users')),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppSearchField(hint: 'Search users by name or email', onChanged: (v) => setState(() => _query = v)),
            const SizedBox(height: AppSpacing.md),
            SizedBox(
              height: 40,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: 3,
                separatorBuilder: (_, __) => const SizedBox(width: AppSpacing.sm),
                itemBuilder: (context, i) {
                  final label = ['All', 'Active', 'Deactivated'][i];
                  final selected = _filter == label;
                  return ChoiceChip(
                    label: Text(label),
                    selected: selected,
                    onSelected: (_) => setState(() => _filter = label),
                    selectedColor: AppColors.accent,
                    labelStyle: TextStyle(color: selected ? Colors.white : AppColors.navy, fontWeight: FontWeight.w600),
                    backgroundColor: AppColors.lightSurfaceAlt,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.pill), side: BorderSide.none),
                  );
                },
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Expanded(
              child: users.isEmpty
                  ? const EmptyState(icon: Icons.person_search_rounded, title: 'No Users Found', message: 'Try a different search term or filter.')
                  : ListView.separated(
                      itemCount: users.length,
                      separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.sm),
                      itemBuilder: (context, i) => _userTile(context, users[i]),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _userTile(BuildContext context, AppUser user) {
    return GestureDetector(
      onTap: () => context.push(RoutePaths.adminUserDetails(user.id)),
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.sm),
        decoration: BoxDecoration(
          color: Theme.of(context).cardTheme.color,
          borderRadius: BorderRadius.circular(AppRadius.md),
          border: Border.all(color: AppColors.lightBorder),
        ),
        child: Row(
          children: [
            AppAvatar(imageUrl: user.avatarUrl, size: 44),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(user.name, style: Theme.of(context).textTheme.titleMedium),
                  Text(
                    user.email,
                    style: Theme.of(context).textTheme.bodySmall,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            StatusChip(status: user.active ? AppStatus.active : AppStatus.rejected, label: user.active ? 'Active' : 'Deactivated'),
          ],
        ),
      ),
    );
  }
}
