# Wister Lite

Aplikasi pencatatan keuangan pribadi yang sederhana dan mudah digunakan, dibangun dengan Flutter. Catat pemasukan dan pengeluaran, atur budget per kategori, lihat statistik bulanan, lalu ekspor atau bagikan laporannya. Semua data tersimpan lokal di perangkat.

## 🚀 Fitur

- 💸 **Catat transaksi**: pemasukan dan pengeluaran, dengan keypad nominal khusus
- 🏷️ **Kategori kustom**: buat, ubah, dan hapus kategori sendiri
- 🎯 **Budget bulanan**: batas per kategori, progres, dan penanda *pace* untuk bulan berjalan
- 📊 **Statistik**: ringkasan bulanan dan grafik per kategori (fl_chart)
- 🗂️ **Riwayat transaksi**: dikelompokkan per tanggal, dengan filter jenis transaksi
- 📤 **Ekspor laporan**: Excel (`.xlsx`), PDF, atau CSV
- 📥 **Impor data**: dari CSV / Excel, dengan layar pratinjau (deteksi duplikat, kategori baru, dan baris bermasalah) sebelum disimpan
- 🖼️ **Kartu ringkasan**: bagikan ringkasan keuangan sebagai gambar
- 🐣 **Maskot Dompi** untuk empty state dan momen sukses
- 💾 Penyimpanan lokal dengan SQLite, tanpa akun atau internet
- 🇮🇩 Antarmuka dalam Bahasa Indonesia

### Format file impor

Kolom dikenali dari nama header (tidak peka huruf besar/kecil). Kolom wajib: **tanggal**, **kategori**, **jumlah**.

| Kolom | Nama yang dikenali |
|-------|--------------------|
| Tanggal *(wajib)* | `tanggal`, `tgl`, `date`, `waktu`, `datetime` |
| Kategori *(wajib)* | `kategori`, `category` |
| Jumlah *(wajib)* | `jumlah`, `nominal`, `amount`, `harga`, `price`, `total` |
| Jenis | `jenis`, `tipe`, `type`, `transaction_type` |
| Catatan | `nama`, `catatan`, `keterangan`, `deskripsi`, `name`, `note` |
| ID | `id` |

File hasil ekspor CSV/Excel dari aplikasi ini bisa langsung diimpor kembali.

## 📥 Download APK

- [app-release.apk](https://github.com/pareraamas/wister_lite/raw/main/build/app/outputs/flutter-apk/app-release.apk) (±27 MB), APK universal untuk semua perangkat Android

Checksum SHA-1 tersedia di [`app-release.apk.sha1`](build/app/outputs/flutter-apk/app-release.apk.sha1).

> Development dilakukan di iOS, jadi tampilan di Android mungkin sedikit berbeda.

## 📱 Screenshots

| Beranda | Tambah Pengeluaran | Kategori Pengeluaran |
|---------|-------------------|----------------------|
| <img src="screenshoot/Jepretan Layar 2025-09-12 pukul 14.50.30.png" width="200"> | <img src="screenshoot/Jepretan Layar 2025-09-12 pukul 14.52.21.png" width="200"> | <img src="screenshoot/Jepretan Layar 2025-09-12 pukul 14.54.15.png" width="200"> |

## 🛠️ Teknologi

- **Framework**: Flutter 3.47.4 (dikunci via [FVM](https://fvm.app/), lihat `.fvmrc`)
- **State management & routing**: GetX
- **Database**: SQLite (`sqflite`)
- **UI**: Material Design 3 dengan design tokens sendiri (`lib/app/theme/tokens`), `google_fonts`, `phosphor_flutter`, `flutter_animate`, `lottie`, `flutter_svg`
- **Grafik**: `fl_chart`
- **Impor/ekspor**: `csv`, `excel_community`, `pdf`, `file_picker`, `share_plus`
- **Code generation**: `freezed`, `json_serializable`, `flutter_gen`

## 📂 Struktur Proyek

```
lib/app/
├── data/        # model, database lokal, repository, service impor/ekspor
├── modules/     # fitur (pola GetX: bindings / controllers / views)
│   ├── home, budget, statistik, transaction_history
│   ├── expanse_create, category_create, category_list
│   └── import_preview, share_card, main_nav
├── routes/      # definisi route GetX
├── theme/       # tema & design tokens (warna, spacing, radius, tipografi, motion)
├── ui/          # komponen UI bersama (+ gallery komponen untuk QA)
└── widgets/
```

## 🚀 Memulai

### Prasyarat

- Flutter 3.47.4 (disarankan lewat FVM)
- Perangkat atau emulator Android/iOS

### Instalasi

1. Clone repositori:
   ```bash
   git clone https://github.com/pareraamas/wister_lite.git
   cd wister_lite
   ```

2. Install dependencies:
   ```bash
   fvm flutter pub get   # atau: flutter pub get
   ```

3. Generate kode (setelah mengubah model freezed/json atau aset):
   ```bash
   dart run build_runner build --delete-conflicting-outputs
   ```

4. Jalankan aplikasi:
   ```bash
   flutter run
   ```

5. Jalankan test:
   ```bash
   flutter test
   ```

### Build APK

```bash
flutter build apk --release
```

File hasil build ada di `build/app/outputs/flutter-apk/app-release.apk`. APK disimpan di repo lewat **Git LFS**, jadi pastikan `git lfs install` sudah dijalankan sebelum commit APK baru.

## 📝 Cara Penggunaan

1. **Tambah transaksi**: tekan tombol "+", pilih pemasukan atau pengeluaran, isi nominal, kategori, dan catatan, lalu simpan.
2. **Atur budget**: buka tab Budget dan tentukan batas bulanan per kategori.
3. **Lihat statistik**: buka tab Statistik untuk ringkasan dan grafik per bulan; ganti bulan lewat pemilih bulan.
4. **Ekspor / impor**: dari halaman Statistik, ekspor laporan ke Excel, PDF, atau CSV, atau impor file CSV/Excel lalu periksa pratinjaunya sebelum disimpan.
5. **Bagikan**: dari halaman Statistik, buat kartu ringkasan dan bagikan sebagai gambar.

## 🤝 Berkontribusi

1. Fork repositori
2. Buat branch fitur (`git checkout -b feature/NamaFitur`)
3. Commit perubahan (`git commit -m 'feat: tambah NamaFitur'`)
4. Push ke branch (`git push origin feature/NamaFitur`)
5. Buka Pull Request

## ✨ Penghargaan

- [Flutter](https://flutter.dev/)
- [GetX](https://pub.dev/packages/get)
- [Sqflite](https://pub.dev/packages/sqflite)
- [fl_chart](https://pub.dev/packages/fl_chart)

---

Dibuat dengan ❤️ menggunakan Flutter
