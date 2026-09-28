# Suite QA redesign (Fase 3)

Jaring pengaman untuk redesign "Dompet yang Ceria" (`docs/redesign/REDESIGN_PLAN.md`).
Semua test memakai `FakeExpenseRepository` di memori dan `Clock.now` terkunci ke
28 September 2026, jadi hasilnya sama setiap hari.

| File | Gerbang | Isi |
| --- | --- | --- |
| `golden_test.dart` | Layar | Golden 16 layar/keadaan × light/dark (4 empty state, sheet, dialog, galeri komponen) |
| `a11y_test.dart` | Rilis | Target sentuh 48 dp, label semantik tap target, kontras teks AA, teks >= 12 sp |
| `materials_test.dart` | Bahan | Aset ilustrasi/ikon ada, SVG < 8 KB & valid, hanya warna kontrak, path ikon lama di SQLite tetap, Lottie valid |
| `component_contrast_test.dart` | Bahan | Kontras pasangan warna token komponen (kartu saldo, keypad, bar anggaran) |
| `text_scale_test.dart` | Rilis | Teks 200% di HP 360×640 tanpa overflow |
| `hardcoded_style_test.dart` | Rilis | 0 `Color(0x…)`, `Colors.*`, `TextStyle(`, `GoogleFonts.*` di `modules/`, `ui/`, `widgets/` |
| `data_parity_test.dart` | Layar | Skenario uji manual lewat UI; isi data harus sama dengan ekspektasi |

Kontras teks di `a11y_test.dart` dihitung dari warna teks & latar di render tree,
bukan dari sampel piksel seperti `textContrastGuideline` bawaan Flutter (yang gagal
palsu pada teks 12 sp dan teks yang tergulir di bawah FAB). Konsekuensinya: latar
dari `Ink`/gambar tidak terbaca, jadi tetap review golden secara visual.

## Menjalankan

```sh
fvm flutter test test/qa                 # semua
fvm flutter test -t gerbang              # hanya gerbang (tanpa golden)
fvm flutter test test/qa/golden_test.dart --update-goldens   # setelah perubahan UI yang disengaja
```

PNG di `goldens/` sekaligus screenshot sebelum/sesudah untuk PR (aturan main #5).

## Saat layar ditulis ulang

- Daftar layar ada di `support/screens.dart`, cara memakai UI di `support/app_driver.dart`.
  Finder mencoba beberapa kandidat (UI lama dan redesign); kalau pesan
  `QA driver: tidak menemukan "…"` muncul, perbarui kandidat di sana.
- Ekspektasi paritas di `data_parity_test.dart` ditulis di level data. Jangan diubah
  untuk membuat test lulus: kalau gagal, perilaku data berubah.
- Label yang diandalkan driver: tab "Beranda"/"Anggaran"/"Statistik", tooltip hapus
  diawali "Hapus", backspace keypad "Hapus digit", chip "Semua", toggle "Keluar"/"Masuk",
  tombol diawali "Simpan".
