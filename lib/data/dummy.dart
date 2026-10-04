import '../models/pengguna.dart';
import '../models/grup.dart';
import '../models/item_struk.dart';
import '../models/pengeluaran.dart';
import '../models/tagihan.dart';

final List<Pengguna> dummyPengguna = [
  Pengguna(id: 'u1', nama: 'Andi', noWa: '081111111111', bank: 'BCA', noRekening: '1234567890'),
  Pengguna(id: 'u2', nama: 'Budi', noWa: '082222222222', bank: 'BNI', noRekening: '2345678901'),
  Pengguna(id: 'u3', nama: 'Citra', noWa: '083333333333', bank: 'Mandiri', noRekening: '3456789012'),
  Pengguna(id: 'u4', nama: 'Dewi', noWa: '084444444444', bank: 'BRI', noRekening: '4567890123'),
];

final Grup dummyGrup = Grup(
  id: 'g1',
  nama: 'Kos Melati',
  tipe: 'kos',
  kodeUndangan: 'MELATI2024',
  bendaharaId: 'u1',
  anggotaIds: ['u1', 'u2', 'u3', 'u4'],
);

final List<Pengeluaran> dummyPengeluaran = [
  Pengeluaran(
    id: 'p1',
    grupId: 'g1',
    judul: 'Listrik Oktober',
    kategori: 'Utilitas',
    total: 400000,
    tanggal: DateTime(2024, 10, 1),
    rutin: true,
    sumberDana: 'kas',
    dibayarOleh: 'u1',
    items: [],
  ),
  Pengeluaran(
    id: 'p2',
    grupId: 'g1',
    judul: 'Wi-Fi Oktober',
    kategori: 'Utilitas',
    total: 350000,
    tanggal: DateTime(2024, 10, 2),
    rutin: true,
    sumberDana: 'kas',
    dibayarOleh: 'u1',
    items: [],
  ),
  Pengeluaran(
    id: 'p3',
    grupId: 'g1',
    judul: 'Belanja Dapur',
    kategori: 'Belanja',
    total: 260000,
    tanggal: DateTime(2024, 10, 3),
    rutin: false,
    sumberDana: 'talangan',
    dibayarOleh: 'u3',
    items: [
      ItemStruk(namaBarang: 'Beras', harga: 75000),
      ItemStruk(namaBarang: 'Minyak', harga: 35000),
      ItemStruk(namaBarang: 'Telur', harga: 30000),
      ItemStruk(namaBarang: 'Bumbu', harga: 40000),
      ItemStruk(namaBarang: 'Sabun', harga: 30000),
      ItemStruk(namaBarang: 'Gas', harga: 50000),
    ],
  ),
  Pengeluaran(
    id: 'p4',
    grupId: 'g1',
    judul: 'Makan Bareng',
    kategori: 'Makanan',
    total: 160000, // Adjusted to match item total (40k per person)
    tanggal: DateTime(2024, 10, 4),
    rutin: false,
    sumberDana: 'talangan',
    dibayarOleh: 'u2',
    items: [
      ItemStruk(namaBarang: 'Nasi Goreng x4', harga: 100000),
      ItemStruk(namaBarang: 'Es Teh x4', harga: 20000),
      ItemStruk(namaBarang: 'Kerupuk x4', harga: 40000),
    ],
  ),
];

final List<Tagihan> dummyTagihan = [
  // p1 (Listrik) - Kas - 400k - u1
  Tagihan(id: 't1_1', pengeluaranId: 'p1', memberId: 'u2', penerimaId: 'u1', jumlah: 100000, status: 'belum', jatuhTempo: DateTime(2024, 10, 10)),
  Tagihan(id: 't1_2', pengeluaranId: 'p1', memberId: 'u3', penerimaId: 'u1', jumlah: 100000, status: 'menunggu', jatuhTempo: DateTime(2024, 10, 10)),
  Tagihan(id: 't1_3', pengeluaranId: 'p1', memberId: 'u4', penerimaId: 'u1', jumlah: 100000, status: 'lunas', jatuhTempo: DateTime(2024, 10, 10), tanggalBayar: DateTime(2024, 10, 2)),
  
  // p2 (Wi-Fi) - Kas - 350k - u1
  Tagihan(id: 't2_1', pengeluaranId: 'p2', memberId: 'u2', penerimaId: 'u1', jumlah: 87500, status: 'lunas', jatuhTempo: DateTime(2024, 10, 10), tanggalBayar: DateTime(2024, 10, 3)),
  Tagihan(id: 't2_2', pengeluaranId: 'p2', memberId: 'u3', penerimaId: 'u1', jumlah: 87500, status: 'belum', jatuhTempo: DateTime(2024, 10, 10)),
  Tagihan(id: 't2_3', pengeluaranId: 'p2', memberId: 'u4', penerimaId: 'u1', jumlah: 87500, status: 'menunggu', jatuhTempo: DateTime(2024, 10, 10)),
  
  // p3 (Belanja Dapur) - Talangan - 260k - u3
  Tagihan(id: 't3_1', pengeluaranId: 'p3', memberId: 'u1', penerimaId: 'u3', jumlah: 65000, status: 'belum', jatuhTempo: DateTime(2024, 10, 10)),
  Tagihan(id: 't3_2', pengeluaranId: 'p3', memberId: 'u2', penerimaId: 'u3', jumlah: 65000, status: 'menunggu', jatuhTempo: DateTime(2024, 10, 10)),
  Tagihan(id: 't3_3', pengeluaranId: 'p3', memberId: 'u4', penerimaId: 'u3', jumlah: 65000, status: 'lunas', jatuhTempo: DateTime(2024, 10, 10), tanggalBayar: DateTime(2024, 10, 4)),
  
  // p4 (Makan Bareng) - Talangan - 160k - u2
  Tagihan(id: 't4_1', pengeluaranId: 'p4', memberId: 'u1', penerimaId: 'u2', jumlah: 40000, status: 'lunas', jatuhTempo: DateTime(2024, 10, 10), tanggalBayar: DateTime(2024, 10, 4)),
  Tagihan(id: 't4_2', pengeluaranId: 'p4', memberId: 'u3', penerimaId: 'u2', jumlah: 40000, status: 'belum', jatuhTempo: DateTime(2024, 10, 10)),
  Tagihan(id: 't4_3', pengeluaranId: 'p4', memberId: 'u4', penerimaId: 'u2', jumlah: 40000, status: 'menunggu', jatuhTempo: DateTime(2024, 10, 10)),
];
