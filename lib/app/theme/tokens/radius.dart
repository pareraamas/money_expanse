import 'package:flutter/painting.dart';

/// Radius — hanya lima nilai yang diizinkan.
abstract final class AppRadius {
  /// Chip, tag kecil.
  static const double chip = 8;

  /// Input, snackbar, tombol keypad.
  static const double input = 12;

  /// Kartu.
  static const double card = 20;

  /// Bottom sheet dan dialog.
  static const double sheet = 28;

  /// FAB, avatar, tombol pill.
  static const double full = 999;

  static const chipAll = BorderRadius.all(Radius.circular(chip));
  static const inputAll = BorderRadius.all(Radius.circular(input));
  static const cardAll = BorderRadius.all(Radius.circular(card));
  static const sheetAll = BorderRadius.all(Radius.circular(sheet));
  static const sheetTop = BorderRadius.vertical(top: Radius.circular(sheet));
  static const fullAll = BorderRadius.all(Radius.circular(full));
}
