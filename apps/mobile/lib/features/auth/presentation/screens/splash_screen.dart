import 'dart:async';
import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/services/storage_service.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_assets.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/router/app_router.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    // Wait 5.0 seconds to allow the loading bar animation to complete
    await Future.delayed(const Duration(milliseconds: 5000));
    final storage = StorageService();
    final hasToken = await storage.getToken();
    final hasOnboarded = await storage.getOnboarded();
    if (!mounted) return;
    if (hasOnboarded != 'true') {
      context.go('/onboarding');
    } else if (hasToken != null) {
      AppRouter.setAuthenticated(true);
      context.go('/dashboard');
    } else {
      context.go('/auth/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          // 1. Radial Background Gradient
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              gradient: RadialGradient(
                center: Alignment.center,
                radius: 1.2,
                colors: [
                  Color(0xFF2E1065), // #2e1065
                  Color(0xFF1E1B4B), // #1e1b4b
                  Color(0xFF15121B), // #15121b
                ],
                stops: [0.0, 0.4, 1.0],
              ),
            ),
          ),

          // 2. Mesh Gradient with Floating Blurred Orbs (Opacity 0.6)
          Opacity(
            opacity: 0.6,
            child: Stack(
              children: [
                const _FloatingOrb(
                  width: 400,
                  height: 400,
                  top: -80,
                  left: -80,
                  color: AppColors.darkPrimaryContainer, // #7c3aed
                  initialValue: 0.0,
                ),
                _FloatingOrb(
                  width: 350,
                  height: 350,
                  top: size.height * 0.5 - 175,
                  right: -160,
                  color: AppColors.darkSecondaryContainer, // #571bc1
                  initialValue: 0.25, // animation-delay: -5s (20s loop)
                ),
                _FloatingOrb(
                  width: 300,
                  height: 300,
                  bottom: -80,
                  left: size.width * 0.25 - 150,
                  color: AppColors.darkTertiaryContainer, // #a15100
                  initialValue: 0.50, // animation-delay: -10s (20s loop)
                ),
              ],
            ),
          ),

          // 3. Subtle Interactive Particle System Layer
          const Positioned.fill(
            child: _ParticleLayer(),
          ),

          // 4. Main Content (Interactive & Centered)
          SafeArea(
            child: Align(
              alignment: Alignment.center,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: Insets.lg),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Spacer(flex: 3),

                    // Logo & Pulse Glow Effect
                    const _FadeInUp(
                      delay: Duration.zero,
                      child: _LogoWithGlow(),
                    ),

                    const SizedBox(height: Insets.xxl),

                    // Title
                    _FadeInUp(
                      delay: const Duration(milliseconds: 400),
                      child: Text(
                        'InsightWallet',
                        style: AppTypography.displayLgMobile.copyWith(
                          color: AppColors.darkOnSurface,
                        ),
                      ),
                    ),

                    const SizedBox(height: Insets.sm),

                    // Tagline
                    _FadeInUp(
                      delay: const Duration(milliseconds: 700),
                      child: Text(
                        'Track smarter. Spend wiser.',
                        style: AppTypography.bodyLg.copyWith(
                          color: AppColors.darkOnSurfaceVariant.withValues(alpha: 0.8),
                        ),
                      ),
                    ),

                    const SizedBox(height: Insets.xxl),

                    // Loading Progress Indicator & Label
                    const _FadeInUp(
                      delay: Duration(milliseconds: 1000),
                      child: _LoadingProgressBar(),
                    ),

                    const Spacer(flex: 2),
                  ],
                ),
              ),
            ),
          ),

          // 5. Fixed Bottom Branding Footnote
          Positioned(
            bottom: MediaQuery.of(context).padding.bottom + Insets.xl,
            left: 0,
            right: 0,
            child: const _FadeInUp(
              delay: Duration(milliseconds: 1000),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.verified_user_rounded,
                    size: 14,
                    color: Color(0x4DCCC3D8), // on-surface-variant/30
                  ),
                  SizedBox(width: Insets.xs),
                  Text(
                    'Bank-grade encryption active',
                    style: TextStyle(
                      fontFamily: 'Geist',
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Color(0x4DCCC3D8), // on-surface-variant/30
                      letterSpacing: 0.05,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Auxiliary Animated Widgets ──

class _FloatingOrb extends StatefulWidget {
  final double width;
  final double height;
  final double? top;
  final double? left;
  final double? right;
  final double? bottom;
  final Color color;
  final double initialValue;

  const _FloatingOrb({
    required this.width,
    required this.height,
    this.top,
    this.left,
    this.right,
    this.bottom,
    required this.color,
    this.initialValue = 0.0,
  });

  @override
  State<_FloatingOrb> createState() => _FloatingOrbState();
}

class _FloatingOrbState extends State<_FloatingOrb> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scaleAnimation;
  late final Animation<Offset> _translationAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
      value: widget.initialValue,
    )..repeat();

    _scaleAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.0, end: 1.1).chain(CurveTween(curve: Curves.easeInOut)),
        weight: 33,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.1, end: 0.9).chain(CurveTween(curve: Curves.easeInOut)),
        weight: 33,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.9, end: 1.0).chain(CurveTween(curve: Curves.easeInOut)),
        weight: 34,
      ),
    ]).animate(_controller);

    _translationAnimation = TweenSequence<Offset>([
      TweenSequenceItem(
        tween: Tween<Offset>(begin: const Offset(0.0, 0.0), end: const Offset(0.1, -0.1)).chain(CurveTween(curve: Curves.easeInOut)),
        weight: 33,
      ),
      TweenSequenceItem(
        tween: Tween<Offset>(begin: const Offset(0.1, -0.1), end: const Offset(-0.05, 0.15)).chain(CurveTween(curve: Curves.easeInOut)),
        weight: 33,
      ),
      TweenSequenceItem(
        tween: Tween<Offset>(begin: const Offset(-0.05, 0.15), end: const Offset(0.0, 0.0)).chain(CurveTween(curve: Curves.easeInOut)),
        weight: 34,
      ),
    ]).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Positioned(
      top: widget.top,
      left: widget.left,
      right: widget.right,
      bottom: widget.bottom,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          final translation = _translationAnimation.value;
          final dx = translation.dx * size.width;
          final dy = translation.dy * size.height;
          return Transform.translate(
            offset: Offset(dx, dy),
            child: Transform.scale(
              scale: _scaleAnimation.value,
              child: ImageFiltered(
                imageFilter: ImageFilter.blur(sigmaX: 80, sigmaY: 80),
                child: Container(
                  width: widget.width,
                  height: widget.height,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: widget.color,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _LogoWithGlow extends StatefulWidget {
  const _LogoWithGlow();

  @override
  State<_LogoWithGlow> createState() => _LogoWithGlowState();
}

class _LogoWithGlowState extends State<_LogoWithGlow> with SingleTickerProviderStateMixin {
  late final AnimationController _pulseController;
  late final Animation<double> _scaleAnimation;
  late final Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _opacityAnimation = Tween<double>(begin: 0.5, end: 0.8).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 160,
      height: 160,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Radial Gradient glow (pulse animation)
          AnimatedBuilder(
            animation: _pulseController,
            builder: (context, child) {
              return Transform.scale(
                scale: _scaleAnimation.value,
                child: Opacity(
                  opacity: _opacityAnimation.value,
                  child: Container(
                    width: 140,
                    height: 140,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          const Color(0xFF7C3AED).withValues(alpha: 0.35),
                          Colors.transparent,
                        ],
                        stops: const [0.0, 0.7],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
          // Logo Image with Drop Shadow
          Container(
            width: 96,
            height: 96,
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF7C3AED).withValues(alpha: 0.4),
                  blurRadius: 30,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Image.asset(
              AppAssets.logo(context),
              fit: BoxFit.contain,
            ),
          ),
        ],
      ),
    );
  }
}

class _LoadingProgressBar extends StatefulWidget {
  const _LoadingProgressBar();

  @override
  State<_LoadingProgressBar> createState() => _LoadingProgressBarState();
}

class _LoadingProgressBarState extends State<_LoadingProgressBar> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _progressAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3000),
    );

    _progressAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Cubic(0.65, 0.0, 0.35, 1.0),
      ),
    );

    // Starts after a 1.5s delay
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (mounted) {
        _controller.forward();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Loading Progress Bar Container
        ClipRRect(
          borderRadius: BorderRadius.circular(1),
          child: Container(
            width: 200,
            height: 2,
            color: Colors.white.withValues(alpha: 0.1),
            child: AnimatedBuilder(
              animation: _progressAnimation,
              builder: (context, child) {
                return FractionallySizedBox(
                  alignment: Alignment.centerLeft,
                  widthFactor: _progressAnimation.value,
                  child: Container(
                    color: const Color(0xFF7C3AED), // primary-container
                  ),
                );
              },
            ),
          ),
        ),
        const SizedBox(height: Insets.md),
        // Loading status text
        Text(
          'Initializing Secure Core',
          style: AppTypography.labelMd.copyWith(
            color: AppColors.darkOnSurfaceVariant.withValues(alpha: 0.4),
            letterSpacing: 2.4, // tracking-[0.2em]
          ),
        ),
      ],
    );
  }
}

class _Particle {
  double x;
  double y;
  double size;
  double speedX;
  double speedY;
  double opacity;

  _Particle({
    required this.x,
    required this.y,
    required this.size,
    required this.speedX,
    required this.speedY,
    required this.opacity,
  });
}

class _ParticleLayer extends StatefulWidget {
  const _ParticleLayer();

  @override
  State<_ParticleLayer> createState() => _ParticleLayerState();
}

class _ParticleLayerState extends State<_ParticleLayer> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  final List<_Particle> _particles = [];
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat();
  }

  void _initializeParticles(Size size) {
    final rand = math.Random();
    for (int i = 0; i < 60; i++) {
      _particles.add(
        _Particle(
          x: rand.nextDouble() * size.width,
          y: rand.nextDouble() * size.height,
          size: rand.nextDouble() * 1.5 + 0.5,
          speedX: (rand.nextDouble() - 0.5) * 0.5,
          speedY: (rand.nextDouble() - 0.5) * 0.5,
          opacity: rand.nextDouble() * 0.5,
        ),
      );
    }
    _initialized = true;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final size = Size(constraints.maxWidth, constraints.maxHeight);
        if (!_initialized) {
          _initializeParticles(size);
        }

        return AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            // Update particles
            for (final p in _particles) {
              p.x += p.speedX;
              p.y += p.speedY;
              if (p.x < 0 || p.x > size.width) p.speedX *= -1;
              if (p.y < 0 || p.y > size.height) p.speedY *= -1;
            }

            return CustomPaint(
              size: size,
              painter: _ParticlePainter(particles: _particles),
            );
          },
        );
      },
    );
  }
}

class _ParticlePainter extends CustomPainter {
  final List<_Particle> particles;

  _ParticlePainter({required this.particles});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;
    for (final p in particles) {
      paint.color = const Color(0xFFD2BBFF).withValues(alpha: p.opacity);
      canvas.drawCircle(Offset(p.x, p.y), p.size, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _ParticlePainter oldDelegate) => true;
}

class _FadeInUp extends StatefulWidget {
  final Widget child;
  final Duration delay;
  final Duration duration;

  const _FadeInUp({
    required this.child,
    required this.delay,
    this.duration = const Duration(milliseconds: 1200),
  });

  @override
  State<_FadeInUp> createState() => _FadeInUpState();
}

class _FadeInUpState extends State<_FadeInUp> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _opacity;
  late final Animation<double> _translate;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );

    _opacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Cubic(0.4, 0.0, 0.2, 1.0), // cubic-bezier(0.4, 0, 0.2, 1)
      ),
    );

    _translate = Tween<double>(begin: 20.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Cubic(0.4, 0.0, 0.2, 1.0),
      ),
    );

    Future.delayed(widget.delay, () {
      if (mounted) {
        _controller.forward();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Opacity(
          opacity: _opacity.value,
          child: Transform.translate(
            offset: Offset(0, _translate.value),
            child: child,
          ),
        );
      },
      child: widget.child,
    );
  }
}
