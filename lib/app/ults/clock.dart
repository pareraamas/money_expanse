/// Sumber "sekarang" untuk controller. Test meng-override [now] agar
/// golden (pace anggaran, tanggal default) tidak berubah tiap hari.
abstract final class Clock {
  static DateTime Function() now = DateTime.now;
}
