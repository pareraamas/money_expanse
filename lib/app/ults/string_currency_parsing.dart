extension StringRupiahParsing on String {
  double toDoubleFromRupiah() {
    final numericString = replaceAll(RegExp(r'[^0-9]'), '');
    return double.tryParse(numericString) ?? 0.0;
  }
}

extension DoubleRupiahParsing on double {
  String toRupiahString() {
    return 'Rp. ${toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}';
  }
}
