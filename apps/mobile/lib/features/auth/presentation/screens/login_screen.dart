import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:local_auth/local_auth.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_assets.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/router/app_router.dart';
import '../providers/auth_provider.dart';
import '../widgets/auth_widgets.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _biometricAvailable = false;

  @override
  void initState() {
    super.initState();
    _checkBiometrics();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _checkBiometrics() async {
    if (mounted) {
      // setState(() => _biometricAvailable = available);
      setState(() => _biometricAvailable = false);
    }
  }

  Future<void> _handleBiometricLogin() async {
    final auth = LocalAuthentication();
    try {
      final authenticated = await auth.authenticate(
        localizedReason: 'Sign in to InsightWallet',
      );
      if (authenticated && mounted) {
        ref.read(authProvider.notifier).checkAuth();
      }
    } catch (_) {}
  }

  void _handleLogin() {
    if (!_formKey.currentState!.validate()) return;
    ref.read(authProvider.notifier).login(
          _emailController.text.trim(),
          _passwordController.text,
        );
    // AppRouter.setAuthenticated(true);
    // context.replace('/dashboard');
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Exact colors from Stitch Design based on theme
    final bgColor = isDark ? const Color(0xFF0B1120) : const Color(0xFFFCF8FF);
    final onSurface =
        isDark ? const Color(0xFFE8DFEE) : const Color(0xFF1B1B24);
    final onSurfaceVariant =
        isDark ? const Color(0xFFCCC3D8) : const Color(0xFF464555);
    final outlineVariant =
        isDark ? const Color(0xFF4A4455) : const Color(0xFFC7C4D8);
    final primary = isDark ? const Color(0xFFD2BBFF) : const Color(0xFF3525CD);
    final onPrimary =
        isDark ? const Color(0xFF3F008E) : const Color(0xFFFFFFFF);
    final surfaceContainerLow =
        isDark ? const Color(0xFF1D1A24) : const Color(0xFFF5F2FF);

    // Card styling
    final cardBgColor = isDark
        ? const Color(0xFF1E293B).withValues(alpha: 0.6)
        : Colors.white.withValues(alpha: 0.8);
    final cardBorderColor = isDark
        ? Colors.white.withValues(alpha: 0.08)
        : const Color(0xFFE2E8F0).withValues(alpha: 0.8);

    final authState = ref.watch(authProvider);
    final isLoading = authState.whenOrNull(loading: () => true) ?? false;
    final errorMsg = authState.whenOrNull(error: (m) => m);

    // Listen for authentication changes
    ref.listen<AuthState>(authProvider, (_, state) {
      state.whenOrNull(
        authenticated: (user) {
          AppRouter.setAuthenticated(true);
          print("Auth testing ${user.name.isEmpty}");
          if (user.name.isEmpty) {
            // AppRouter.setNeedsProfileSetup(true);
            context.go('/auth/profile-setup');
          } else {
            // AppRouter.setNeedsProfileSetup(false);
            context.go('/dashboard');
          }
          // context.go('/dashboard');
        },
      );
    });

    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: bgColor,
      body: Stack(
        children: [
          // 1. Decorative Animated/Glow Background
          Positioned.fill(
            child: OverflowBox(
              maxWidth: size.width * 1.5,
              maxHeight: size.height * 1.5,
              child: Stack(
                children: [
                  // Top-Left Blob
                  Positioned(
                    top: -100,
                    left: -100,
                    child: Container(
                      width: 450,
                      height: 450,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            primary.withValues(alpha: isDark ? 0.15 : 0.08),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                  ),
                  // Bottom-Right Blob
                  Positioned(
                    bottom: -100,
                    right: -100,
                    child: Container(
                      width: 400,
                      height: 400,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            (isDark
                                    ? const Color(0xFF7C3AED)
                                    : const Color(0xFF4648D4))
                                .withValues(alpha: isDark ? 0.12 : 0.06),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // 2. Main Scrollable Content
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 24.0, vertical: 32.0),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 420),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const SizedBox(height: 16),

                        // Brand Identity (Logo + Welcome Title)
                        Column(
                          children: [
                            // Glass Container for Logo (Light theme uses border/shadow)
                            Container(
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                color: isDark
                                    ? Colors.transparent
                                    : const Color(
                                        0xFF1B1B24), // bg-inverse-surface
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: isDark
                                    ? null
                                    : [
                                        BoxShadow(
                                          color: Colors.black
                                              .withValues(alpha: 0.05),
                                          blurRadius: 10,
                                          offset: const Offset(0, 4),
                                        )
                                      ],
                              ),
                              padding: const EdgeInsets.all(12),
                              child: Image.asset(
                                AppAssets.logoOf(true),
                                fit: BoxFit.contain,
                              ),
                            ),
                            const SizedBox(height: 24),
                            Text(
                              'Welcome Back',
                              style: AppTypography.displayLgMobile.copyWith(
                                color: onSurface,
                                fontSize: 36,
                                fontWeight: FontWeight.w700,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Secure access to your intelligent finance dashboard',
                              style: AppTypography.bodyMd.copyWith(
                                color: onSurfaceVariant,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),

                        const SizedBox(height: 32),

                        // Login Card Form
                        GlassPanel(
                          borderRadius: BorderRadius.circular(24),
                          color: cardBgColor,
                          border: Border.all(color: cardBorderColor),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 24.0, vertical: 32.0),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                // Username Label & Input
                                Text(
                                  isDark ? 'Username' : 'USERNAME',
                                  style: AppTypography.labelMd.copyWith(
                                    color: onSurfaceVariant,
                                    fontSize: 12,
                                    fontWeight: isDark
                                        ? FontWeight.w500
                                        : FontWeight.w600,
                                    letterSpacing: 0.6,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                TextFormField(
                                  controller: _emailController,
                                  keyboardType: TextInputType.emailAddress,
                                  textInputAction: TextInputAction.next,
                                  style: AppTypography.bodyMd
                                      .copyWith(color: onSurface),
                                  validator: Validators.email,
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: surfaceContainerLow,
                                    hintText: 'name@company.com',
                                    hintStyle: AppTypography.bodyMd.copyWith(
                                      color: onSurfaceVariant.withValues(
                                          alpha: 0.5),
                                    ),
                                    prefixIcon: Icon(
                                      Icons.person_outline,
                                      color: onSurfaceVariant.withValues(
                                          alpha: 0.7),
                                    ),
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 16,
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide:
                                          BorderSide(color: outlineVariant),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide:
                                          BorderSide(color: outlineVariant),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide: BorderSide(
                                          color: primary,
                                          width: isDark ? 1 : 2),
                                    ),
                                  ),
                                ),

                                const SizedBox(height: 24),

                                // Password Label & Forgot Password Link
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      isDark ? 'Password' : 'PASSWORD',
                                      style: AppTypography.labelMd.copyWith(
                                        color: onSurfaceVariant,
                                        fontSize: 12,
                                        fontWeight: isDark
                                            ? FontWeight.w500
                                            : FontWeight.w600,
                                        letterSpacing: 0.6,
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () =>
                                          context.push('/auth/forgot-password'),
                                      child: Text(
                                        'Forgot Password?',
                                        style: AppTypography.labelMd.copyWith(
                                          color: primary,
                                          fontSize: 12,
                                          fontWeight: isDark
                                              ? FontWeight.w500
                                              : FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                TextFormField(
                                  controller: _passwordController,
                                  obscureText: _obscurePassword,
                                  textInputAction: TextInputAction.done,
                                  style: AppTypography.bodyMd
                                      .copyWith(color: onSurface),
                                  validator: Validators.password,
                                  onFieldSubmitted: (_) => _handleLogin(),
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: surfaceContainerLow,
                                    hintText: '••••••••',
                                    hintStyle: AppTypography.bodyMd.copyWith(
                                      color: onSurfaceVariant.withValues(
                                          alpha: 0.5),
                                    ),
                                    prefixIcon: Icon(
                                      Icons.lock_outline,
                                      color: onSurfaceVariant.withValues(
                                          alpha: 0.7),
                                    ),
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        _obscurePassword
                                            ? Icons.visibility_outlined
                                            : Icons.visibility_off_outlined,
                                        color: onSurfaceVariant.withValues(
                                            alpha: 0.7),
                                      ),
                                      onPressed: () => setState(() =>
                                          _obscurePassword = !_obscurePassword),
                                    ),
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 16,
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide:
                                          BorderSide(color: outlineVariant),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide:
                                          BorderSide(color: outlineVariant),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide: BorderSide(
                                          color: primary,
                                          width: isDark ? 1 : 2),
                                    ),
                                  ),
                                ),

                                const SizedBox(height: 32),

                                // Error Message Display
                                if (errorMsg != null) ...[
                                  Text(
                                    errorMsg,
                                    style: AppTypography.bodySm.copyWith(
                                      color: isDark
                                          ? AppColors.darkError
                                          : AppColors.lightError,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(height: 16),
                                ],

                                // Sign In Button
                                InteractiveButton(
                                  onTap: isLoading ? () {} : _handleLogin,
                                  child: Container(
                                    height: 56,
                                    decoration: BoxDecoration(
                                      color: primary,
                                      borderRadius: BorderRadius.circular(8),
                                      boxShadow: isDark
                                          ? [
                                              BoxShadow(
                                                color: primary.withValues(
                                                    alpha: 0.3),
                                                blurRadius: 20,
                                                offset: const Offset(0, 4),
                                              )
                                            ]
                                          : [
                                              BoxShadow(
                                                color: primary.withValues(
                                                    alpha: 0.2),
                                                blurRadius: 15,
                                                offset: const Offset(0, 10),
                                              )
                                            ],
                                    ),
                                    alignment: Alignment.center,
                                    child: isLoading
                                        ? SizedBox(
                                            width: 20,
                                            height: 20,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                              color: onPrimary,
                                            ),
                                          )
                                        : Text(
                                            'Sign In',
                                            style: AppTypography.headlineSm
                                                .copyWith(
                                              color: onPrimary,
                                              fontSize: isDark ? 20 : 16,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                  ),
                                ),

                                // Biometrics Integration (Dynamic)
                                if (_biometricAvailable) ...[
                                  const SizedBox(height: 16),
                                  OutlinedButton.icon(
                                    onPressed: isLoading
                                        ? null
                                        : _handleBiometricLogin,
                                    icon: const Icon(Icons.fingerprint),
                                    label:
                                        const Text('Sign in with Biometrics'),
                                    style: OutlinedButton.styleFrom(
                                      foregroundColor: onSurface,
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 16),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      side: BorderSide(
                                        color: isDark
                                            ? AppColors.darkOutline
                                            : AppColors.lightOutline,
                                      ),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: 24),

                        // Create Account Link
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Don't have an account? ",
                              style: AppTypography.bodySm
                                  .copyWith(color: onSurfaceVariant),
                            ),
                            GestureDetector(
                              onTap: () => context.push('/auth/register'),
                              child: Text(
                                'Create an Account',
                                style: AppTypography.bodySm.copyWith(
                                  color: primary,
                                  fontWeight: FontWeight.w600,
                                  decoration: TextDecoration.underline,
                                  decorationColor:
                                      primary.withValues(alpha: 0.3),
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 48),

                        // Footer (Privacy Policy, Terms of Service, Security)
                        Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                FooterLink(
                                  text: 'Privacy Policy',
                                  color: onSurfaceVariant,
                                  hoverColor: primary,
                                  onTap: () {},
                                ),
                                FooterDivider(color: onSurfaceVariant),
                                FooterLink(
                                  text: 'Terms of Service',
                                  color: onSurfaceVariant,
                                  hoverColor: primary,
                                  onTap: () {},
                                ),
                                FooterDivider(color: onSurfaceVariant),
                                FooterLink(
                                  text: 'Security',
                                  color: onSurfaceVariant,
                                  hoverColor: primary,
                                  onTap: () {},
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '© Developed by Nirmal Sing Nithish',
                              style: AppTypography.labelMd.copyWith(
                                color: onSurfaceVariant.withValues(alpha: 0.6),
                                fontSize: 10,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
