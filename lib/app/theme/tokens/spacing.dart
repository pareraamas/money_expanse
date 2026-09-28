/// Jarak (dp). Primitif berkelipatan 4, lalu alias semantik.
abstract final class AppSpacing {
  static const double s2 = 2;
  static const double s4 = 4;
  static const double s8 = 8;
  static const double s12 = 12;
  static const double s16 = 16;
  static const double s20 = 20;
  static const double s24 = 24;
  static const double s32 = 32;
  static const double s40 = 40;
  static const double s48 = 48;

  /// Gutter kiri-kanan halaman.
  static const double page = s16;

  /// Padding dalam kartu.
  static const double card = s16;

  /// Jarak antar-section dalam satu layar.
  static const double section = s24;

  /// Jarak antar-item list/kartu yang bertumpuk.
  static const double stack = s12;

  /// Jarak ikon ke teks di dalam baris.
  static const double inline = s8;

  /// Target sentuh minimum (a11y).
  static const double minTouch = 48;

  /// Target sentuh tombol keypad nominal.
  static const double keypadTouch = 56;
}
