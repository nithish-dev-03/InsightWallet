import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // ──────────────────────────────────────────────
  // Dark Theme
  // ──────────────────────────────────────────────
  static const Color darkBackground = Color(0xFF15121b);
  static const Color darkSurface = Color(0xFF221e28);
  static const Color darkSurfaceVariant = Color(0xFF37333e);
  static const Color darkPrimary = Color(0xFFd2bbff);
  static const Color darkOnPrimary = Color(0xFF3f008e);
  static const Color darkPrimaryContainer = Color(0xFF7c3aed);
  static const Color darkOnPrimaryContainer = Color(0xFFede0ff);
  static const Color darkSecondary = Color(0xFFd0bcff);
  static const Color darkSecondaryContainer = Color(0xFF571bc1);
  static const Color darkOnSecondaryContainer = Color(0xFFc4abff);
  static const Color darkTertiary = Color(0xFFffb784);
  static const Color darkTertiaryContainer = Color(0xFFa15100);
  static const Color darkError = Color(0xFFffb4ab);
  static const Color darkOnError = Color(0xFF690005);
  static const Color darkErrorContainer = Color(0xFF93000a);
  static const Color darkOnSurface = Color(0xFFe8dfee);
  static const Color darkOnSurfaceVariant = Color(0xFFccc3d8);
  static const Color darkOutline = Color(0xFF958da1);
  static const Color darkOutlineVariant = Color(0xFF4a4455);
  static const Color darkSurfaceTint = Color(0xFFd2bbff);
  static const Color darkSurfaceDim = Color(0xFF15121b);
  static const Color darkSurfaceBright = Color(0xFF3c3742);
  static const Color darkSurfaceContainerLowest = Color(0xFF100d16);
  static const Color darkSurfaceContainerLow = Color(0xFF1d1a24);
  static const Color darkSurfaceContainer = Color(0xFF221e28);
  static const Color darkSurfaceContainerHigh = Color(0xFF2c2833);
  static const Color darkSurfaceContainerHighest = Color(0xFF37333e);
  static const Color darkInverseSurface = Color(0xFFe8dfee);
  static const Color darkInverseOnSurface = Color(0xFF332f39);
  static const Color darkInversePrimary = Color(0xFF732ee4);

  // ──────────────────────────────────────────────
  // Shorthand aliases (dark theme defaults)
  // ──────────────────────────────────────────────
  static const Color primary = Color(0xFFd2bbff);
  static const Color primaryContainer = Color(0xFF7c3aed);
  static const Color surface = Color(0xFF221e28);
  static const Color background = Color(0xFF15121b);
  static const Color onSurface = Color(0xFFe8dfee);
  static const Color onSurfaceVariant = Color(0xFFccc3d8);
  static const Color error = Color(0xFFffb4ab);
  static const Color tertiary = Color(0xFFffb784);
  static const Color outline = Color(0xFF958da1);
  static const Color outlineVariant = Color(0xFF4a4455);
  static const Color surfaceContainerHighest = Color(0xFF37333e);

  // ──────────────────────────────────────────────
  // Light Theme
  // ──────────────────────────────────────────────
  static const Color lightBackground = Color(0xFFfcf8ff);
  static const Color lightSurface = Color(0xFFf0ecf9);
  static const Color lightPrimary = Color(0xFF3525cd);
  static const Color lightOnPrimary = Color(0xFFffffff);
  static const Color lightPrimaryContainer = Color(0xFF4f46e5);
  static const Color lightOnPrimaryContainer = Color(0xFFdad7ff);
  static const Color lightSecondary = Color(0xFF4648d4);
  static const Color lightOnSecondary = Color(0xFFffffff);
  static const Color lightSecondaryContainer = Color(0xFF6063ee);
  static const Color lightTertiary = Color(0xFF7e3000);
  static const Color lightError = Color(0xFFba1a1a);
  static const Color lightOnError = Color(0xFFffffff);
  static const Color lightErrorContainer = Color(0xFFffdad6);
  static const Color lightOnSurface = Color(0xFF1b1b24);
  static const Color lightOnSurfaceVariant = Color(0xFF464555);
  static const Color lightOutline = Color(0xFF777587);
  static const Color lightOutlineVariant = Color(0xFFc7c4d8);
  static const Color lightSurfaceTint = Color(0xFF4d44e3);
  static const Color lightSurfaceDim = Color(0xFFdcd8e5);
  static const Color lightSurfaceBright = Color(0xFFfcf8ff);
  static const Color lightSurfaceContainerLowest = Color(0xFFffffff);
  static const Color lightSurfaceContainerLow = Color(0xFFf5f2ff);
  static const Color lightSurfaceContainer = Color(0xFFf0ecf9);
  static const Color lightSurfaceContainerHigh = Color(0xFFeae6f4);
  static const Color lightSurfaceContainerHighest = Color(0xFFe4e1ee);
  static const Color lightInverseSurface = Color(0xFF302f39);
  static const Color lightInverseOnSurface = Color(0xFFf3effc);
  static const Color lightInversePrimary = Color(0xFFc3c0ff);

  // ──────────────────────────────────────────────
  // Functional Colors
  // ──────────────────────────────────────────────
  static const Color success = Color(0xFF34d399);
  static const Color warning = Color(0xFFfbbf24);
  static const Color info = Color(0xFF22d3ee);
  static const Color income = Color(0xFF34d399);
  static const Color expense = Color(0xFFf87171);

  // ──────────────────────────────────────────────
  // Chart Colors
  // ──────────────────────────────────────────────
  static const List<Color> chartColors = [
    Color(0xFF7c3aed),
    Color(0xFF3b82f6),
    Color(0xFF34d399),
    Color(0xFFfbbf24),
    Color(0xFFf87171),
    Color(0xFFec4899),
    Color(0xFF14b8a6),
    Color(0xFFf97316),
  ];

  // ──────────────────────────────────────────────
  // Gradients
  // ──────────────────────────────────────────────
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF7c3aed), Color(0xFF4f46e5)],
  );

  static const LinearGradient cardGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF2c2833), Color(0xFF221e28)],
  );

  static const LinearGradient accentGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF7c3aed), Color(0xFF3b82f6)],
  );

  static const LinearGradient incomeGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF34d399), Color(0xFF059669)],
  );

  static const LinearGradient expenseGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFf87171), Color(0xFFdc2626)],
  );
}
