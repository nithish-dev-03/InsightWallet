import 'dart:ui';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_typography.dart';

class GlassPanel extends StatelessWidget {
  final Widget child;
  final BorderRadius borderRadius;
  final double blur;
  final Color color;
  final Border? border;
  final EdgeInsetsGeometry? padding;

  const GlassPanel({
    super.key,
    required this.child,
    this.borderRadius = AppRadius.brXl,
    this.blur = 12.0,
    this.color = const Color(0x661E293B),
    this.border,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: borderRadius,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            color: color,
            borderRadius: borderRadius,
            border: border ?? Border.all(color: Colors.white.withValues(alpha: 0.05), width: 1.0),
          ),
          child: child,
        ),
      ),
    );
  }
}

class InteractiveButton extends StatefulWidget {
  final Widget child;
  final VoidCallback onTap;
  const InteractiveButton({super.key, required this.child, required this.onTap});

  @override
  State<InteractiveButton> createState() => _InteractiveButtonState();
}

class _InteractiveButtonState extends State<InteractiveButton> {
  double _scale = 1.0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _scale = 0.95),
      onTapUp: (_) => setState(() => _scale = 1.0),
      onTapCancel: () => setState(() => _scale = 1.0),
      onTap: widget.onTap,
      child: AnimatedScale(
        scale: _scale,
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeOut,
        child: widget.child,
      ),
    );
  }
}

class FooterLink extends StatelessWidget {
  final String text;
  final Color color;
  final Color hoverColor;
  final VoidCallback onTap;

  const FooterLink({
    super.key,
    required this.text,
    required this.color,
    required this.hoverColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Text(
        text,
        style: AppTypography.bodySm.copyWith(
          color: color,
          fontSize: 12,
        ),
      ),
    );
  }
}

class FooterDivider extends StatelessWidget {
  final Color color;
  const FooterDivider({super.key, required this.color});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Text(
        '•',
        style: TextStyle(
          color: color.withValues(alpha: 0.4),
          fontSize: 12,
        ),
      ),
    );
  }
}
