import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

/// Membagikan file lewat share sheet sistem (WhatsApp, Instagram, Drive,
/// "Simpan ke File", dll.). File ditulis ke direktori sementara, jadi tidak
/// butuh izin penyimpanan.
///
/// [origin] adalah posisi tombol pemicu; wajib di iPad agar popover punya jangkar.
class ShareService {
  Future<ShareResultStatus> shareCsv(String content, String fileName, {Rect? origin}) async {
    // BOM sudah ada di [content]; tulis sebagai byte agar CRLF tidak diubah.
    final file = await _write(fileName, utf8.encode(content));
    return _share(XFile(file.path, mimeType: 'text/csv'), origin: origin);
  }

  Future<ShareResultStatus> shareImage(Uint8List png, String fileName, {String? text, Rect? origin}) async {
    final file = await _write(fileName, png);
    return _share(
      XFile(file.path, mimeType: 'image/png'),
      text: text,
      origin: origin,
    );
  }

  Future<File> _write(String fileName, List<int> bytes) async {
    final dir = await getTemporaryDirectory();
    return File(p.join(dir.path, fileName)).writeAsBytes(bytes, flush: true);
  }

  Future<ShareResultStatus> _share(XFile file, {String? text, Rect? origin}) async {
    final result = await SharePlus.instance.share(ShareParams(files: [file], text: text, sharePositionOrigin: origin));
    return result.status;
  }
}
