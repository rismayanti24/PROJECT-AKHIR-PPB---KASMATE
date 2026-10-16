import '../models/tagihan.dart';

int hitungSkorKedisiplinan(Iterable<Tagihan> riwayatPembayaran) {
  var totalSkor = 0;
  var jumlahDinilai = 0;

  for (final tagihan in riwayatPembayaran) {
    switch (tagihan.status.trim().toLowerCase()) {
      case 'lunas':
        final tanggalBayar = tagihan.tanggalBayar;
        if (tanggalBayar == null) {
          continue;
        }

        final tanggalPembayaran = DateTime(
          tanggalBayar.year,
          tanggalBayar.month,
          tanggalBayar.day,
        );
        final jatuhTempo = DateTime(
          tagihan.jatuhTempo.year,
          tagihan.jatuhTempo.month,
          tagihan.jatuhTempo.day,
        );

        totalSkor += tanggalPembayaran.isAfter(jatuhTempo) ? 50 : 100;
        jumlahDinilai++;
      case 'belum':
        totalSkor += 0;
        jumlahDinilai++;
    }
  }

  if (jumlahDinilai == 0) {
    return 0;
  }

  return (totalSkor / jumlahDinilai).round();
}
