# Sketsa gaya Dompi

Tiga arah gaya untuk maskot Dompi (ekspresi netral/senang), dibuat sebelum set final. Semua memakai palet kontrak ilustrasi yang sama, jadi bisa di-remap ke token tema untuk mode gelap. Lihat `preview.png` untuk ketiga sketsa dan set final berdampingan.

| File | Gaya | Ciri | Catatan |
| --- | --- | --- | --- |
| `sketch_a_referensi.svg` | **A. Setia referensi** | Persis gambar di rencana: kotak bulat geometris, pegangan di atas, garis teal, isian teal muda | Rapi, tapi terbaca seperti kotak bekal. Garis teal kurang kontras di atas isian teal muda |
| `sketch_b_tonal_tangan.svg` | **B. Tonal gambar tangan** | Garis tinta 2 px, sudut bulat, sedikit miring seperti gambar tangan. Tutup dompet teal dengan kancing mangga, badan teal muda, kilau putih kecil, kaki berujung | Paling jelas "dompet". Tetap terbaca di ukuran 96 px |
| `sketch_c_stiker_flat.svg` | **C. Stiker flat** | Tanpa garis luar; bidang warna tebal (badan teal, tutup mangga), wajah putih | Berani dan modern, tapi keluar dari prinsip "line-art 2 px" dan lebih mirip gaya ilustrasi generik |

## Pilihan sementara: B (Tonal gambar tangan)

Gaya B paling cocok dengan bagian "Ilustrasi kecil" di `REDESIGN_PLAN.md`: garis 2 px, sudut membulat, isian datar tonal, dan sedikit tidak sempurna seperti gambar tangan. Tutup dengan kancing membuat Dompi langsung terbaca sebagai dompet, bukan kotak. Garis tinta juga memberi kontras yang cukup di mode terang maupun gelap.

Set final (`assets/illustrations/dompi/`) dan semua ilustrasi lain (empty state, dialog hapus, tile "Buat baru", micro "hari ini", 9 ikon kategori) memakai gaya B.

**Status: menunggu konfirmasi pemilik di Gerbang Bahan.** Kalau pemilik memilih A atau C, set final digambar ulang dengan gaya tersebut. Nama file tetap sama.

## Kontrak warna

Ilustrasi hanya memakai 9 warna berikut. Aplikasi mengganti warna ini dengan token tema saat runtime:

`#1B2430` tinta · `#0E8C7F` brand · `#CDEFE9` brand container · `#FFB547` mangga · `#FFE7C2` mangga container · `#FFFFFF` permukaan · `#1E9E5A` pemasukan · `#F0634A` pengeluaran · `#F2A7B5` pipi (tidak di-remap)

Cek otomatis: `python3 tool/check_illustrations.py`
