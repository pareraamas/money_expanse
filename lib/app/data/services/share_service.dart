import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import 'transaction_export.dart';

/// Membagikan file lewat share sheet sistem (WhatsApp, Instagram, Drive,
/// "Simpan ke File", dll.). File ditulis ke direktori sementara, jadi tidak
/// butuh izin penyimpanan.
///
/// [origin] adalah posisi tombol pemicu; wajib di iPad agar popover punya jangkar.
class ShareService {
  Future<ShareResultStatus> shareExport(ExportFile file, {Rect? origin}) => _share(file.bytes, file.fileName, file.mimeType, origin: origin);

  Future<ShareResultStatus> shareImage(Uint8List png, String fileName, {String? text, Rect? origin}) =>
      _share(png, fileName, 'image/png', text: text, origin: origin);

  Future<ShareResultStatus> _share(Uint8List bytes, String fileName, String mimeType, {String? text, Rect? origin}) async {
    final dir = await getTemporaryDirectory();
    // Tulis sebagai byte agar BOM & CRLF CSV tidak diubah.
    final file = await File(p.join(dir.path, fileName)).writeAsBytes(bytes, flush: true);
    final result = await SharePlus.instance.share(
      ShareParams(
        files: [XFile(file.path, mimeType: mimeType)],
        text: text,
        sharePositionOrigin: origin,
      ),
    );
    return result.status;
  }
}
