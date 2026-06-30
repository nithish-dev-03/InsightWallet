import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/shared/widgets/glass_card.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/validators.dart';
import '../../data/datasources/auth_datasource.dart';
import '../../../../core/services/api_service.dart';
import '../../../../core/services/storage_service.dart';

final _resetLoadingProvider = StateProvider<bool>((_) => false);

class ResetPasswordScreen extends ConsumerStatefulWidget {
  final String token;

  const ResetPasswordScreen({super.key, required this.token});

  @override
  ConsumerState<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends ConsumerState<ResetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirm = true;
  bool _success = false;

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;
    ref.read(_resetLoadingProvider.notifier).state = true;
    try {
      final storage = StorageService();
      final api = ApiService(storage);
      final dataSource = AuthDataSource(api);
      await dataSource.resetPassword(widget.token, _passwordController.text);
      setState(() => _success = true);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString().replaceFirst('Exception: ', '')),
          ),
        );
      }
    } finally {
      ref.read(_resetLoadingProvider.notifier).state = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final loading = ref.watch(_resetLoadingProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(Insets.lg),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: Insets.xl),
                IconButton(
                  icon: const Icon(Icons.arrow_back_rounded),
                  onPressed: () => context.pop(),
                ),
                const SizedBox(height: Insets.lg),
                Text(
                  'Reset password',
                  style: AppTypography.displayLgMobile.copyWith(color: AppColors.onSurface),
                ),
                const SizedBox(height: Insets.sm),
                Text(
                  'Enter your new password below.',
                  style: AppTypography.bodyMd.copyWith(color: AppColors.onSurfaceVariant),
                ),
                const SizedBox(height: Insets.xl),
                if (_success)
                  GlassCard(
                    child: Column(
                      children: [
                        const Icon(
                          Icons.check_circle_outline_rounded,
                          size: 64,
                          color: AppColors.success,
                        ),
                        const SizedBox(height: Insets.md),
                        Text(
                          'Password reset successful',
                          style: AppTypography.headlineSm.copyWith(color: AppColors.onSurface),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: Insets.lg),
                        SizedBox(
                          width: double.infinity,
                          child: FilledButton(
                            onPressed: () => context.go('/auth/login'),
                            style: FilledButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: AppRadius.brMd,
                              ),
                            ),
                            child: const Text('Back to Sign In'),
                          ),
                        ),
                      ],
                    ),
                  )
                else ...[
                  GlassCard(
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _passwordController,
                          obscureText: _obscurePassword,
                          textInputAction: TextInputAction.next,
                          validator: Validators.password,
                          decoration: InputDecoration(
                            labelText: 'New Password',
                            prefixIcon: const Icon(Icons.lock_outlined),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscurePassword
                                    ? Icons.visibility_outlined
                                    : Icons.visibility_off_outlined,
                              ),
                              onPressed: () =>
                                  setState(() => _obscurePassword = !_obscurePassword),
                            ),
                          ),
                        ),
                        const SizedBox(height: Insets.md),
                        TextFormField(
                          controller: _confirmController,
                          obscureText: _obscureConfirm,
                          textInputAction: TextInputAction.done,
                          validator: (v) =>
                              Validators.confirmPassword(v, _passwordController.text),
                          decoration: InputDecoration(
                            labelText: 'Confirm Password',
                            prefixIcon: const Icon(Icons.lock_outlined),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscureConfirm
                                    ? Icons.visibility_outlined
                                    : Icons.visibility_off_outlined,
                              ),
                              onPressed: () =>
                                  setState(() => _obscureConfirm = !_obscureConfirm),
                            ),
                          ),
                          onFieldSubmitted: (_) => _handleSubmit(),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: Insets.lg),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: loading ? null : _handleSubmit,
                      style: FilledButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: AppRadius.brMd,
                        ),
                      ),
                      child: loading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Text('Reset Password'),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
