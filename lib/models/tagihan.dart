class Tagihan {
  final String id;
  final String pengeluaranId;
  final String memberId;
  final String penerimaId;
  final int jumlah;
  final String status;
  final DateTime jatuhTempo;
  final DateTime? tanggalBayar;

  Tagihan({
    required this.id,
    required this.pengeluaranId,
    required this.memberId,
    required this.penerimaId,
    required this.jumlah,
    required this.status,
    required this.jatuhTempo,
    this.tanggalBayar,
  });
}
