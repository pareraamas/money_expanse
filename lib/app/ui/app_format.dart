import 'package:intl/intl.dart';

/// Format angka & tanggal bersama untuk komponen UI.
///
/// Nominal selalu tanpa desimal dengan pemisah ribuan titik ("Rp 25.000").
/// Nama bulan ditulis sendiri agar tidak bergantung pada
/// `initializeDateFormatting` (aman di test dan sebelum locale dimuat).
abstract final class AppFormat {
  static final NumberFormat _digits = NumberFormat.decimalPattern('id_ID');

  /// Tanda minus tipografis (U+2212), lebih lebar dari tanda hubung.
  static const String minus = '−';

  static const List<String> months = [
    'Januari',
    'Februari',
    'Maret',
    'April',
    'Mei',
    'Juni',
    'Juli',
    'Agustus',
    'September',
    'Oktober',
    'November',
    'Desember',
  ];

  static const List<String> monthsShort = ['Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun', 'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des'];

  /// "25.000" — nilai absolut, dibulatkan, tanpa desimal.
  static String digits(num amount) => _digits.format(amount.abs().round());

  /// "Rp 25.000" — tanpa tanda.
  static String rupiah(num amount) => 'Rp ${digits(amount)}';

  /// "25.000 rupiah" — untuk label semantik screen reader.
  static String spokenRupiah(num amount) => '${digits(amount)} rupiah';

  /// "September 2026".
  static String monthYear(DateTime date) => '${months[date.month - 1]} ${date.year}';

  /// "Sep 2026".
  static String monthYearShort(DateTime date) => '${monthsShort[date.month - 1]} ${date.year}';

  /// "28 Sep".
  static String dayMonthShort(DateTime date) => '${date.day} ${monthsShort[date.month - 1]}';
}
