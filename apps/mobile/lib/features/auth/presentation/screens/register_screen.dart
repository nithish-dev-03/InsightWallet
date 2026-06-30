import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_assets.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/router/app_router.dart';
import '../providers/auth_provider.dart';
import '../widgets/auth_widgets.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _agreeToTerms = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleRegister() {
    if (!_formKey.currentState!.validate()) return;
    if (!_agreeToTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('You must agree to the Terms of Service & Privacy Policy'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }
    ref.read(authProvider.notifier).register(
      _nameController.text.trim(),
      _emailController.text.trim(),
      _passwordController.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    // Exact colors from Stitch Design based on theme
    final bgColor = isDark ? const Color(0xFF15121b) : const Color(0xFFFCF8FF);
    final onSurface = isDark ? const Color(0xFFE8DFEE) : const Color(0xFF1B1B24);
    final onSurfaceVariant = isDark ? const Color(0xFFCCC3D8) : const Color(0xFF464555);
    final outlineVariant = isDark ? const Color(0xFF4A4455) : const Color(0xFFC7C4D8);
    final primary = isDark ? const Color(0xFFD2BBFF) : const Color(0xFF3525CD);
    final onPrimary = isDark ? const Color(0xFF3F008E) : const Color(0xFFFFFFFF);
    final surfaceContainerLow = isDark ? const Color(0xFF1D1A24) : const Color(0xFFF5F2FF);
    
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
        authenticated: (_) {
          AppRouter.setAuthenticated(true);
          context.go('/dashboard');
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
                            (isDark ? const Color(0xFF7C3AED) : const Color(0xFF4648D4))
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
                keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 420),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const SizedBox(height: 16),
                        
                        // Brand Identity (Logo + Create Title)
                        Column(
                          children: [
                            // Glass Container for Logo (Light theme uses border/shadow)
                            Container(
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                color: isDark 
                                    ? Colors.transparent 
                                    : const Color(0xFF1B1B24), // bg-inverse-surface
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: isDark ? null : [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.05),
                                    blurRadius: 10,
                                    offset: const Offset(0, 4),
                                  )
                                ],
                              ),
                              padding: const EdgeInsets.all(12),
                              child: Image.asset(
                                AppAssets.logoOf(isDark),
                                fit: BoxFit.contain,
                              ),
                            ),
                            const SizedBox(height: 24),
                            Text(
                              'Create your account',
                              style: AppTypography.displayLgMobile.copyWith(
                                color: onSurface,
                                fontSize: 32,
                                fontWeight: FontWeight.w700,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Join InsightWallet to track smarter and spend wiser',
                              style: AppTypography.bodyMd.copyWith(
                                color: onSurfaceVariant,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                        
                        const SizedBox(height: 32),

                        // Register Card Form
                        GlassPanel(
                          borderRadius: BorderRadius.circular(24),
                          color: cardBgColor,
                          border: Border.all(color: cardBorderColor),
                          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                // Full Name Label & Input
                                Text(
                                  isDark ? 'Full Name' : 'FULL NAME',
                                  style: AppTypography.labelMd.copyWith(
                                    color: onSurfaceVariant,
                                    fontSize: 12,
                                    fontWeight: isDark ? FontWeight.w500 : FontWeight.w600,
                                    letterSpacing: 0.6,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                TextFormField(
                                  controller: _nameController,
                                  keyboardType: TextInputType.name,
                                  textInputAction: TextInputAction.next,
                                  style: AppTypography.bodyMd.copyWith(color: onSurface),
                                  validator: (val) {
                                    if (val == null || val.trim().isEmpty) {
                                      return 'Please enter your name';
                                    }
                                    return null;
                                  },
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: surfaceContainerLow,
                                    hintText: 'Enter your full name',
                                    hintStyle: AppTypography.bodyMd.copyWith(
                                      color: onSurfaceVariant.withValues(alpha: 0.5),
                                    ),
                                    prefixIcon: Icon(
                                      Icons.person_outline,
                                      color: onSurfaceVariant.withValues(alpha: 0.7),
                                    ),
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 16,
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide: BorderSide(color: outlineVariant),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide: BorderSide(color: outlineVariant),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide: BorderSide(color: primary, width: isDark ? 1 : 2),
                                    ),
                                  ),
                                ),

                                const SizedBox(height: 20),

                                // Email Label & Input
                                Text(
                                  isDark ? 'Email Address' : 'EMAIL ADDRESS',
                                  style: AppTypography.labelMd.copyWith(
                                    color: onSurfaceVariant,
                                    fontSize: 12,
                                    fontWeight: isDark ? FontWeight.w500 : FontWeight.w600,
                                    letterSpacing: 0.6,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                TextFormField(
                                  controller: _emailController,
                                  keyboardType: TextInputType.emailAddress,
                                  textInputAction: TextInputAction.next,
                                  style: AppTypography.bodyMd.copyWith(color: onSurface),
                                  validator: Validators.email,
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: surfaceContainerLow,
                                    hintText: 'name@company.com',
                                    hintStyle: AppTypography.bodyMd.copyWith(
                                      color: onSurfaceVariant.withValues(alpha: 0.5),
                                    ),
                                    prefixIcon: Icon(
                                      Icons.mail_outline,
                                      color: onSurfaceVariant.withValues(alpha: 0.7),
                                    ),
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 16,
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide: BorderSide(color: outlineVariant),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide: BorderSide(color: outlineVariant),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide: BorderSide(color: primary, width: isDark ? 1 : 2),
                                    ),
                                  ),
                                ),
                                
                                const SizedBox(height: 20),

                                // Password Label & Input
                                Text(
                                  isDark ? 'Password' : 'PASSWORD',
                                  style: AppTypography.labelMd.copyWith(
                                    color: onSurfaceVariant,
                                    fontSize: 12,
                                    fontWeight: isDark ? FontWeight.w500 : FontWeight.w600,
                                    letterSpacing: 0.6,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                TextFormField(
                                  controller: _passwordController,
                                  obscureText: _obscurePassword,
                                  textInputAction: TextInputAction.done,
                                  style: AppTypography.bodyMd.copyWith(color: onSurface),
                                  validator: Validators.password,
                                  onFieldSubmitted: (_) => _handleRegister(),
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: surfaceContainerLow,
                                    hintText: 'At least 8 characters',
                                    hintStyle: AppTypography.bodyMd.copyWith(
                                      color: onSurfaceVariant.withValues(alpha: 0.5),
                                    ),
                                    prefixIcon: Icon(
                                      Icons.lock_outline,
                                      color: onSurfaceVariant.withValues(alpha: 0.7),
                                    ),
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        _obscurePassword
                                            ? Icons.visibility_outlined
                                            : Icons.visibility_off_outlined,
                                        color: onSurfaceVariant.withValues(alpha: 0.7),
                                      ),
                                      onPressed: () =>
                                          setState(() => _obscurePassword = !_obscurePassword),
                                    ),
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 16,
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide: BorderSide(color: outlineVariant),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide: BorderSide(color: outlineVariant),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide: BorderSide(color: primary, width: isDark ? 1 : 2),
                                    ),
                                  ),
                                ),
                                
                                const SizedBox(height: 20),

                                // Terms & Conditions Checkbox Row
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      height: 24,
                                      width: 24,
                                      child: Checkbox(
                                        value: _agreeToTerms,
                                        activeColor: primary,
                                        checkColor: onPrimary,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(4),
                                        ),
                                        side: BorderSide(color: outlineVariant),
                                        onChanged: (val) {
                                          if (val != null) {
                                            setState(() => _agreeToTerms = val);
                                          }
                                        },
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: RichText(
                                        text: TextSpan(
                                          style: AppTypography.bodySm.copyWith(
                                            color: onSurfaceVariant,
                                            fontSize: 13,
                                          ),
                                          children: [
                                            const TextSpan(text: 'I agree to the '),
                                            TextSpan(
                                              text: 'Terms of Service',
                                              style: TextStyle(
                                                color: primary,
                                                fontWeight: FontWeight.w600,
                                                decoration: TextDecoration.underline,
                                                decorationColor: primary.withValues(alpha: 0.3),
                                              ),
                                              recognizer: TapGestureRecognizer()..onTap = () {
                                                // Handle terms click
                                              },
                                            ),
                                            const TextSpan(text: ' and '),
                                            TextSpan(
                                              text: 'Privacy Policy',
                                              style: TextStyle(
                                                color: primary,
                                                fontWeight: FontWeight.w600,
                                                decoration: TextDecoration.underline,
                                                decorationColor: primary.withValues(alpha: 0.3),
                                              ),
                                              recognizer: TapGestureRecognizer()..onTap = () {
                                                // Handle privacy click
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),

                                const SizedBox(height: 32),

                                // Error Message Display
                                if (errorMsg != null) ...[
                                  Text(
                                    errorMsg,
                                    style: AppTypography.bodySm.copyWith(
                                      color: isDark ? AppColors.darkError : AppColors.lightError,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(height: 16),
                                ],

                                // Create Account Button
                                InteractiveButton(
                                  onTap: isLoading ? () {} : _handleRegister,
                                  child: Container(
                                    height: 56,
                                    decoration: BoxDecoration(
                                      color: primary,
                                      borderRadius: BorderRadius.circular(8),
                                      boxShadow: isDark ? [
                                        BoxShadow(
                                          color: primary.withValues(alpha: 0.3),
                                          blurRadius: 20,
                                          offset: const Offset(0, 4),
                                        )
                                      ] : [
                                        BoxShadow(
                                          color: primary.withValues(alpha: 0.2),
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
                                            isDark ? 'Create Account' : 'CREATE ACCOUNT',
                                            style: AppTypography.headlineSm.copyWith(
                                              color: onPrimary,
                                              fontSize: isDark ? 18 : 16,
                                              fontWeight: FontWeight.w600,
                                              letterSpacing: isDark ? 0.0 : 0.8,
                                            ),
                                          ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        
                        const SizedBox(height: 24),

                        // Already have an account? Sign In Link
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Already have an account? ",
                              style: AppTypography.bodySm.copyWith(color: onSurfaceVariant),
                            ),
                            GestureDetector(
                              onTap: () => context.pop(),
                              child: Text(
                                'Sign In',
                                style: AppTypography.bodySm.copyWith(
                                  color: primary,
                                  fontWeight: FontWeight.w700,
                                  decoration: TextDecoration.underline,
                                  decorationColor: primary.withValues(alpha: 0.3),
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
                            const SizedBox(height: 16),
                            Text(
                              isDark 
                                  ? '© Developed by Nirmal Sing Nithish' 
                                  : '@ DEVELOPED BY NIRMAL SING NITHISH',
                              style: AppTypography.bodySm.copyWith(
                                color: onSurfaceVariant.withValues(alpha: 0.5),
                                fontSize: 10,
                                fontWeight: isDark ? FontWeight.normal : FontWeight.bold,
                                letterSpacing: isDark ? 0.0 : 1.0,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
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
