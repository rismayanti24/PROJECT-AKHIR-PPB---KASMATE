class Grup {
  final String id;
  final String nama;
  final String tipe;
  final String kodeUndangan;
  final String bendaharaId;
  final List<String> anggotaIds;

  Grup({
    required this.id,
    required this.nama,
    required this.tipe,
    required this.kodeUndangan,
    required this.bendaharaId,
    required this.anggotaIds,
  });
}
