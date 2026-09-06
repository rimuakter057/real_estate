import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/routing/route_paths.dart';
import '../../../core/state/app_session.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/app_dialogs.dart';
import '../../../core/widgets/avatar.dart';
import '../../../shared/mock_data/mock_users.dart';

class _AdminNavItem {
  const _AdminNavItem(this.icon, this.activeIcon, this.label);
  final IconData icon;
  final IconData activeIcon;
  final String label;
}

const _navItems = [
  _AdminNavItem(Icons.dashboard_outlined, Icons.dashboard_rounded, 'Dashboard'),
  _AdminNavItem(Icons.people_outline_rounded, Icons.people_alt_rounded, 'Users'),
  _AdminNavItem(Icons.badge_outlined, Icons.badge_rounded, 'Agents'),
  _AdminNavItem(Icons.apartment_outlined, Icons.apartment_rounded, 'Properties'),
  _AdminNavItem(Icons.pending_actions_outlined, Icons.pending_actions_rounded, 'Pending Approval'),
  _AdminNavItem(Icons.flag_outlined, Icons.flag_rounded, 'Reports'),
  _AdminNavItem(Icons.star_border_rounded, Icons.star_rounded, 'Featured Listings'),
  _AdminNavItem(Icons.category_outlined, Icons.category_rounded, 'Categories'),
  _AdminNavItem(Icons.settings_outlined, Icons.settings_rounded, 'Settings'),
];

class AdminShell extends StatelessWidget {
  const AdminShell({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    final admin = MockUsers.admin;
    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final wide = constraints.maxWidth > 760;
            return Row(
              children: [
                Container(
                  width: wide ? 240 : 76,
                  color: AppColors.navy,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: wide ? AppSpacing.lg : AppSpacing.sm, vertical: AppSpacing.xl),
                        child: Row(
                          mainAxisAlignment: wide ? MainAxisAlignment.start : MainAxisAlignment.center,
                          children: [
                            Container(
                              height: 36,
                              width: 36,
                              decoration: BoxDecoration(color: AppColors.accent, borderRadius: BorderRadius.circular(10)),
                              child: const Icon(Icons.home_work_rounded, color: Colors.white, size: 20),
                            ),
                            if (wide) ...[
                              const SizedBox(width: AppSpacing.sm),
                              const Text('EstateHub', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 17)),
                            ],
                          ],
                        ),
                      ),
                      Expanded(
                        child: ListView.builder(
                          padding: EdgeInsets.zero,
                          itemCount: _navItems.length,
                          itemBuilder: (context, i) {
                            final item = _navItems[i];
                            final selected = navigationShell.currentIndex == i;
                            return Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                              child: Material(
                                color: selected ? Colors.white.withValues(alpha: 0.08) : Colors.transparent,
                                borderRadius: BorderRadius.circular(AppRadius.sm),
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(AppRadius.sm),
                                  onTap: () => navigationShell.goBranch(i, initialLocation: i == navigationShell.currentIndex),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                                    child: Row(
                                      mainAxisAlignment: wide ? MainAxisAlignment.start : MainAxisAlignment.center,
                                      children: [
                                        Icon(selected ? item.activeIcon : item.icon,
                                            color: selected ? Colors.white : Colors.white60, size: 20),
                                        if (wide) ...[
                                          const SizedBox(width: AppSpacing.sm),
                                          Expanded(
                                            child: Text(
                                              item.label,
                                              style: TextStyle(
                                                color: selected ? Colors.white : Colors.white60,
                                                fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                                                fontSize: 13.5,
                                              ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ],
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      const Divider(color: Colors.white12, height: 1),
                      Padding(
                        padding: const EdgeInsets.all(AppSpacing.sm),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(AppRadius.sm),
                          onTap: () async {
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
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm, horizontal: AppSpacing.xs),
                            child: Row(
                              mainAxisAlignment: wide ? MainAxisAlignment.start : MainAxisAlignment.center,
                              children: [
                                AppAvatar(imageUrl: admin.avatarUrl, size: 32),
                                if (wide) ...[
                                  const SizedBox(width: AppSpacing.sm),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(admin.name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 12.5), maxLines: 1, overflow: TextOverflow.ellipsis),
                                        const Text('Log out', style: TextStyle(color: Colors.white54, fontSize: 11)),
                                      ],
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(child: navigationShell),
              ],
            );
          },
        ),
      ),
    );
  }
}
