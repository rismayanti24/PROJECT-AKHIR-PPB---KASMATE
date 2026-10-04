import 'item_struk.dart';

class Pengeluaran {
  final String id;
  final String grupId;
  final String judul;
  final String kategori;
  final int total;
  final DateTime tanggal;
  final bool rutin;
  final String sumberDana;
  final String dibayarOleh;
  final List<ItemStruk> items;
  final int pajak;
  final int diskon;

  Pengeluaran({
    required this.id,
    required this.grupId,
    required this.judul,
    required this.kategori,
    required this.total,
    required this.tanggal,
    required this.rutin,
    required this.sumberDana,
    required this.dibayarOleh,
    required this.items,
    this.pajak = 0,
    this.diskon = 0,
  });
}
