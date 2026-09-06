import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_dialogs.dart';
import '../../../core/widgets/avatar.dart';
import '../../../core/widgets/status_badge.dart';
import '../../../shared/mock_data/mock_users.dart';

class UserDetailsScreen extends StatefulWidget {
  const UserDetailsScreen({super.key, required this.userId});
  final String userId;

  @override
  State<UserDetailsScreen> createState() => _UserDetailsScreenState();
}

class _UserDetailsScreenState extends State<UserDetailsScreen> {
  late var _user = MockUsers.platformUsers.firstWhere((u) => u.id == widget.userId, orElse: () => MockUsers.platformUsers.first);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('User Details')),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        children: [
          Center(
            child: Column(
              children: [
                AppAvatar(imageUrl: _user.avatarUrl, size: 88),
                const SizedBox(height: AppSpacing.sm),
                Text(_user.name, style: Theme.of(context).textTheme.headlineSmall),
                const SizedBox(height: 4),
                StatusChip(status: _user.active ? AppStatus.active : AppStatus.rejected, label: _user.active ? 'Active Account' : 'Deactivated'),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          Container(
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
            decoration: BoxDecoration(color: AppColors.lightSurfaceAlt, borderRadius: BorderRadius.circular(AppRadius.md)),
            child: Row(
              children: [
                Expanded(child: _stat(context, '${_user.savedCount}', 'Saved')),
                Expanded(child: _stat(context, 'Buyer', 'Role')),
                Expanded(child: _stat(context, _user.city ?? '-', 'City')),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          Text('Contact Information', style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: AppSpacing.sm),
          _row(context, Icons.mail_outline_rounded, 'Email', _user.email),
          _row(context, Icons.phone_outlined, 'Phone', _user.phone),
          _row(context, Icons.location_on_outlined, 'City', _user.city ?? '-'),
          const SizedBox(height: AppSpacing.xl),
          Text('Account Actions', style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              Expanded(
                child: _user.active
                    ? SecondaryButton(
                        label: 'Deactivate',
                        icon: Icons.block_rounded,
                        onPressed: () => _toggleActive(false),
                      )
                    : PrimaryButton(
                        label: 'Activate',
                        icon: Icons.check_circle_outline_rounded,
                        onPressed: () => _toggleActive(true),
                      ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _toggleActive(bool active) async {
    final confirm = await AppDialogs.confirm(
      context,
      title: active ? 'Activate Account' : 'Deactivate Account',
      message: active
          ? '${_user.name} will regain full access to the platform.'
          : '${_user.name} will lose access to their account until reactivated.',
      confirmLabel: active ? 'Activate' : 'Deactivate',
      destructive: !active,
    );
    if (!confirm) return;
    setState(() {
      _user = _user.copyWith(active: active);
    });
    if (mounted) AppDialogs.success(context, active ? 'Account activated' : 'Account deactivated');
  }

  Widget _stat(BuildContext context, String value, String label) {
    return Column(children: [
      Text(value, style: Theme.of(context).textTheme.titleMedium),
      Text(label, style: Theme.of(context).textTheme.bodySmall),
    ]);
  }

  Widget _row(BuildContext context, IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 18, color: AppColors.grey500),
          const SizedBox(width: AppSpacing.sm),
          Expanded(child: Text(label, style: Theme.of(context).textTheme.bodyMedium)),
          Text(value, style: Theme.of(context).textTheme.titleSmall),
        ],
      ),
    );
  }
}
