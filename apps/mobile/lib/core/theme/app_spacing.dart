import 'package:flutter/material.dart';

class Insets {
  Insets._();

  static const double xs = 4;
  static const double sm = 8;
  static const double md = 16;
  static const double lg = 24;
  static const double xl = 32;
  static const double xxl = 48;
}

class EdgeInsetsHelper {
  EdgeInsetsHelper._();

  static const EdgeInsets allXs = EdgeInsets.all(Insets.xs);
  static const EdgeInsets allSm = EdgeInsets.all(Insets.sm);
  static const EdgeInsets allMd = EdgeInsets.all(Insets.md);
  static const EdgeInsets allLg = EdgeInsets.all(Insets.lg);
  static const EdgeInsets allXl = EdgeInsets.all(Insets.xl);
  static const EdgeInsets allXxl = EdgeInsets.all(Insets.xxl);

  static const EdgeInsets horizontalSm = EdgeInsets.symmetric(horizontal: Insets.sm);
  static const EdgeInsets horizontalMd = EdgeInsets.symmetric(horizontal: Insets.md);
  static const EdgeInsets horizontalLg = EdgeInsets.symmetric(horizontal: Insets.lg);

  static const EdgeInsets verticalSm = EdgeInsets.symmetric(vertical: Insets.sm);
  static const EdgeInsets verticalMd = EdgeInsets.symmetric(vertical: Insets.md);
  static const EdgeInsets verticalLg = EdgeInsets.symmetric(vertical: Insets.lg);
}
