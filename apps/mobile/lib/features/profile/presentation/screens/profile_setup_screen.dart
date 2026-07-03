import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/router/app_router.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../auth/presentation/widgets/auth_widgets.dart';
import '../../domain/entities/profile_entity.dart';
import '../providers/profile_provider.dart';

class ProfileSetupScreen extends ConsumerStatefulWidget {
  const ProfileSetupScreen({super.key});

  @override
  ConsumerState<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends ConsumerState<ProfileSetupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _titleController = TextEditingController();
  final _bioController = TextEditingController();
  final _locationController = TextEditingController();

  String _selectedCurrency = 'USD';
  String _selectedTheme = 'dark';
  bool _isSaving = false;
  String? _errorMessage;

  final List<String> _currencies = [
    'USD',
    'EUR',
    'GBP',
    'INR',
    'JPY',
    'CAD',
    'AUD'
  ]; // [{'currencyCode': 'USD', 'name': 'US Dollar', 'icon': 'icons.curreny.usd'}]
  final List<String> _themes = ['dark', 'light'];

  @override
  void dispose() {
    _nameController.dispose();
    _titleController.dispose();
    _bioController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  Future<void> _handleSave() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isSaving = true;
      _errorMessage = null;
    });

    try {
      final authState = ref.read(authProvider);
      final email = authState.maybeWhen(
        authenticated: (user) => user.email,
        orElse: () => '',
      );

      final profile = ProfileEntity(
        id: '',
        name: _nameController.text.trim(),
        email: email,
        title: _titleController.text.trim(),
        bio: _bioController.text.trim(),
        location: _locationController.text.trim(),
        currency: _selectedCurrency,
        theme: _selectedTheme,
        createdAt: DateTime.now(),
      );

      // Create the profile
      await ref.read(profileProvider.notifier).createProfile(profile);

      // Reset profile setup redirection requirements
      AppRouter.setNeedsProfileSetup(false);

      // Refresh the current authenticated user details
      await ref.read(authProvider.notifier).checkAuth();

      if (mounted) {
        context.go('/dashboard');
      }
    } catch (e) {
      setState(() {
        _errorMessage = e.toString().replaceFirst('Exception: ', '');
        _isSaving = false;
      });
    }
  }

  void _handleLogout() {
    AppRouter.setAuthenticated(false);
    AppRouter.setNeedsProfileSetup(false);
    context.go('/auth/login');
    ref.read(authProvider.notifier).logout();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final bgColor = isDark ? const Color(0xFF15121b) : const Color(0xFFFCF8FF);
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
          // 1. Radial Glow Background
          Positioned.fill(
            child: OverflowBox(
              maxWidth: size.width * 1.5,
              maxHeight: size.height * 1.5,
              child: Stack(
                children: [
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

          // 2. Form Content
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                    horizontal: 24.0, vertical: 16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Heading
                    Text(
                      'Profile Setup',
                      style: AppTypography.headlineMd.copyWith(
                        color: onSurface,
                        fontWeight: FontWeight.bold,
                        fontSize: 28,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Help us personalize your dashboard',
                      style: AppTypography.bodyMd.copyWith(
                        color: onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Glassmorphic Card
                    GlassPanel(
                      borderRadius: BorderRadius.circular(16),
                      color: cardBgColor,
                      border: Border.all(color: cardBorderColor),
                      padding: const EdgeInsets.all(24.0),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            // Full Name Input
                            _buildLabel('Full Name', onSurfaceVariant, isDark),
                            const SizedBox(height: 8),
                            TextFormField(
                              controller: _nameController,
                              keyboardType: TextInputType.name,
                              textInputAction: TextInputAction.next,
                              style: AppTypography.bodyMd
                                  .copyWith(color: onSurface),
                              validator: (val) {
                                if (val == null || val.trim().length < 2) {
                                  return 'Name must be at least 2 characters';
                                }
                                return null;
                              },
                              decoration: _buildInputDecoration(
                                  'Enter your full name',
                                  Icons.person_outline,
                                  surfaceContainerLow,
                                  outlineVariant,
                                  primary,
                                  isDark),
                            ),
                            const SizedBox(height: 20),

                            // Job Title Input
                            _buildLabel('Job Title / Occupation',
                                onSurfaceVariant, isDark),
                            const SizedBox(height: 8),
                            TextFormField(
                              controller: _titleController,
                              keyboardType: TextInputType.text,
                              textInputAction: TextInputAction.next,
                              style: AppTypography.bodyMd
                                  .copyWith(color: onSurface),
                              decoration: _buildInputDecoration(
                                  'e.g. Software Engineer',
                                  Icons.work_outline,
                                  surfaceContainerLow,
                                  outlineVariant,
                                  primary,
                                  isDark),
                            ),
                            const SizedBox(height: 20),

                            // Bio Input
                            _buildLabel('Bio / Goal', onSurfaceVariant, isDark),
                            const SizedBox(height: 8),
                            TextFormField(
                              controller: _bioController,
                              keyboardType: TextInputType.text,
                              textInputAction: TextInputAction.next,
                              maxLines: 2,
                              style: AppTypography.bodyMd
                                  .copyWith(color: onSurface),
                              decoration: _buildInputDecoration(
                                  'e.g. Saving for a house purchase',
                                  Icons.notes_outlined,
                                  surfaceContainerLow,
                                  outlineVariant,
                                  primary,
                                  isDark),
                            ),
                            const SizedBox(height: 20),

                            // Location Input
                            _buildLabel('Location', onSurfaceVariant, isDark),
                            const SizedBox(height: 8),
                            TextFormField(
                              controller: _locationController,
                              keyboardType: TextInputType.text,
                              textInputAction: TextInputAction.done,
                              style: AppTypography.bodyMd
                                  .copyWith(color: onSurface),
                              decoration: _buildInputDecoration(
                                  'e.g. New York, USA',
                                  Icons.location_on_outlined,
                                  surfaceContainerLow,
                                  outlineVariant,
                                  primary,
                                  isDark),
                            ),
                            const SizedBox(height: 20),

                            // Currency Selector & Theme Selector row
                            Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      _buildLabel(
                                          'Currency', onSurfaceVariant, isDark),
                                      const SizedBox(height: 8),
                                      DropdownButtonFormField<String>(
                                        initialValue: _selectedCurrency,
                                        isExpanded: true,
                                        dropdownColor: surfaceContainerLow,
                                        style: AppTypography.bodyMd
                                            .copyWith(color: onSurface),
                                        decoration: _buildInputDecoration(
                                          '',
                                          null,
                                          surfaceContainerLow,
                                          outlineVariant,
                                          primary,
                                          isDark,
                                          prefixWidget:
                                              _buildCurrencyPrefixIcon(
                                                  _selectedCurrency, isDark),
                                        ),
                                        selectedItemBuilder:
                                            (BuildContext context) {
                                          return _currencies
                                              .map<Widget>((String curr) {
                                            return Text(curr);
                                          }).toList();
                                        },
                                        items: _currencies
                                            .map((curr) => DropdownMenuItem(
                                                  value: curr,
                                                  child: Row(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      _buildCurrencyDropdownIcon(
                                                          curr, isDark),
                                                      const SizedBox(width: 8),
                                                      Text(curr),
                                                    ],
                                                  ),
                                                ))
                                            .toList(),
                                        onChanged: (val) {
                                          if (val != null) {
                                            setState(
                                                () => _selectedCurrency = val);
                                          }
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      _buildLabel(
                                          'Theme', onSurfaceVariant, isDark),
                                      const SizedBox(height: 8),
                                      DropdownButtonFormField<String>(
                                        initialValue: _selectedTheme,
                                        isExpanded: true,
                                        dropdownColor: surfaceContainerLow,
                                        style: AppTypography.bodyMd
                                            .copyWith(color: onSurface),
                                        decoration: _buildInputDecoration(
                                            '',
                                            Icons.palette_outlined,
                                            surfaceContainerLow,
                                            outlineVariant,
                                            primary,
                                            isDark),
                                        items: _themes
                                            .map((th) => DropdownMenuItem(
                                                  value: th,
                                                  child: Text(th.toUpperCase()),
                                                ))
                                            .toList(),
                                        onChanged: (val) {
                                          if (val != null) {
                                            setState(
                                                () => _selectedTheme = val);
                                          }
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 32),

                            // Error display
                            if (_errorMessage != null) ...[
                              Text(
                                _errorMessage!,
                                style: AppTypography.bodySm.copyWith(
                                  color: isDark
                                      ? AppColors.darkError
                                      : AppColors.lightError,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 16),
                            ],

                            // Save Button
                            InteractiveButton(
                              onTap: _isSaving ? () {} : _handleSave,
                              child: Container(
                                height: 56,
                                decoration: BoxDecoration(
                                  color: primary,
                                  borderRadius: BorderRadius.circular(8),
                                  boxShadow: [
                                    BoxShadow(
                                      color: primary.withValues(
                                          alpha: isDark ? 0.3 : 0.2),
                                      blurRadius: isDark ? 20 : 15,
                                      offset: Offset(0, isDark ? 4 : 10),
                                    )
                                  ],
                                ),
                                alignment: Alignment.center,
                                child: _isSaving
                                    ? SizedBox(
                                        width: 20,
                                        height: 20,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color: onPrimary,
                                        ),
                                      )
                                    : Text(
                                        'Save & Continue',
                                        style:
                                            AppTypography.headlineSm.copyWith(
                                          color: onPrimary,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Sign Out Footer link
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        FooterLink(
                          text: 'Use a different account? Sign Out',
                          color: onSurfaceVariant,
                          hoverColor: primary,
                          onTap: _handleLogout,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLabel(String text, Color color, bool isDark) {
    return Text(
      isDark ? text : text.toUpperCase(),
      style: AppTypography.labelMd.copyWith(
        color: color,
        fontSize: 12,
        fontWeight: isDark ? FontWeight.w500 : FontWeight.w600,
        letterSpacing: 0.6,
      ),
    );
  }

  InputDecoration _buildInputDecoration(
    String hintText,
    IconData? prefixIcon,
    Color surfaceColor,
    Color borderColor,
    Color focusColor,
    bool isDark, {
    Widget? prefixWidget,
  }) {
    return InputDecoration(
      filled: true,
      fillColor: surfaceColor,
      hintText: hintText,
      hintStyle: AppTypography.bodyMd.copyWith(
        color: const Color(0xFFCCC3D8).withValues(alpha: 0.5),
      ),
      prefixIcon: prefixWidget ??
          (prefixIcon != null
              ? Icon(
                  prefixIcon,
                  color: isDark
                      ? const Color(0xFFCCC3D8).withValues(alpha: 0.7)
                      : const Color(0xFF464555),
                )
              : null),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 16,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: borderColor),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: borderColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(
          color: focusColor,
          width: isDark ? 1 : 2,
        ),
      ),
    );
  }

  Widget _buildCurrencyPrefixIcon(String currency, bool isDark) {
    final currencyCode = currency.toLowerCase();
    final hasAsset =
        ['aud', 'eur', 'gbp', 'inr', 'jpy', 'usd'].contains(currencyCode);

    if (hasAsset) {
      return Padding(
        padding: const EdgeInsets.all(12.0),
        child: Image.asset(
          'assets/icons/currency/$currencyCode.png',
          width: 24,
          height: 24,
          fit: BoxFit.contain,
          color: isDark ? null : const Color(0xFF1B1B24),
        ),
      );
    }

    return Icon(
      Icons.attach_money_outlined,
      color: isDark
          ? const Color(0xFFCCC3D8).withValues(alpha: 0.7)
          : const Color(0xFF464555),
    );
  }

  Widget _buildCurrencyDropdownIcon(String currency, bool isDark) {
    final currencyCode = currency.toLowerCase();
    final hasAsset =
        ['aud', 'eur', 'gbp', 'inr', 'jpy', 'usd'].contains(currencyCode);

    if (hasAsset) {
      return Image.asset(
        'assets/icons/currency/$currencyCode.png',
        width: 20,
        height: 20,
        fit: BoxFit.contain,
        color: isDark ? null : const Color(0xFF1B1B24),
      );
    }

    return Icon(
      Icons.attach_money_outlined,
      size: 20,
      color: isDark
          ? const Color(0xFFCCC3D8).withValues(alpha: 0.7)
          : const Color(0xFF464555),
    );
  }
}
