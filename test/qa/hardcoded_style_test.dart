@Tags(['qa', 'gerbang'])
library;

import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// Aturan main #3: tidak ada `Color(0x…)`, `Colors.*`, atau `TextStyle(` lepas
/// di layar & komponen. Semua nilai visual harus dari token tema.
final _patterns = <String, RegExp>{
  'Color(0x…)': RegExp(r'\bColor\(0x'),
  'Colors.*': RegExp(r'\bColors\.(?!transparent\b)'),
  'TextStyle(': RegExp(r'\bTextStyle\('),
  'GoogleFonts.*': RegExp(r'\bGoogleFonts\.'),
};

List<String> _violations(String dir) {
  final hits = <String>[];
  final files = Directory(dir).listSync(recursive: true).whereType<File>().where((f) => f.path.endsWith('.dart')).toList()
    ..sort((a, b) => a.path.compareTo(b.path));
  for (final file in files) {
    final lines = file.readAsLinesSync();
    for (var i = 0; i < lines.length; i++) {
      final code = lines[i].split('//').first;
      for (final p in _patterns.entries) {
        if (p.value.hasMatch(code)) hits.add('${file.path}:${i + 1}  ${p.key}  ${lines[i].trim()}');
      }
    }
  }
  return hits;
}

void main() {
  for (final dir in ['lib/app/modules', 'lib/app/ui', 'lib/app/widgets']) {
    test('0 warna/TextStyle hardcoded di $dir', () {
      if (!Directory(dir).existsSync()) return markTestSkipped('$dir belum ada');
      final hits = _violations(dir);
      expect(hits, isEmpty, reason: '${hits.length} pelanggaran:\n${hits.join('\n')}');
    });
  }
}
