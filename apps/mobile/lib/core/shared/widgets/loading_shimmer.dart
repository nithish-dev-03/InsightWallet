import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_radius.dart';

class LoadingShimmer extends StatelessWidget {
  final double? height;
  final double? width;
  final double borderRadius;

  const LoadingShimmer({
    super.key,
    this.height,
    this.width,
    this.borderRadius = AppRadius.xl,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Shimmer.fromColors(
      baseColor: isDark
          ? AppColors.darkSurfaceContainerHighest
          : AppColors.lightSurfaceContainerHighest,
      highlightColor: isDark
          ? AppColors.darkSurfaceContainerHigh
          : AppColors.lightSurfaceContainerHigh,
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          color: isDark
              ? AppColors.darkSurfaceContainerHighest
              : AppColors.lightSurfaceContainerHighest,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
    );
  }
}

class CardShimmer extends StatelessWidget {
  final double height;

  const CardShimmer({super.key, this.height = 120});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: LoadingShimmer(height: 120),
    );
  }
}

class ListShimmer extends StatelessWidget {
  final int itemCount;
  final double itemHeight;

  const ListShimmer({
    super.key,
    this.itemCount = 5,
    this.itemHeight = 80,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(
        itemCount,
        (index) => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          child: LoadingShimmer(height: itemHeight),
        ),
      ),
    );
  }
}
