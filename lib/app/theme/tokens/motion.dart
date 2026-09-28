import 'package:flutter/widgets.dart';

/// Durasi, kurva, dan pegas. Semua animasi mengambil nilai dari sini.
abstract final class AppMotion {
  static const instant = Duration(milliseconds: 100);
  static const short = Duration(milliseconds: 150);
  static const medium = Duration(milliseconds: 250);
  static const long = Duration(milliseconds: 400);

  /// Jeda antar-item saat list masuk bertahap.
  static const stagger = Duration(milliseconds: 40);

  /// Angka saldo count-up.
  static const countUp = Duration(milliseconds: 600);

  /// Skala kartu saat ditekan.
  static const double pressScale = 0.97;

  static const Curve standard = Curves.easeOutCubic;
  static const Curve emphasized = Curves.easeInOutCubicEmphasized;
  static const Curve decelerate = Curves.easeOutQuart;

  /// Pegas ala M3 Expressive (spatial default) untuk posisi/ukuran.
  static final SpringDescription spatial = SpringDescription.withDampingRatio(mass: 1, stiffness: 700, ratio: 0.9);

  /// Pegas cepat dengan sedikit pantulan, untuk ikon aktif & pratinjau.
  static final SpringDescription bouncy = SpringDescription.withDampingRatio(mass: 1, stiffness: 1400, ratio: 0.6);

  /// Pegas efek (warna/opacity), tanpa pantulan.
  static final SpringDescription effects = SpringDescription.withDampingRatio(mass: 1, stiffness: 1600, ratio: 1);

  /// True jika user mematikan animasi di pengaturan sistem.
  /// Komponen wajib mengganti animasinya dengan crossfade [short].
  static bool reduced(BuildContext context) => MediaQuery.maybeDisableAnimationsOf(context) ?? false;

  /// [d] atau [Duration.zero] bila animasi dimatikan.
  static Duration of(BuildContext context, Duration d) => reduced(context) ? Duration.zero : d;
}
