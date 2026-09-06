import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/routing/route_paths.dart';
import '../../../core/state/app_session.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/app_dialogs.dart';
import '../../../core/widgets/avatar.dart';
import '../../../shared/mock_data/mock_users.dart';

class AdminSettingsScreen extends StatelessWidget {
  const AdminSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final admin = MockUsers.admin;
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        children: [
          Row(
            children: [
              AppAvatar(imageUrl: admin.avatarUrl, size: 60),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(admin.name, style: Theme.of(context).textTheme.headlineSmall),
                    Text(admin.email, style: Theme.of(context).textTheme.bodySmall),
                  ],
                ),
              ),
              IconButton(icon: const Icon(Icons.edit_outlined), onPressed: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Edit admin profile (demo)')))),
            ],
          ),
          const SizedBox(height: AppSpacing.xl),
          _section(context, 'General', [
            _tile(context, Icons.person_outline_rounded, 'Profile', () {}),
            _tile(context, Icons.notifications_none_rounded, 'Notifications', () {}),
            _tile(context, Icons.security_outlined, 'Security', () {}),
          ]),
          const SizedBox(height: AppSpacing.lg),
          _section(context, 'App', [
            _tile(context, Icons.dark_mode_outlined, 'Dark Mode', () {}, trailing: Switch(
              value: AppSession.instance.themeMode == ThemeMode.dark,
              activeThumbColor: AppColors.accent,
              onChanged: (v) => AppSession.instance.setThemeMode(v ? ThemeMode.dark : ThemeMode.light),
            )),
            _tile(context, Icons.language_outlined, 'Language', () {}, value: 'English'),
            _tile(context, Icons.info_outline_rounded, 'About EstateHub', () {}),
          ]),
          const SizedBox(height: AppSpacing.lg),
          _section(context, '', [
            _tile(context, Icons.logout_rounded, 'Log Out', () async {
              final confirm = await AppDialogs.confirm(
                context,
                title: 'Log Out',
                message: 'Are you sure you want to log out of the admin console?',
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
        ],
      ),
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

  Widget _tile(BuildContext context, IconData icon, String label, VoidCallback onTap, {Widget? trailing, String? value, bool destructive = false}) {
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
