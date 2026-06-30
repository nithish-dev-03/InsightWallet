import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_radius.dart';

class GlassCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final VoidCallback? onTap;
  final double? height;
  final double? width;

  const GlassCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.onTap,
    this.height,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final bgColor = brightness == Brightness.dark
        ? AppColors.darkSurfaceContainerHigh
        : AppColors.lightSurfaceContainerHigh;

    final Widget card = Container(
      height: height,
      width: width,
      padding: padding ?? const EdgeInsets.all(16),
      margin: margin,
      decoration: BoxDecoration(
        color: bgColor.withValues(alpha: 0.7),
        borderRadius: AppRadius.brXl,
        border: Border.all(
          color: brightness == Brightness.dark
              ? AppColors.darkOutlineVariant.withValues(alpha: 0.3)
              : AppColors.lightOutlineVariant.withValues(alpha: 0.3),
        ),
      ),
      child: child,
    );

    if (onTap != null) {
      return Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: AppRadius.brXl,
          splashColor: AppColors.darkPrimary.withValues(alpha: 0.1),
          highlightColor: Colors.transparent,
          child: card,
        ),
      );
    }

    return card;
  }
}
