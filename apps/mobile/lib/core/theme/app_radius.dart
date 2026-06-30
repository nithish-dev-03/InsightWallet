import 'package:flutter/material.dart';

class AppRadius {
  AppRadius._();

  static const double sm = 4;
  static const double md = 8;
  static const double lg = 12;
  static const double xl = 24;

  static const Radius radiusSm = Radius.circular(sm);
  static const Radius radiusMd = Radius.circular(md);
  static const Radius radiusLg = Radius.circular(lg);
  static const Radius radiusXl = Radius.circular(xl);
  static const Radius radiusFull = Radius.circular(9999);

  static const BorderRadius brSm = BorderRadius.all(radiusSm);
  static const BorderRadius brMd = BorderRadius.all(radiusMd);
  static const BorderRadius brLg = BorderRadius.all(radiusLg);
  static const BorderRadius brXl = BorderRadius.all(radiusXl);
  static const BorderRadius brFull = BorderRadius.all(radiusFull);
}
