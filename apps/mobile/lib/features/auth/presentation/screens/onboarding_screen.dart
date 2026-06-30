import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/services/storage_service.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_assets.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/app_radius.dart';
import '../widgets/auth_widgets.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> with TickerProviderStateMixin {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  late final AnimationController _floatingController;
  late final Animation<double> _translateAnim;
  late final Animation<double> _rotateAnim;

  static final _slides = [
    _OnboardingSlideData(
      title: 'Track Your Wealth',
      description: 'Automatically categorize and monitor your spending with intelligent insights.',
      mainIcon: Icons.trending_up_rounded,
      floatIconTopRight: Icons.trending_up_rounded,
      floatIconBottomLeft: Icons.pie_chart_rounded,
      themeColor: const Color(0xFFD2BBFF),
      mockTransactions: [
        const _MockTransaction(
          icon: Icons.shopping_cart_outlined,
          label: '₹42.00',
          color: Color(0xFFD2BBFF),
          barWidth: 96,
          bgColor: Color(0x33D2BBFF), // bg-primary/20
        ),
        _MockTransaction(
          icon: Icons.restaurant_outlined,
          label: '₹18.50',
          color: const Color(0xFFE8DFEE),
          barWidth: 64,
          bgColor: Colors.white.withValues(alpha: 0.05), // bg-white/5
        ),
        const _MockTransaction(
          icon: Icons.commute_outlined,
          label: '₹12.00',
          color: Color(0xFFD0BCFF),
          barWidth: 80,
          bgColor: Color(0x33571BC1), // bg-secondary-container/20
        ),
      ],
    ),
    _OnboardingSlideData(
      title: 'Analyze Spending',
      description: 'Visualize your expenses with beautiful charts and understand where your money goes.',
      mainIcon: Icons.pie_chart_rounded,
      floatIconTopRight: Icons.insights_rounded,
      floatIconBottomLeft: Icons.donut_large_rounded,
      themeColor: const Color(0xFFD2BBFF),
      mockTransactions: [
        const _MockTransaction(
          icon: Icons.shopping_bag_outlined,
          label: '₹320.00',
          color: Color(0xFFD2BBFF),
          barWidth: 110,
          bgColor: Color(0x33D2BBFF),
        ),
        _MockTransaction(
          icon: Icons.subscriptions_outlined,
          label: '₹59.99',
          color: const Color(0xFFE8DFEE),
          barWidth: 48,
          bgColor: Colors.white.withValues(alpha: 0.05),
        ),
        const _MockTransaction(
          icon: Icons.home_outlined,
          label: '₹1,200.00',
          color: Color(0xFFD0BCFF),
          barWidth: 75,
          bgColor: Color(0x33571BC1),
        ),
      ],
    ),
    _OnboardingSlideData(
      title: 'Achieve Goals',
      description: 'Set savings goals, create budgets, and let AI help you make smarter financial decisions.',
      mainIcon: Icons.flag_rounded,
      floatIconTopRight: Icons.stars_rounded,
      floatIconBottomLeft: Icons.workspace_premium_rounded,
      themeColor: const Color(0xFFD2BBFF),
      mockTransactions: [
        const _MockTransaction(
          icon: Icons.savings_outlined,
          label: 'Goal: ₹10k',
          color: Color(0xFFD2BBFF),
          barWidth: 80,
          bgColor: Color(0x33D2BBFF),
        ),
        _MockTransaction(
          icon: Icons.trending_down_rounded,
          label: '-12% spending',
          color: const Color(0xFFE8DFEE),
          barWidth: 90,
          bgColor: Colors.white.withValues(alpha: 0.05),
        ),
        const _MockTransaction(
          icon: Icons.emoji_events_outlined,
          label: '3 wins',
          color: Color(0xFFD0BCFF),
          barWidth: 60,
          bgColor: Color(0x33571BC1),
        ),
      ],
    ),
  ];

  @override
  void initState() {
    super.initState();
    _floatingController = AnimationController(
      duration: const Duration(seconds: 6),
      vsync: this,
    )..repeat(reverse: true);

    _translateAnim = Tween<double>(begin: 0.0, end: -20.0).animate(
      CurvedAnimation(parent: _floatingController, curve: Curves.easeInOut),
    );

    _rotateAnim = Tween<double>(begin: 0.0, end: 2.0 * math.pi / 180.0).animate(
      CurvedAnimation(parent: _floatingController, curve: Curves.easeInOut),
    );
  }

  void _onNext() {
    if (_currentPage < _slides.length - 1) {
      _pageController.nextPage(duration: const Duration(milliseconds: 400), curve: Curves.easeInOut);
    } else {
      _completeOnboarding();
    }
  }

  void _skip() => _completeOnboarding();

  Future<void> _completeOnboarding() async {
    final storage = StorageService();
    await storage.setOnboarded('true');
    if (!mounted) return;
    context.go('/auth/login');
  }

  @override
  void dispose() {
    _pageController.dispose();
    _floatingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // Background Atmospheric Radial Gradients
          Positioned.fill(
            child: Container(color: AppColors.background),
          ),
          // Top-Right Glow
          Positioned(
            top: -150,
            right: -150,
            child: Container(
              width: 500,
              height: 500,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppColors.primary.withValues(alpha: 0.15),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          // Bottom-Left Glow
          Positioned(
            bottom: -150,
            left: -150,
            child: Container(
              width: 400,
              height: 400,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    const Color(0xFF571BC1).withValues(alpha: 0.08),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          // Onboarding Layout Content
          SafeArea(
            child: Column(
              children: [
                // Header: Logo + Title + Skip Button
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Logo + App Name
                      Row(
                        children: [
                          Image.asset(
                            AppAssets.logo(context),
                            height: 32,
                            width: 32,
                            fit: BoxFit.contain,
                            errorBuilder: (context, error, stackTrace) => const SizedBox(width: 32, height: 32),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'InsightWallet',
                            style: AppTypography.headlineSm.copyWith(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w700,
                              letterSpacing: -0.5,
                            ),
                          ),
                        ],
                      ),
                      // Skip Button
                      InteractiveButton(
                        onTap: _skip,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          child: Text(
                            'SKIP',
                            style: AppTypography.labelMd.copyWith(
                              color: AppColors.onSurfaceVariant.withValues(alpha: 0.7),
                              fontWeight: FontWeight.w600,
                              letterSpacing: 1.5,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // Slides (PageView builder)
                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    onPageChanged: (index) => setState(() => _currentPage = index),
                    itemCount: _slides.length,
                    itemBuilder: (context, index) {
                      final slide = _slides[index];
                      return _buildSlide(slide);
                    },
                  ),
                ),
                // Footer: Progress Indicator & Action Button
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 0, 24, 48),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Dots Indicator
                      Row(
                        children: List.generate(_slides.length, (i) {
                          final isActive = _currentPage == i;
                          return AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            margin: const EdgeInsets.only(right: 8),
                            width: isActive ? 24 : 6,
                            height: 6,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(3),
                              color: isActive
                                  ? AppColors.primary
                                  : Colors.white.withValues(alpha: 0.2),
                            ),
                          );
                        }),
                      ),
                      // Next / Get Started Glow Button
                      InteractiveButton(
                        onTap: _onNext,
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppColors.primaryContainer,
                            borderRadius: AppRadius.brLg,
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.primaryContainer.withValues(alpha: 0.3),
                                blurRadius: 12,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                _currentPage == _slides.length - 1 ? 'Get Started' : 'Next',
                                style: AppTypography.headlineSm.copyWith(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(width: 8),
                              const Icon(
                                Icons.arrow_forward_rounded,
                                color: Colors.white,
                                size: 20,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSlide(_OnboardingSlideData slide) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Illustration Area (Bento-inspired Layout with floating parallax effect)
          Center(
            child: SizedBox(
              width: 300,
              height: 280,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  // Main floating glass card
                  Positioned(
                    left: 20,
                    right: 20,
                    top: 20,
                    bottom: 20,
                    child: AnimatedBuilder(
                      animation: _floatingController,
                      builder: (context, child) {
                        return Transform.translate(
                          offset: Offset(0, _translateAnim.value),
                          child: Transform.rotate(
                            angle: _rotateAnim.value,
                            child: child,
                          ),
                        );
                      },
                      child: GlassPanel(
                        padding: const EdgeInsets.all(16),
                        child: Stack(
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: slide.mockTransactions.map((tx) {
                                return Container(
                                  height: 48,
                                  padding: const EdgeInsets.symmetric(horizontal: 12),
                                  decoration: BoxDecoration(
                                    color: tx.bgColor,
                                    borderRadius: AppRadius.brLg,
                                  ),
                                  child: Row(
                                    children: [
                                      // Icon container
                                      Container(
                                        width: 28,
                                        height: 28,
                                        decoration: BoxDecoration(
                                          color: Colors.white.withValues(alpha: 0.05),
                                          shape: BoxShape.circle,
                                        ),
                                        child: Icon(
                                          tx.icon,
                                          color: tx.color,
                                          size: 16,
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      // Visual bar indicating transaction type/category
                                      Expanded(
                                        child: Align(
                                          alignment: Alignment.centerLeft,
                                          child: FractionallySizedBox(
                                            widthFactor: tx.barWidth / 110.0,
                                            child: Container(
                                              height: 8,
                                              decoration: BoxDecoration(
                                                color: tx.color.withValues(alpha: 0.15),
                                                borderRadius: AppRadius.brFull,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      // Label text (price/progress)
                                      Text(
                                        tx.label,
                                        style: AppTypography.labelMd.copyWith(
                                          color: tx.color,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }).toList(),
                            ),
                            // Floating Pulse Dot (Slide 1 only)
                            if (slide == _slides[0])
                              Positioned(
                                top: 8,
                                right: 12,
                                child: AnimatedBuilder(
                                  animation: _floatingController,
                                  builder: (context, _) {
                                    final pulseVal = 0.3 + 0.7 * _floatingController.value;
                                    return Opacity(
                                      opacity: pulseVal,
                                      child: Container(
                                        width: 8,
                                        height: 8,
                                        decoration: BoxDecoration(
                                          color: AppColors.primary,
                                          shape: BoxShape.circle,
                                          boxShadow: [
                                            BoxShadow(
                                              color: AppColors.primary.withValues(alpha: 0.6),
                                              blurRadius: 8,
                                              spreadRadius: 2,
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  // Accompanying Small Glass Elements (static parallax effect)
                  // Top-Right rotated square card
                  Positioned(
                    top: 0,
                    right: 0,
                    child: Transform.rotate(
                      angle: 12 * math.pi / 180.0,
                      child: SizedBox(
                        width: 56,
                        height: 56,
                        child: GlassPanel(
                          borderRadius: AppRadius.brLg,
                          child: Center(
                            child: Icon(
                              slide.floatIconTopRight,
                              color: AppColors.primary,
                              size: 24,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  // Bottom-Left rotated circle card
                  Positioned(
                    bottom: 0,
                    left: 0,
                    child: Transform.rotate(
                      angle: -12 * math.pi / 180.0,
                      child: SizedBox(
                        width: 64,
                        height: 64,
                        child: GlassPanel(
                          borderRadius: BorderRadius.circular(32),
                          child: Center(
                            child: Icon(
                              slide.floatIconBottomLeft,
                              color: const Color(0xFFD0BCFF),
                              size: 28,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 32),
          // Title
          Text(
            slide.title,
            textAlign: TextAlign.center,
            style: AppTypography.displayLgMobile.copyWith(
              color: AppColors.onSurface,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 16),
          // Description
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              slide.description,
              textAlign: TextAlign.center,
              style: AppTypography.bodyMd.copyWith(
                color: AppColors.onSurfaceVariant.withValues(alpha: 0.8),
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _OnboardingSlideData {
  final String title;
  final String description;
  final IconData mainIcon;
  final IconData floatIconTopRight;
  final IconData floatIconBottomLeft;
  final Color themeColor;
  final List<_MockTransaction> mockTransactions;

  const _OnboardingSlideData({
    required this.title,
    required this.description,
    required this.mainIcon,
    required this.floatIconTopRight,
    required this.floatIconBottomLeft,
    required this.themeColor,
    required this.mockTransactions,
  });
}

class _MockTransaction {
  final IconData icon;
  final String label;
  final Color color;
  final double barWidth;
  final Color bgColor;

  const _MockTransaction({
    required this.icon,
    required this.label,
    required this.color,
    required this.barWidth,
    required this.bgColor,
  });
}
