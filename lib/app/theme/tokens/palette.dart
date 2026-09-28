import 'package:flutter/painting.dart';

/// Lapis 1 — primitif.
///
/// Nilai hex mentah untuk "Dompet yang Ceria". Hanya dibaca oleh lapis
/// semantik ([AppColors]); widget tidak boleh memakai kelas ini langsung.
abstract final class AppPalette {
  // Laut (brand)
  static const teal100 = Color(0xFFCDEFE9);
  static const teal300 = Color(0xFFB8F2E8);
  static const teal400 = Color(0xFF4FD1C0);
  static const teal600 = Color(0xFF0E8C7F);
  static const teal700 = Color(0xFF0C7066);
  static const teal800 = Color(0xFF0B4F47);
  static const teal900 = Color(0xFF003D37);
  static const teal950 = Color(0xFF00332D);

  // Mangga (aksen)
  static const mango100 = Color(0xFFFFE7C2);
  static const mango200 = Color(0xFFFFE2B3);
  static const mango300 = Color(0xFFFFC56B);
  static const mango400 = Color(0xFFFFB547);
  static const mango800 = Color(0xFF5A3E0A);
  static const mango900 = Color(0xFF5A3A00);

  // Krem (netral terang)
  static const cream0 = Color(0xFFFFFFFF);
  static const cream50 = Color(0xFFFFFCF8);
  static const cream100 = Color(0xFFFCF9F4);
  static const cream200 = Color(0xFFF8F4EE);
  static const cream300 = Color(0xFFF3EEE7);
  static const cream400 = Color(0xFFEDE7DF);
  static const cream500 = Color(0xFFE4DED5);
  static const cream600 = Color(0xFF857D70);
  static const cream700 = Color(0xFFF1EDE6);

  // Malam (netral gelap)
  static const night950 = Color(0xFF0B151B);
  static const night900 = Color(0xFF101C24);
  static const night850 = Color(0xFF15222B);
  static const night800 = Color(0xFF1A2832);
  static const night750 = Color(0xFF1F2D37);
  static const night700 = Color(0xFF283844);
  static const night600 = Color(0xFF34444F);
  static const night500 = Color(0xFF7A8894);
  static const night400 = Color(0xFF2A333D);

  // Tinta (teks)
  static const ink900 = Color(0xFF1B2430);
  static const ink600 = Color(0xFF5B6573);
  static const ink300 = Color(0xFF9AA6B2);
  static const ink100 = Color(0xFFE8EDF0);

  // Hijau (pemasukan)
  static const green100 = Color(0xFFDCF3E5);
  static const green200 = Color(0xFFB7F5CD);
  static const green400 = Color(0xFF4ADE80);
  static const green600 = Color(0xFF1E9E5A);
  static const green700 = Color(0xFF167342);
  static const green800 = Color(0xFF0B4A28);
  static const green900 = Color(0xFF123D26);

  // Coral (pengeluaran)
  static const coral100 = Color(0xFFFDE7E1);
  static const coral200 = Color(0xFFFFD5CB);
  static const coral400 = Color(0xFFFF8A73);
  static const coral500 = Color(0xFFF0634A);
  static const coral700 = Color(0xFFB6371D);
  static const coral800 = Color(0xFF7A2210);
  static const coral900 = Color(0xFF4A1E15);

  // Amber (peringatan)
  static const amber100 = Color(0xFFFFEFD3);
  static const amber200 = Color(0xFFFFE8A8);
  static const amber400 = Color(0xFFFBBF24);
  static const amber500 = Color(0xFFE08A00);
  static const amber700 = Color(0xFF8E5700);
  static const amber800 = Color(0xFF5A3700);
  static const amber900 = Color(0xFF4A3508);

  // Merah (bahaya)
  static const red100 = Color(0xFFFEE4E2);
  static const red200 = Color(0xFFFFDAD6);
  static const red400 = Color(0xFFFF8078);
  static const red700 = Color(0xFFB42318);
  static const red800 = Color(0xFF7A1A12);
  static const red900 = Color(0xFF5C1A14);

  static const black = Color(0xFF000000);
  static const white = Color(0xFFFFFFFF);
  static const transparent = Color(0x00000000);
}
