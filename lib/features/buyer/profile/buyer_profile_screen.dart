import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/routing/route_paths.dart';
import '../../../core/state/app_session.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/app_dialogs.dart';
import '../../../core/widgets/avatar.dart';
import '../../../shared/mock_data/mock_users.dart';

class BuyerProfileScreen extends StatelessWidget {
  const BuyerProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = MockUsers.buyer;
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        children: [
          Row(
            children: [
              AppAvatar(imageUrl: user.avatarUrl, size: 68),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(user.name, style: Theme.of(context).textTheme.headlineSmall),
                    const SizedBox(height: 2),
                    Text(user.email, style: Theme.of(context).textTheme.bodySmall),
                    const SizedBox(height: 2),
                    Row(children: [
                      const Icon(Icons.location_on_outlined, size: 13, color: AppColors.grey500),
                      const SizedBox(width: 2),
                      Text(user.city ?? '', style: Theme.of(context).textTheme.bodySmall),
                    ]),
                  ],
                ),
              ),
              IconButton(
                onPressed: () => context.push(RoutePaths.buyerEditProfile),
                icon: const Icon(Icons.edit_outlined),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xl),
          Container(
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
            decoration: BoxDecoration(color: AppColors.lightSurfaceAlt, borderRadius: BorderRadius.circular(AppRadius.md)),
            child: Row(
              children: [
                Expanded(child: _stat(context, '${user.savedCount}', 'Saved')),
                Expanded(child: _stat(context, '4', 'Visits')),
                Expanded(child: _stat(context, '2', 'Messages')),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          _section(context, 'Account', [
            _tile(context, Icons.person_outline_rounded, 'Edit Profile', () => context.push(RoutePaths.buyerEditProfile)),
            _tile(context, Icons.favorite_border_rounded, 'Favorites', () => context.go(RoutePaths.buyerFavorites)),
            _tile(context, Icons.event_available_outlined, 'My Visits', () => context.push(RoutePaths.buyerMyVisits)),
            _tile(context, Icons.notifications_none_rounded, 'Notifications', () => context.push(RoutePaths.buyerNotifications)),
          ]),
          const SizedBox(height: AppSpacing.lg),
          _section(context, 'Preferences', [
            _tile(context, Icons.dark_mode_outlined, 'Dark Mode', () {}, trailing: Switch(
              value: AppSession.instance.themeMode == ThemeMode.dark,
              activeThumbColor: AppColors.accent,
              onChanged: (v) => AppSession.instance.setThemeMode(v ? ThemeMode.dark : ThemeMode.light),
            )),
            _tile(context, Icons.language_outlined, 'Language', () {}, value: 'English'),
            _tile(context, Icons.privacy_tip_outlined, 'Privacy Policy', () {}),
            _tile(context, Icons.help_outline_rounded, 'Help & Support', () {}),
          ]),
          const SizedBox(height: AppSpacing.lg),
          _section(context, '', [
            _tile(context, Icons.logout_rounded, 'Log Out', () async {
              final confirm = await AppDialogs.confirm(
                context,
                title: 'Log Out',
                message: 'Are you sure you want to log out of your account?',
                confirmLabel: 'Log Out',
                destructive: true,
                icon: Icons.logout_rounded,
              );
              if (confirm && context.mounted) {
                AppSession.instance.signOut();
                context.go(RoutePaths.login);
              }
            }, destructive: true),
          ]),
          const SizedBox(height: AppSpacing.xl),
        ],
      ),
    );
  }

  Widget _stat(BuildContext context, String value, String label) {
    return Column(
      children: [
        Text(value, style: Theme.of(context).textTheme.headlineSmall),
        Text(label, style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }

  Widget _section(BuildContext context, String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title.isNotEmpty) ...[
          Text(title, style: Theme.of(context).textTheme.labelLarge?.copyWith(color: AppColors.grey500)),
          const SizedBox(height: AppSpacing.xs),
        ],
        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).cardTheme.color,
            borderRadius: BorderRadius.circular(AppRadius.md),
            border: Border.all(color: AppColors.lightBorder),
          ),
          child: Column(children: children),
        ),
      ],
    );
  }

  Widget _tile(BuildContext context, IconData icon, String label, VoidCallback onTap,
      {Widget? trailing, String? value, bool destructive = false}) {
    return ListTile(
      onTap: onTap,
      leading: Icon(icon, color: destructive ? AppColors.error : AppColors.grey600),
      title: Text(label, style: TextStyle(color: destructive ? AppColors.error : null, fontWeight: FontWeight.w600)),
      trailing: trailing ??
          (value != null
              ? Row(mainAxisSize: MainAxisSize.min, children: [
                  Text(value, style: Theme.of(context).textTheme.bodyMedium),
                  const Icon(Icons.chevron_right_rounded, color: AppColors.grey400),
                ])
              : const Icon(Icons.chevron_right_rounded, color: AppColors.grey400)),
    );
  }
}
