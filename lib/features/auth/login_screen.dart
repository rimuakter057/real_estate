import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/routing/route_paths.dart';
import '../../core/state/app_session.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/app_text_field.dart';
import '../../shared/models/user_model.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController(text: 'james.whitfield@gmail.com');
  final _passwordController = TextEditingController(text: 'password123');
  UserRole _selectedRole = UserRole.buyer;
  bool _loading = false;

  void _login() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    await Future.delayed(const Duration(milliseconds: 700));
    if (!mounted) return;
    setState(() => _loading = false);
    AppSession.instance.signIn(_selectedRole);
    switch (_selectedRole) {
      case UserRole.buyer:
        context.go(RoutePaths.buyerHome);
      case UserRole.owner:
        context.go(RoutePaths.ownerDashboard);
      case UserRole.admin:
        context.go(RoutePaths.adminDashboard);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: AppSpacing.xl),
                Container(
                  height: 56,
                  width: 56,
                  decoration: BoxDecoration(color: AppColors.accent, borderRadius: BorderRadius.circular(16)),
                  child: const Icon(Icons.home_work_rounded, color: Colors.white, size: 28),
                ),
                const SizedBox(height: AppSpacing.lg),
                Text('Welcome back', style: Theme.of(context).textTheme.displayMedium),
                const SizedBox(height: AppSpacing.xs),
                Text('Sign in to continue exploring properties', style: Theme.of(context).textTheme.bodyMedium),
                const SizedBox(height: AppSpacing.xl),
                Text('Continue as', style: Theme.of(context).textTheme.labelLarge),
                const SizedBox(height: AppSpacing.sm),
                Row(
                  children: [
                    _RoleTile(
                      label: 'Buyer',
                      icon: Icons.search_rounded,
                      selected: _selectedRole == UserRole.buyer,
                      onTap: () => setState(() => _selectedRole = UserRole.buyer),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    _RoleTile(
                      label: 'Owner/Agent',
                      icon: Icons.apartment_rounded,
                      selected: _selectedRole == UserRole.owner,
                      onTap: () => setState(() => _selectedRole = UserRole.owner),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    _RoleTile(
                      label: 'Admin',
                      icon: Icons.admin_panel_settings_rounded,
                      selected: _selectedRole == UserRole.admin,
                      onTap: () => setState(() => _selectedRole = UserRole.admin),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.xl),
                AppTextField(
                  label: 'Email',
                  controller: _emailController,
                  hint: 'you@example.com',
                  prefixIcon: Icons.mail_outline_rounded,
                  keyboardType: TextInputType.emailAddress,
                  validator: (v) => (v == null || !v.contains('@')) ? 'Enter a valid email' : null,
                ),
                const SizedBox(height: AppSpacing.md),
                AppTextField(
                  label: 'Password',
                  controller: _passwordController,
                  hint: 'Enter your password',
                  prefixIcon: Icons.lock_outline_rounded,
                  obscureText: true,
                  validator: (v) => (v == null || v.length < 6) ? 'Minimum 6 characters' : null,
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () => context.push(RoutePaths.forgotPassword),
                    child: const Text('Forgot Password?'),
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                PrimaryButton(label: 'Sign In', loading: _loading, onPressed: _login),
                const SizedBox(height: AppSpacing.lg),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Don't have an account?", style: Theme.of(context).textTheme.bodyMedium),
                    TextButton(
                      onPressed: () => context.push(RoutePaths.register),
                      child: const Text('Register'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _RoleTile extends StatelessWidget {
  const _RoleTile({required this.label, required this.icon, required this.selected, required this.onTap});
  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.md, horizontal: 4),
          decoration: BoxDecoration(
            color: selected ? AppColors.accentLight : AppColors.lightSurfaceAlt,
            borderRadius: BorderRadius.circular(AppRadius.md),
            border: Border.all(color: selected ? AppColors.accent : Colors.transparent, width: 1.4),
          ),
          child: Column(
            children: [
              Icon(icon, color: selected ? AppColors.accent : AppColors.grey500, size: 22),
              const SizedBox(height: 6),
              Text(
                label,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: selected ? AppColors.accent : AppColors.grey600,
                      fontWeight: FontWeight.w700,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
