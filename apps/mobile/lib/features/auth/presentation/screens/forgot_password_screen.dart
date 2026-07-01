import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_assets.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/validators.dart';
import '../../data/datasources/auth_datasource.dart';
import '../../../../core/services/api_service.dart';
import '../../../../core/services/storage_service.dart';
import '../widgets/auth_widgets.dart';

final _forgotPasswordProvider = StateProvider<bool>((_) => false);
final _forgotLoadingProvider = StateProvider<bool>((_) => false);

class ForgotPasswordScreen extends ConsumerStatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  ConsumerState<ForgotPasswordScreen> createState() =>
      _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;
    ref.read(_forgotLoadingProvider.notifier).state = true;
    try {
      final storage = StorageService();
      final api = ApiService(storage);
      final dataSource = AuthDataSource(api);
      await dataSource.forgotPassword(_emailController.text.trim());
      ref.read(_forgotPasswordProvider.notifier).state = true;
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString().replaceFirst('Exception: ', '')),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      ref.read(_forgotLoadingProvider.notifier).state = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final sent = ref.watch(_forgotPasswordProvider);
    final loading = ref.watch(_forgotLoadingProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Stitch design system tokens
    final bgColor = isDark ? const Color(0xFF15121B) : const Color(0xFFFCF8FF);
    final surfaceColor =
        isDark ? const Color(0xFF221E28) : const Color(0xFFF0ECF9);
    final onSurface =
        isDark ? const Color(0xFFE8DFEE) : const Color(0xFF1B1B24);
    final onSurfaceVariant =
        isDark ? const Color(0xFFCCC3D8) : const Color(0xFF464555);
    final primary = isDark ? const Color(0xFFD2BBFF) : const Color(0xFF3525CD);
    final onPrimary =
        isDark ? const Color(0xFF3F008E) : const Color(0xFFFFFFFF);
    final outlineVariant =
        isDark ? const Color(0xFF4A4455) : const Color(0xFFC7C4D8);
    final surfaceContainerLow =
        isDark ? const Color(0xFF1D1A24) : const Color(0xFFF5F2FF);

    final cardBgColor = isDark
        ? const Color(0xFF1E293B).withValues(alpha: 0.6)
        : Colors.white.withValues(alpha: 0.8);
    final cardBorderColor = isDark
        ? Colors.white.withValues(alpha: 0.08)
        : const Color(0xFFE2E8F0).withValues(alpha: 0.8);

    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: bgColor,
      body: Stack(
        children: [
          // 1. Premium Radial Background Glow
          Positioned.fill(
            child: OverflowBox(
              maxWidth: size.width * 1.5,
              maxHeight: size.height * 1.5,
              child: Stack(
                children: [
                  // Top-Left Blur Blob
                  Positioned(
                    top: -120,
                    left: -120,
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
                  // Bottom-Right Blur Blob
                  Positioned(
                    bottom: -120,
                    right: -120,
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

          // 2. Scrollable Core Content
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
                        // Back Icon Button on top left
                        Align(
                          alignment: Alignment.centerLeft,
                          child: IconButton(
                            icon: Icon(
                              Icons.arrow_back_rounded,
                              color: onSurface,
                            ),
                            onPressed: () => context.pop(),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Logo Container
                        Center(
                          child: Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              color: isDark
                                  ? Colors.transparent
                                  : const Color(
                                      0xFF1B1B24), // Inverse surface for high-contrast light mode logo
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
                              AppAssets.logoOf(isDark),
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Heading Title & Subtitle
                        Text(
                          'Forgot Password',
                          style: AppTypography.displayLgMobile.copyWith(
                            color: onSurface,
                            fontSize: 32,
                            fontWeight: FontWeight.w700,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          "Enter your email address and we'll send you a link to reset your password.",
                          style: AppTypography.bodyMd.copyWith(
                            color: onSurfaceVariant,
                            height: 1.4,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 32),

                        // Main Card Form (Glass Panel)
                        GlassPanel(
                          borderRadius: BorderRadius.circular(24),
                          color: cardBgColor,
                          border: Border.all(color: cardBorderColor),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 24.0, vertical: 32.0),
                          child: sent
                              ? Column(
                                  children: [
                                    const Icon(
                                      Icons.check_circle_outline_rounded,
                                      size: 64,
                                      color: AppColors.success,
                                    ),
                                    const SizedBox(height: 16),
                                    Text(
                                      'Check your email',
                                      style: AppTypography.headlineSm.copyWith(
                                        color: onSurface,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      "We've sent a password reset link to your email.",
                                      style: AppTypography.bodyMd.copyWith(
                                        color: onSurfaceVariant,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    const SizedBox(height: 32),
                                    InteractiveButton(
                                      onTap: () {
                                        ref
                                            .read(_forgotPasswordProvider
                                                .notifier)
                                            .state = false;
                                        _emailController.clear();
                                      },
                                      child: Container(
                                        height: 56,
                                        decoration: BoxDecoration(
                                          color: primary,
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        alignment: Alignment.center,
                                        child: Text(
                                          isDark
                                              ? 'Send Another Email'
                                              : 'SEND ANOTHER EMAIL',
                                          style:
                                              AppTypography.headlineSm.copyWith(
                                            color: onPrimary,
                                            fontSize: isDark ? 18 : 16,
                                            fontWeight: FontWeight.w600,
                                            letterSpacing: isDark ? 0.0 : 0.8,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              : Form(
                                  key: _formKey,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      // Email Field Label
                                      Text(
                                        isDark
                                            ? 'Email Address'
                                            : 'EMAIL ADDRESS',
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

                                      // Email Input
                                      TextFormField(
                                        controller: _emailController,
                                        keyboardType:
                                            TextInputType.emailAddress,
                                        textInputAction: TextInputAction.done,
                                        style: AppTypography.bodyMd
                                            .copyWith(color: onSurface),
                                        validator: Validators.email,
                                        onFieldSubmitted: (_) =>
                                            _handleSubmit(),
                                        decoration: InputDecoration(
                                          filled: true,
                                          fillColor: surfaceContainerLow,
                                          hintText: 'name@example.com',
                                          hintStyle:
                                              AppTypography.bodyMd.copyWith(
                                            color: onSurfaceVariant.withValues(
                                                alpha: 0.5),
                                          ),
                                          prefixIcon: Icon(
                                            Icons.email_outlined,
                                            color: onSurfaceVariant.withValues(
                                                alpha: 0.7),
                                          ),
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                            horizontal: 16,
                                            vertical: 16,
                                          ),
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            borderSide: BorderSide(
                                                color: outlineVariant),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            borderSide: BorderSide(
                                                color: outlineVariant),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            borderSide: BorderSide(
                                                color: primary,
                                                width: isDark ? 1 : 2),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 24),

                                      // Submit Button with Right Arrow icon
                                      InteractiveButton(
                                        onTap: loading ? () {} : _handleSubmit,
                                        child: Container(
                                          height: 56,
                                          decoration: BoxDecoration(
                                            color: primary,
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            boxShadow: isDark
                                                ? [
                                                    BoxShadow(
                                                      color: primary.withValues(
                                                          alpha: 0.3),
                                                      blurRadius: 20,
                                                      offset:
                                                          const Offset(0, 4),
                                                    )
                                                  ]
                                                : [
                                                    BoxShadow(
                                                      color: primary.withValues(
                                                          alpha: 0.2),
                                                      blurRadius: 15,
                                                      offset:
                                                          const Offset(0, 10),
                                                    )
                                                  ],
                                          ),
                                          alignment: Alignment.center,
                                          child: loading
                                              ? SizedBox(
                                                  width: 20,
                                                  height: 20,
                                                  child:
                                                      CircularProgressIndicator(
                                                    strokeWidth: 2,
                                                    color: onPrimary,
                                                  ),
                                                )
                                              : Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      isDark
                                                          ? 'Send Reset Link'
                                                          : 'SEND RESET LINK',
                                                      style: AppTypography
                                                          .headlineSm
                                                          .copyWith(
                                                        color: onPrimary,
                                                        fontSize:
                                                            isDark ? 18 : 16,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        letterSpacing:
                                                            isDark ? 0.0 : 0.8,
                                                      ),
                                                    ),
                                                    const SizedBox(width: 8),
                                                    Icon(
                                                      Icons.arrow_forward,
                                                      color: onPrimary,
                                                      size: 18,
                                                    ),
                                                  ],
                                                ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                        ),
                        const SizedBox(height: 24),

                        // Back to Sign In Link below Card
                        Center(
                          child: GestureDetector(
                            onTap: () => context.pop(),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  isDark
                                      ? Icons.chevron_left
                                      : Icons.arrow_back,
                                  color: primary,
                                  size: 18,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  'Back to Sign In',
                                  style: AppTypography.bodySm.copyWith(
                                    color: primary,
                                    fontWeight: FontWeight.w700,
                                    decoration: TextDecoration.underline,
                                    decorationColor:
                                        primary.withValues(alpha: 0.3),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 48),

                        // Footer links & Credit
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
                                if (!isDark) ...[
                                  FooterDivider(color: onSurfaceVariant),
                                  FooterLink(
                                    text: 'Security',
                                    color: onSurfaceVariant,
                                    hoverColor: primary,
                                    onTap: () {},
                                  ),
                                ],
                              ],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              isDark
                                  ? 'developed by Nirmal Sing Nithish'
                                  : 'DEVELOPED BY NIRMAL SING NITHISH',
                              style: AppTypography.bodySm.copyWith(
                                color: onSurfaceVariant.withValues(alpha: 0.5),
                                fontSize: 10,
                                fontWeight: isDark
                                    ? FontWeight.normal
                                    : FontWeight.bold,
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
