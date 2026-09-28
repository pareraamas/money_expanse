# Wister Lite App

Aplikasi pencatatan keuangan pribadi yang sederhana dan mudah digunakan, dibangun dengan Flutter. Aplikasi ini membantu Anda melacak pengeluaran harian dan bulanan dengan mudah.

## 🚀 Fitur

- 📊 Catat pengeluaran harian dengan mudah
- 📅 Lihat ringkasan pengeluaran harian dan bulanan
- 🏷️ Kategorikan pengeluaran untuk analisis yang lebih baik
- 🔄 Sinkronisasi data lokal dengan SQLite
- 🇮🇩 Antarmuka dalam Bahasa Indonesia

## 📥 Download APK

Anda dapat mengunduh file APK yang sudah di-build untuk berbagai arsitektur:

- [app-armeabi-v7a-release.apk](https://github.com/pareraamas/money_expanse/raw/main/build/app/outputs/flutter-apk/app-armeabi-v7a-release.apk) (15.8MB) - Untuk perangkat lama
- [app-arm64-v8a-release.apk](https://github.com/pareraamas/money_expanse/raw/main/build/app/outputs/flutter-apk/app-arm64-v8a-release.apk) (18.1MB) - Untuk perangkat modern (direkomendasikan)
- [app-x86_64-release.apk](https://github.com/pareraamas/money_expanse/raw/main/build/app/outputs/flutter-apk/app-x86_64-release.apk) (19.3MB) - Untuk emulator x86

>Development Dilakukan di Ios, diandroid mungkin akan sedikit berbeda <span style="color: red;">**(perlu diperhatikan)**</span>

## 📱 Screenshots

| Beranda | Tambah Pengeluaran | Kategori Pengeluaran |
|---------|-------------------|----------------------|
| <img src="screenshoot/Jepretan Layar 2025-09-12 pukul 14.50.30.png" width="200"> | <img src="screenshoot/Jepretan Layar 2025-09-12 pukul 14.52.21.png" width="200"> | <img src="screenshoot/Jepretan Layar 2025-09-12 pukul 14.54.15.png" width="200"> |

## 🛠️ Teknologi yang Digunakan

- **Framework**: Flutter
- **State Management**: GetX
- **Database**: SQLite (sqflite)
- **UI Components**: Material Design 3
- **Lainnya**:
  - intl: Untuk format tanggal dan mata uang
  - pull_to_refresh: Untuk refresh data
  - google_fonts: Untuk tipografi yang lebih baik
  - flutter_svg: Untuk menampilkan ikon SVG

## 🚀 Memulai

### Prasyarat

- Flutter SDK (versi terbaru)
- Dart SDK (versi terbaru)
- Perangkat atau emulator Android/iOS

### Instalasi

1. Clone repositori ini:
   ```bash
   git clone [URL_REPOSITORY]
   cd wister_lite
   ```

2. Install dependencies:
   ```bash
   flutter pub get
   ```

3. Generate kode dengan build_runner (jika diperlukan):
   ```bash
   flutter pub run build_runner build --delete-conflicting-outputs
   ```

4. Build APK untuk semua arsitektur:
   ```bash
   flutter build apk --split-per-abi 
   ```
   
   File APK akan tersedia di folder `build/app/outputs` dengan format:
   - `app-armeabi-v7a-release.apk`
   - `app-arm64-v8a-release.apk`
   - `app-x86_64-release.apk`

3. Jalankan aplikasi:
   ```bash
   flutter run
   ```

## 📝 Cara Penggunaan

1. **Menambahkan Pengeluaran Baru**
   - Tekan tombol "+" di pojok kanan bawah
   - Isi detail pengeluaran (nama, jumlah, kategori, dll.)
   - Tekan "Simpan" untuk menyimpan catatan

2. **Melihat Ringkasan**
   - Lihat ringkasan pengeluaran harian dan bulanan di beranda
   - Scroll ke bawah untuk melihat daftar pengeluaran terkini

3. **Analisis Kategori**
   - Gulir ke bagian tengah beranda untuk melihat pengeluaran berdasarkan kategori
   - Setiap kategori menampilkan total pengeluaran

## 🤝 Berkontribusi

Kontribusi selalu diterima! Berikut cara Anda dapat berkontribusi:

1. Fork Project
2. Buat Branch Fitur Anda (`git checkout -b feature/AmazingFeature`)
3. Commit Perubahan Anda (`git commit -m 'Add some AmazingFeature'`)
4. Push ke Branch (`git push origin feature/AmazingFeature`)
5. Buka Pull Request

## 📄 Lisensi

Distributed under the MIT License. See `LICENSE` for more information.

## ✨ Penghargaan

- [Flutter](https://flutter.dev/)
- [GetX](https://pub.dev/packages/get)
- [Sqflite](https://pub.dev/packages/sqflite)

---

Dibuat dengan ❤️ menggunakan Flutter
