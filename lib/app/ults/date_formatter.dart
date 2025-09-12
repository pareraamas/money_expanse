import 'package:intl/intl.dart';

extension DateTimeExtension on DateTime {
  String toHumanReadable() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final target = DateTime(year, month, day);

    final difference = target.difference(today).inDays;

    if (difference == 0) {
      return "Hari ini";
    } else if (difference == -1) {
      return "Kemarin";
    } else if (difference == 1) {
      return "Besok";
    } else {
      final dayName = DateFormat.EEEE('id_ID').format(this); // contoh: Sabtu
      final formattedDate = DateFormat("d MMMM yyyy", "id_ID").format(this); // contoh: 8 Agustus 2022
      return "$dayName, $formattedDate";
    }
  }
}
