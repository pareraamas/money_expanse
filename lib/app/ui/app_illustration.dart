import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../theme/app_theme.dart';

/// Path aset ilustrasi (dibuat Agen Ilustrasi). Nama file adalah kontrak.
abstract final class AppIllustrations {
  static const _dir = 'assets/illustrations';

  // Spot empty state (viewBox 160).
  static const emptyBeranda = '$_dir/empty/empty_beranda.svg';
  static const emptyAnggaran = '$_dir/empty/empty_anggaran.svg';
  static const emptyStatistik = '$_dir/empty/empty_statistik.svg';
  static const emptyKategori = '$_dir/empty/empty_kategori.svg';

  // Micro-illustration (viewBox 64).
  static const confirmHapus = '$_dir/confirm_hapus.svg';
  static const buatBaru = '$_dir/buat_baru.svg';
  static const hariIniKosong = '$_dir/hari_ini_kosong.svg';

  /// Animasi centang sukses (Lottie).
  static const successCheck = 'assets/lottie/success_check.json';

  static const List<String> empty = [emptyBeranda, emptyAnggaran, emptyStatistik, emptyKategori];
  static const List<String> micro = [confirmHapus, buatBaru, hariIniKosong];
}

/// Ekspresi maskot Dompi. Hanya untuk momen ringan (empty state, sukses,
/// budget aman) — jangan dipakai di layar over-budget atau error.
enum DompiMood {
  senang('Dompi senang'),
  bangga('Dompi bangga'),
  mengantuk('Dompi mengantuk'),
  waspada('Dompi waspada');

  const DompiMood(this.label);

  /// Label semantik bawaan bila ilustrasi tidak dekoratif.
  final String label;

  String get asset => 'assets/illustrations/dompi/dompi_$name.svg';
}

/// Ikon kategori bawaan (SVG putih 24×24). Path disimpan di SQLite sebagai
/// `Category.icon`, jadi nilainya tidak boleh diubah; ikon baru hanya boleh
/// ditambahkan.
abstract final class CategoryIcons {
  static const basketball = 'assets/uil_basketball.svg';
  static const bookOpen = 'assets/uil_book-open.svg';
  static const carSideview = 'assets/uil_car-sideview.svg';
  static const clapperBoard = 'assets/uil_clapper-board.svg';
  static const gift = 'assets/uil_gift.svg';
  static const home = 'assets/uil_home.svg';
  static const pizzaSlice = 'assets/uil_pizza-slice.svg';
  static const rssAlt = 'assets/uil_rss-alt.svg';
  static const shoppingCart = 'assets/uil_shopping-cart.svg';

  // Tambahan redesign.
  static const coffee = 'assets/uil_coffee.svg';
  static const utensils = 'assets/uil_utensils.svg';
  static const bus = 'assets/uil_bus.svg';
  static const gasStation = 'assets/uil_gas-station.svg';
  static const motorcycle = 'assets/uil_motorcycle.svg';
  static const plane = 'assets/uil_plane.svg';
  static const luggage = 'assets/uil_luggage.svg';
  static const heartPulse = 'assets/uil_heart-pulse.svg';
  static const pill = 'assets/uil_pill.svg';
  static const shirt = 'assets/uil_shirt.svg';
  static const shoppingBag = 'assets/uil_shopping-bag.svg';
  static const scissors = 'assets/uil_scissors.svg';
  static const smartphone = 'assets/uil_smartphone.svg';
  static const wifi = 'assets/uil_wifi.svg';
  static const monitor = 'assets/uil_monitor.svg';
  static const bolt = 'assets/uil_bolt.svg';
  static const droplet = 'assets/uil_droplet.svg';
  static const receipt = 'assets/uil_receipt.svg';
  static const building = 'assets/uil_building.svg';
  static const wrench = 'assets/uil_wrench.svg';
  static const stroller = 'assets/uil_stroller.svg';
  static const paw = 'assets/uil_paw.svg';
  static const gamepad = 'assets/uil_gamepad.svg';
  static const music = 'assets/uil_music.svg';
  static const dumbbell = 'assets/uil_dumbbell.svg';
  static const graduationCap = 'assets/uil_graduation-cap.svg';
  static const briefcase = 'assets/uil_briefcase.svg';
  static const wallet = 'assets/uil_wallet.svg';
  static const money = 'assets/uil_money.svg';
  static const creditCard = 'assets/uil_credit-card.svg';
  static const piggyBank = 'assets/uil_piggy-bank.svg';
  static const chartLine = 'assets/uil_chart-line.svg';
  static const handHeart = 'assets/uil_hand-heart.svg';
  static const tag = 'assets/uil_tag.svg';

  /// Ikon kategori bawaan lama (rilis sebelum redesign), urut seperti `ExpenseType`.
  static const List<String> legacy = [pizzaSlice, rssAlt, bookOpen, gift, carSideview, shoppingCart, home, basketball, clapperBoard];

  /// Semua ikon yang bisa dipilih, urut sesuai tampilan di pemilih ikon.
  static const List<String> all = [
    ...legacy,
    coffee,
    utensils,
    bus,
    gasStation,
    motorcycle,
    plane,
    luggage,
    heartPulse,
    pill,
    shirt,
    shoppingBag,
    scissors,
    smartphone,
    wifi,
    monitor,
    bolt,
    droplet,
    receipt,
    building,
    wrench,
    stroller,
    paw,
    gamepad,
    music,
    dumbbell,
    graduationCap,
    briefcase,
    wallet,
    money,
    creditCard,
    piggyBank,
    chartLine,
    handHeart,
    tag,
  ];

  /// Label untuk screen reader di pemilih ikon.
  static const Map<String, String> labels = {
    pizzaSlice: 'Makanan',
    rssAlt: 'Internet',
    bookOpen: 'Pendidikan',
    gift: 'Hadiah',
    carSideview: 'Transport',
    shoppingCart: 'Belanja',
    home: 'Rumah',
    basketball: 'Olahraga',
    clapperBoard: 'Hiburan',
    coffee: 'Kopi',
    utensils: 'Restoran',
    bus: 'Bus',
    gasStation: 'Bensin',
    motorcycle: 'Motor',
    plane: 'Pesawat',
    luggage: 'Liburan',
    heartPulse: 'Kesehatan',
    pill: 'Obat',
    shirt: 'Pakaian',
    shoppingBag: 'Tas belanja',
    scissors: 'Perawatan',
    smartphone: 'Pulsa',
    wifi: 'Wi-Fi',
    monitor: 'Streaming',
    bolt: 'Listrik',
    droplet: 'Air',
    receipt: 'Tagihan',
    building: 'Sewa',
    wrench: 'Servis',
    stroller: 'Anak',
    paw: 'Hewan peliharaan',
    gamepad: 'Game',
    music: 'Musik',
    dumbbell: 'Gym',
    graduationCap: 'Sekolah',
    briefcase: 'Kerja',
    wallet: 'Dompet',
    money: 'Uang tunai',
    creditCard: 'Kartu kredit',
    piggyBank: 'Tabungan',
    chartLine: 'Investasi',
    handHeart: 'Donasi',
    tag: 'Lainnya',
  };

  static String labelOf(String icon) => labels[icon] ?? 'Ikon kategori';
}

/// Memetakan warna terang bawaan ilustrasi ke token tema aktif, sehingga
/// satu file SVG tampil benar di light dan dark.
///
/// Kunci adalah RGB kontrak ilustrasi (bukan warna UI), alpha asli dipertahankan.
@immutable
class IllustrationColorMapper extends ColorMapper {
  IllustrationColorMapper(AppColors c)
    : _map = {
        0x1B2430: c.ink,
        0x0E8C7F: c.brand,
        0xCDEFE9: c.brandContainer,
        0xFFB547: c.accent,
        0xFFE7C2: c.accentContainer,
        0xFFFFFF: c.surfaceContainerLowest,
        0x1E9E5A: c.incomeFill,
        0xF0634A: c.expenseFill,
      };

  final Map<int, Color> _map;

  @override
  Color substitute(String? id, String elementName, String attributeName, Color color) {
    final target = _map[color.toARGB32() & 0xFFFFFF];
    if (target == null) return color;
    return target.withValues(alpha: target.a * color.a);
  }

  @override
  bool operator ==(Object other) {
    if (other is! IllustrationColorMapper || other._map.length != _map.length) return false;
    for (final e in _map.entries) {
      if (other._map[e.key] != e.value) return false;
    }
    return true;
  }

  @override
  int get hashCode => Object.hashAllUnordered(_map.entries.map((e) => Object.hash(e.key, e.value)));
}

/// Ilustrasi SVG yang warnanya mengikuti tema.
///
/// Jika [semanticLabel] null, ilustrasi dianggap dekoratif dan disembunyikan
/// dari screen reader. Bila aset gagal dimuat, dirender kotak kosong seukuran
/// [size] agar tata letak tidak bergeser.
class AppIllustration extends StatelessWidget {
  const AppIllustration(this.asset, {super.key, this.size = 160, this.semanticLabel});

  /// Maskot Dompi dengan ekspresi [mood].
  AppIllustration.dompi(DompiMood mood, {super.key, this.size = 160, this.semanticLabel}) : asset = mood.asset;

  final String asset;
  final double size;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final box = SizedBox.square(dimension: size);
    return SvgPicture.asset(
      asset,
      width: size,
      height: size,
      colorMapper: IllustrationColorMapper(context.colors),
      semanticsLabel: semanticLabel,
      excludeFromSemantics: semanticLabel == null,
      placeholderBuilder: (_) => box,
      errorBuilder: (_, _, _) => box,
    );
  }
}
