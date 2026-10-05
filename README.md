# KasMate

Aplikasi pengelola uang bersama untuk grup (anak kos, teman nongkrong, organisasi, trip). Membantu membagi tagihan dengan adil dan menagih teman tanpa canggung.

Proyek akhir mata kuliah Pemrograman Perangkat Bergerak.
Dosen pengampu: [nama dosen]
Kelas: [kelas]

## Latar Belakang

Anak kos dan kelompok mahasiswa sering kerepotan membagi tagihan bersama (listrik, Wi-Fi, belanja dapur, makan bareng). Catatan di grup WhatsApp tertimbun, hitung manual struk dengan pajak dan diskon rumit, dan banyak yang segan menagih teman yang belum bayar.

KasMate menyatukan pencatatan, pembagian, dan penagihan dalam satu aplikasi.

## Tujuan

- Memudahkan pencatatan pengeluaran bersama dalam satu grup
- Membagi tagihan secara adil (rata atau per barang, termasuk pajak dan diskon)
- Memantau status pembayaran tiap anggota
- Membuat penagihan terasa netral lewat pesan WhatsApp otomatis

## Target Pengguna

Anak kos dan kelompok mahasiswa yang punya pengeluaran bersama. Konsepnya berbasis "grup", sehingga bisa dipakai juga untuk nongkrong, organisasi, trip, dan arisan.

## Fitur

Fitur utama:
- Scan struk belanja (OCR) untuk membaca daftar barang dan harga
- Split bill: bagi rata atau per barang, pajak dan diskon dibagi proporsional
- Tagih via WhatsApp satu klik (pesan berisi nominal dan rekening)
- Dashboard status Belum / Menunggu / Lunas beserta saldo kas

Alur pembayaran:
- Dua model sumber dana: ditalangi anggota atau diambil dari kas bendahara
- Status tagihan 3 tahap: Belum, Menunggu konfirmasi, Lunas
- Pembayar menekan "Saya sudah bayar", penerima menekan "Konfirmasi"
- Tampilan menyesuaikan peran per tagihan (penerima atau pembayar)

Fitur tambahan:
- Skor kedisiplinan bayar
- Grafik pengeluaran per kategori
- Export laporan ke PDF
- Dark mode

## Status Pengembangan

- [x] Widget dasar (status tagihan)
- [ ] Model data dan data dummy
- [ ] Widget lengkap dan halaman Dashboard, Riwayat, Split Bill
- [ ] Alur inti dua peran (dummy)
- [ ] Tagih via WhatsApp
- [ ] Firebase (login, grup, data real-time)
- [ ] Scan struk (OCR)
- [ ] Fitur tambahan

(Centang yang sudah selesai, ubah sesuai progres.)

## Teknologi

- Flutter dan Dart
- Provider (state management)
- Firebase Authentication dan Cloud Firestore (tahap berikutnya)
- Google ML Kit Text Recognition (OCR, tahap berikutnya)
- url_launcher (WhatsApp)

## Struktur Folder

lib/
- main.dart : kerangka aplikasi dan navigasi
- models/ : model data (Pengguna, Grup, Pengeluaran, Tagihan, ItemStruk)
- data/ : data dummy
- widgets/ : komponen kecil yang dipakai ulang
- screens/ : halaman aplikasi
- providers/ : pengelola state
- services/ : akses data, WhatsApp, OCR, dan lainnya

docs/ : proposal, diagram, laporan, pengujian
design/ : wireframe, palet warna, logo
