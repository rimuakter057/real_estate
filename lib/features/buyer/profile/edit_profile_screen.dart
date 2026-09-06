import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_dialogs.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/avatar.dart';
import '../../../shared/mock_data/mock_users.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late final _name = TextEditingController(text: MockUsers.buyer.name);
  late final _email = TextEditingController(text: MockUsers.buyer.email);
  late final _phone = TextEditingController(text: MockUsers.buyer.phone);
  late final _city = TextEditingController(text: MockUsers.buyer.city);
  late final _bio = TextEditingController(text: MockUsers.buyer.bio);
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
                  AppAvatar(imageUrl: MockUsers.buyer.avatarUrl, size: 96),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Material(
                      color: AppColors.accent,
                      shape: const CircleBorder(),
                      child: InkWell(
                        customBorder: const CircleBorder(),
                        onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Photo upload (demo)')),
                        ),
                        child: const Padding(
                          padding: EdgeInsets.all(8),
                          child: Icon(Icons.camera_alt_rounded, color: Colors.white, size: 18),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  AppTextField(label: 'Full Name', controller: _name, prefixIcon: Icons.person_outline_rounded),
                  const SizedBox(height: AppSpacing.md),
                  AppTextField(label: 'Email', controller: _email, prefixIcon: Icons.mail_outline_rounded, keyboardType: TextInputType.emailAddress),
                  const SizedBox(height: AppSpacing.md),
                  AppTextField(label: 'Phone', controller: _phone, prefixIcon: Icons.phone_outlined, keyboardType: TextInputType.phone),
                  const SizedBox(height: AppSpacing.md),
                  AppTextField(label: 'City', controller: _city, prefixIcon: Icons.location_on_outlined),
                  const SizedBox(height: AppSpacing.md),
                  AppTextField(label: 'About Me', controller: _bio, maxLines: 3),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            PrimaryButton(
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
          ],
        ),
      ),
    );
  }
}
