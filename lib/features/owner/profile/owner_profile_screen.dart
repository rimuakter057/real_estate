import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/routing/route_paths.dart';
import '../../../core/state/app_session.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/app_dialogs.dart';
import '../../../core/widgets/avatar.dart';
import '../../../core/widgets/status_badge.dart';
import '../../../shared/mock_data/mock_agents.dart';
import '../../../shared/mock_data/mock_properties.dart';
import '../../../shared/models/agent_model.dart';

class OwnerProfileScreen extends StatelessWidget {
  const OwnerProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final me = MockAgents.me;
    final myProperties = MockProperties.byAgent(me.id);
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        children: [
          Row(
            children: [
              Stack(
                children: [
                  AppAvatar(imageUrl: me.avatarUrl, size: 68),
                  if (me.verification == VerificationStatus.verified)
                    const Positioned(
                      bottom: 0,
                      right: 0,
                      child: CircleAvatar(radius: 11, backgroundColor: AppColors.success, child: Icon(Icons.check_rounded, color: Colors.white, size: 14)),
                    ),
                ],
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(me.name, style: Theme.of(context).textTheme.headlineSmall),
                    Text(me.title, style: Theme.of(context).textTheme.bodySmall),
                    const SizedBox(height: 4),
                    StatusChip(
                      status: me.verification == VerificationStatus.verified ? AppStatus.verified : AppStatus.pending,
                      label: me.verification == VerificationStatus.verified ? 'Verified Agent' : 'Verification Pending',
                    ),
                  ],
                ),
              ),
              IconButton(onPressed: () => context.push(RoutePaths.ownerEditProfile), icon: const Icon(Icons.edit_outlined)),
            ],
          ),
          const SizedBox(height: AppSpacing.xl),
          Container(
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
            decoration: BoxDecoration(color: AppColors.lightSurfaceAlt, borderRadius: BorderRadius.circular(AppRadius.md)),
            child: Row(
              children: [
                Expanded(child: _stat(context, '${myProperties.length}', 'Listings')),
                Expanded(child: _stat(context, '${me.rating}', 'Rating')),
                Expanded(child: _stat(context, '${me.reviewsCount}', 'Reviews')),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          _section(context, 'Business', [
            _tile(context, Icons.person_outline_rounded, 'Edit Profile', () => context.push(RoutePaths.ownerEditProfile)),
            _tile(context, Icons.apartment_outlined, 'My Properties', () => context.go(RoutePaths.ownerProperties)),
            _tile(context, Icons.groups_outlined, 'Leads', () => context.go(RoutePaths.ownerLeads)),
            _tile(context, Icons.chat_bubble_outline_rounded, 'Messages', () => context.push(RoutePaths.ownerMessages)),
            _tile(context, Icons.event_available_outlined, 'Visit Requests', () => context.push(RoutePaths.ownerVisitRequests)),
            _tile(context, Icons.notifications_none_rounded, 'Notifications', () => context.push(RoutePaths.ownerNotifications)),
          ]),
          const SizedBox(height: AppSpacing.lg),
          _section(context, 'Preferences', [
            _tile(context, Icons.dark_mode_outlined, 'Dark Mode', () {}, trailing: Switch(
              value: AppSession.instance.themeMode == ThemeMode.dark,
              activeThumbColor: AppColors.accent,
              onChanged: (v) => AppSession.instance.setThemeMode(v ? ThemeMode.dark : ThemeMode.light),
            )),
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
    return Column(children: [
      Text(value, style: Theme.of(context).textTheme.headlineSmall),
      Text(label, style: Theme.of(context).textTheme.bodySmall),
    ]);
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

  Widget _tile(BuildContext context, IconData icon, String label, VoidCallback onTap, {Widget? trailing, bool destructive = false}) {
    return ListTile(
      onTap: onTap,
      leading: Icon(icon, color: destructive ? AppColors.error : AppColors.grey600),
      title: Text(label, style: TextStyle(color: destructive ? AppColors.error : null, fontWeight: FontWeight.w600)),
      trailing: trailing ?? const Icon(Icons.chevron_right_rounded, color: AppColors.grey400),
    );
  }
}
