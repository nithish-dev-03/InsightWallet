import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTypography {
  AppTypography._();

  // ── Display ──────────────────────────────────
  static TextStyle displayLg = GoogleFonts.hankenGrotesk(
    fontSize: 48,
    fontWeight: FontWeight.w700,
    height: 56 / 48,
    letterSpacing: -0.02,
  );

  static TextStyle displayLgMobile = GoogleFonts.hankenGrotesk(
    fontSize: 36,
    fontWeight: FontWeight.w700,
    height: 44 / 36,
    letterSpacing: -0.02,
  );

  // ── Headlines ────────────────────────────────
  static TextStyle headlineMd = GoogleFonts.hankenGrotesk(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    height: 32 / 24,
  );

  static TextStyle headlineSm = GoogleFonts.hankenGrotesk(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    height: 28 / 20,
  );

  // ── Body ─────────────────────────────────────
  static TextStyle bodyLg = GoogleFonts.plusJakartaSans(
    fontSize: 18,
    fontWeight: FontWeight.w400,
    height: 28 / 18,
  );

  static TextStyle bodyMd = GoogleFonts.plusJakartaSans(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 24 / 16,
  );

  static TextStyle bodySm = GoogleFonts.plusJakartaSans(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 20 / 14,
  );

  // ── Labels ───────────────────────────────────
  static TextStyle labelMd = GoogleFonts.jetBrainsMono(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    height: 16 / 12,
    letterSpacing: 0.05,
  );

  // ── Numeric ──────────────────────────────────
  static TextStyle numberXl = GoogleFonts.jetBrainsMono(
    fontSize: 32,
    fontWeight: FontWeight.w600,
    height: 40 / 32,
    letterSpacing: -0.01,
  );
}
