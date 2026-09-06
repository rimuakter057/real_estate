import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_dialogs.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/avatar.dart';
import '../../../shared/mock_data/mock_agents.dart';

class OwnerEditProfileScreen extends StatefulWidget {
  const OwnerEditProfileScreen({super.key});

  @override
  State<OwnerEditProfileScreen> createState() => _OwnerEditProfileScreenState();
}

class _OwnerEditProfileScreenState extends State<OwnerEditProfileScreen> {
  late final _name = TextEditingController(text: MockAgents.me.name);
  late final _title = TextEditingController(text: MockAgents.me.title);
  late final _email = TextEditingController(text: MockAgents.me.email);
  late final _phone = TextEditingController(text: MockAgents.me.phone);
  late final _company = TextEditingController(text: MockAgents.me.company);
  late final _about = TextEditingController(text: MockAgents.me.about);
  bool _saving = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Profile')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          children: [
            Center(
              child: Stack(
                children: [
                  AppAvatar(imageUrl: MockAgents.me.avatarUrl, size: 96),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Material(
                      color: AppColors.accent,
                      shape: const CircleBorder(),
                      child: InkWell(
                        customBorder: const CircleBorder(),
                        onTap: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Photo upload (demo)'))),
                        child: const Padding(padding: EdgeInsets.all(8), child: Icon(Icons.camera_alt_rounded, color: Colors.white, size: 18)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            AppTextField(label: 'Full Name', controller: _name, prefixIcon: Icons.person_outline_rounded),
            const SizedBox(height: AppSpacing.md),
            AppTextField(label: 'Professional Title', controller: _title, prefixIcon: Icons.badge_outlined),
            const SizedBox(height: AppSpacing.md),
            AppTextField(label: 'Company', controller: _company, prefixIcon: Icons.apartment_outlined),
            const SizedBox(height: AppSpacing.md),
            AppTextField(label: 'Email', controller: _email, prefixIcon: Icons.mail_outline_rounded, keyboardType: TextInputType.emailAddress),
            const SizedBox(height: AppSpacing.md),
            AppTextField(label: 'Phone', controller: _phone, prefixIcon: Icons.phone_outlined, keyboardType: TextInputType.phone),
            const SizedBox(height: AppSpacing.md),
            AppTextField(label: 'About', controller: _about, maxLines: 4),
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
              AppDialogs.success(context, 'Profile updated successfully!');
              context.pop();
            },
          ),
        ),
      ),
    );
  }
}
