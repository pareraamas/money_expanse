import 'package:flutter/material.dart';

/// Tipografi Plus Jakarta Sans (di-bundle di `assets/fonts/`).
///
/// Skala: Display 40/48, Headline 24/32, Title 18/24, Body 16/24, Label 14/20.
/// Tidak ada teks di bawah 12 sp.
abstract final class AppTypography {
  static const String fontFamily = 'PlusJakartaSans';

  static const List<FontFeature> tabular = [FontFeature.tabularFigures()];

  static TextStyle _s(double size, double lineHeight, FontWeight weight, [double letterSpacing = 0]) => TextStyle(
    fontFamily: fontFamily,
    fontSize: size,
    height: lineHeight / size,
    fontWeight: weight,
    letterSpacing: letterSpacing,
    leadingDistribution: TextLeadingDistribution.even,
  );

  /// TextTheme M3 tanpa warna; warna diisi oleh [AppTheme].
  static final TextTheme textTheme = TextTheme(
    displayLarge: _s(40, 48, FontWeight.w700, -0.5),
    displayMedium: _s(34, 42, FontWeight.w700, -0.4),
    displaySmall: _s(28, 36, FontWeight.w700, -0.2),
    headlineLarge: _s(28, 36, FontWeight.w700, -0.2),
    headlineMedium: _s(24, 32, FontWeight.w700),
    headlineSmall: _s(20, 28, FontWeight.w700),
    titleLarge: _s(18, 24, FontWeight.w700),
    titleMedium: _s(16, 24, FontWeight.w600),
    titleSmall: _s(14, 20, FontWeight.w600),
    bodyLarge: _s(16, 24, FontWeight.w400),
    bodyMedium: _s(14, 20, FontWeight.w400),
    bodySmall: _s(12, 16, FontWeight.w400, 0.1),
    labelLarge: _s(14, 20, FontWeight.w600),
    labelMedium: _s(12, 16, FontWeight.w600, 0.2),
    labelSmall: _s(12, 16, FontWeight.w500, 0.2),
  );

  // Gaya nominal: selalu tabular figures agar digit tidak bergoyang saat count-up.

  /// Saldo di kartu utama.
  static final TextStyle amountDisplay = textTheme.displayLarge!.copyWith(fontFeatures: tabular);

  /// Nominal besar di form (di atas keypad) dan kartu ringkasan.
  static final TextStyle amountLarge = textTheme.headlineMedium!.copyWith(fontFeatures: tabular);

  /// Nominal di baris transaksi / budget.
  static final TextStyle amountMedium = textTheme.titleMedium!.copyWith(fontFeatures: tabular);

  /// Nominal kecil (sub-teks, legenda chart).
  static final TextStyle amountSmall = textTheme.labelLarge!.copyWith(fontFeatures: tabular);
}
