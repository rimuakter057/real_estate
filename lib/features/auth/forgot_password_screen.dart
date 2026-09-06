import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/app_text_field.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  bool _loading = false;
  bool _sent = false;

  void _sendLink() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    await Future.delayed(const Duration(milliseconds: 800));
    if (!mounted) return;
    setState(() {
      _loading = false;
      _sent = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Forgot Password')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: _sent ? _buildSuccess(context) : _buildForm(context),
        ),
      ),
    );
  }

  Widget _buildForm(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 56,
            width: 56,
            decoration: BoxDecoration(color: AppColors.accentLight, borderRadius: BorderRadius.circular(16)),
            child: const Icon(Icons.lock_reset_rounded, color: AppColors.accent, size: 28),
          ),
          const SizedBox(height: AppSpacing.lg),
          Text('Reset your password', style: Theme.of(context).textTheme.displayMedium),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'Enter the email associated with your account and we\'ll send a link to reset your password.',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: AppSpacing.xl),
          AppTextField(
            label: 'Email',
            controller: _email,
            hint: 'you@example.com',
            prefixIcon: Icons.mail_outline_rounded,
            keyboardType: TextInputType.emailAddress,
            validator: (v) => (v == null || !v.contains('@')) ? 'Enter a valid email' : null,
          ),
          const SizedBox(height: AppSpacing.xl),
          PrimaryButton(label: 'Send Reset Link', loading: _loading, onPressed: _sendLink),
        ],
      ),
    );
  }

  Widget _buildSuccess(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          height: 96,
          width: 96,
          decoration: const BoxDecoration(color: AppColors.accentLight, shape: BoxShape.circle),
          child: const Icon(Icons.mark_email_read_rounded, color: AppColors.accent, size: 42),
        ),
        const SizedBox(height: AppSpacing.lg),
        Text('Check your email', style: Theme.of(context).textTheme.headlineLarge, textAlign: TextAlign.center),
        const SizedBox(height: AppSpacing.xs),
        Text(
          'We\'ve sent a password reset link to ${_email.text}',
          style: Theme.of(context).textTheme.bodyMedium,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppSpacing.xl),
        PrimaryButton(label: 'Back to Sign In', onPressed: () => context.pop(), expand: false),
      ],
    );
  }
}
