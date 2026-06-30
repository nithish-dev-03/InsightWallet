import 'package:flutter/material.dart';

class AppAssets {
  AppAssets._();

  // ──────────────────────────────────────────────
  // Asset Paths
  // ──────────────────────────────────────────────
  static const String logoDark = 'assets/images/logo_dark.png';
  static const String logoLight = 'assets/images/logo_light.png';

  // ──────────────────────────────────────────────
  // Theme Helpers
  // ──────────────────────────────────────────────
  
  /// Returns the correct logo path based on the current context's theme brightness.
  static String logo(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return isDark ? logoDark : logoLight;
  }

  /// Returns the correct logo path based on a boolean theme mode indicator.
  static String logoOf(bool isDark) {
    return isDark ? logoDark : logoLight;
  }
}
