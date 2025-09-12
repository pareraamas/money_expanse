import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class CureencyFormatter extends TextInputFormatter {
  final NumberFormat _formatter = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp. ', decimalDigits: 0);

  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    // Hapus semua selain angka
    String newText = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');

    if (newText.isEmpty) {
      return newValue.copyWith(text: '');
    }

    // Parse ke int
    final int value = int.parse(newText);

    // Format ke Rp.
    final newString = _formatter.format(value);

    return TextEditingValue(
      text: newString,
      selection: TextSelection.collapsed(offset: newString.length),
    );
  }
}
