import 'dart:math';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'profil_store.dart';

String formatRupiah(int nominal) {
  final isNegatif = nominal < 0;
  final angka = nominal.abs().toString();
  final buffer = StringBuffer();
  for (int i = 0; i < angka.length; i++) {
    final posisiDariKanan = angka.length - i;
    buffer.write(angka[i]);
    if (posisiDariKanan > 1 && posisiDariKanan % 3 == 1) {
      buffer.write('.');
    }
  }
  return '${isNegatif ? '-Rp ' : 'Rp '}${buffer.toString()}';
}

enum StatusBayar { lunas, menunggu, belum }

class AnggotaKas {
  final String id;
  final String nama;
  final String noWa;
  final int tagihan;
  final StatusBayar status;
  final Color avatarColor;

  const AnggotaKas({
    required this.id,
    required this.nama,
    required this.noWa,
    required this.tagihan,
    required this.status,
    required this.avatarColor,
  });

  AnggotaKas copyWith({
    String? nama,
    String? noWa,
    int? tagihan,
    StatusBayar? status,
  }) {
    return AnggotaKas(
      id: id,
      nama: nama ?? this.nama,
      noWa: noWa ?? this.noWa,
      tagihan: tagihan ?? this.tagihan,
      status: status ?? this.status,
      avatarColor: avatarColor,
    );
  }
}

class ItemBelanja {
  final String id;
  final String nama;
  final int harga;

  const ItemBelanja({
    required this.id,
    required this.nama,
    required this.harga,
  });
}

class TagihanKas {
  final String id;
  final String judul;
  final String tanggal;
  final String sumberDana;
  final List<ItemBelanja> items;
  final int subtotal;
  final int pajak;
  final int total;
  final int porsiPerOrang;

  const TagihanKas({
    required this.id,
    required this.judul,
    required this.tanggal,
    required this.sumberDana,
    required this.items,
    required this.subtotal,
    required this.pajak,
    required this.total,
    required this.porsiPerOrang,
  });
}

class KonfirmasiItem {
  final String id;
  final String anggotaId;
  final String namaAnggota;
  final String judulTagihan;
  final int nominal;
  final String namaFileBukti;
  final String buktiPath;
  final String waktuUnggah;

  const KonfirmasiItem({
    required this.id,
    required this.anggotaId,
    required this.namaAnggota,
    required this.judulTagihan,
    required this.nominal,
    required this.namaFileBukti,
    required this.buktiPath,
    required this.waktuUnggah,
  });
}

class RiwayatPembayaranItem {
  final String id;
  final String namaAnggota;
  final String judulTagihan;
  final int nominal;
  final String waktu;
  final String status; // 'Lunas' atau 'Ditolak'
  final String buktiPath;

  const RiwayatPembayaranItem({
    required this.id,
    required this.namaAnggota,
    required this.judulTagihan,
    required this.nominal,
    required this.waktu,
    required this.status,
    required this.buktiPath,
  });
}

class GrupKas {
  final String id;
  final String namaGrup;
  final String kodeUndangan;
  final String bendahara;
  final int saldo;
  final int pemasukan;
  final int pengeluaran;
  final List<AnggotaKas> anggota;
  final List<TagihanKas> daftarTagihan;
  final List<KonfirmasiItem> daftarKonfirmasi;
  final List<RiwayatPembayaranItem> daftarRiwayatPembayaran;

  const GrupKas({
    required this.id,
    required this.namaGrup,
    required this.kodeUndangan,
    required this.bendahara,
    required this.saldo,
    required this.pemasukan,
    required this.pengeluaran,
    required this.anggota,
    required this.daftarTagihan,
    required this.daftarKonfirmasi,
    required this.daftarRiwayatPembayaran,
  });

  String get linkUndangan => 'https://kasmate.app/join/$kodeUndangan';

  GrupKas copyWith({
    String? namaGrup,
    String? kodeUndangan,
    String? bendahara,
    int? saldo,
    int? pemasukan,
    int? pengeluaran,
    List<AnggotaKas>? anggota,
    List<TagihanKas>? daftarTagihan,
    List<KonfirmasiItem>? daftarKonfirmasi,
    List<RiwayatPembayaranItem>? daftarRiwayatPembayaran,
  }) {
    return GrupKas(
      id: id,
      namaGrup: namaGrup ?? this.namaGrup,
      kodeUndangan: kodeUndangan ?? this.kodeUndangan,
      bendahara: bendahara ?? this.bendahara,
      saldo: saldo ?? this.saldo,
      pemasukan: pemasukan ?? this.pemasukan,
      pengeluaran: pengeluaran ?? this.pengeluaran,
      anggota: anggota ?? this.anggota,
      daftarTagihan: daftarTagihan ?? this.daftarTagihan,
      daftarKonfirmasi: daftarKonfirmasi ?? this.daftarKonfirmasi,
      daftarRiwayatPembayaran:
          daftarRiwayatPembayaran ?? this.daftarRiwayatPembayaran,
    );
  }
}

class KasRootState {
  final String aktifGrupId;
  final List<GrupKas> daftarGrup;

  const KasRootState({
    required this.aktifGrupId,
    required this.daftarGrup,
  });

  GrupKas get grupAktif => daftarGrup.firstWhere(
        (g) => g.id == aktifGrupId,
        orElse: () => daftarGrup.first,
      );
}

class KasStore extends ValueNotifier<KasRootState> {
  KasStore()
      : super(
          KasRootState(
            aktifGrupId: 'g1',
            daftarGrup: [
              const GrupKas(
                id: 'g1',
                namaGrup: 'Kas Kos 2B',
                kodeUndangan: 'KS2B-7X4Q',
                bendahara: 'Ir. Fadhil S.T M.kom',
                saldo: 480000,
                pemasukan: 720000,
                pengeluaran: 240000,
                anggota: [
                  AnggotaKas(
                    id: 'a1',
                    nama: 'Ir. Fadhil S.T M.kom',
                    noWa: '6281234567890',
                    tagihan: 0,
                    status: StatusBayar.lunas,
                    avatarColor: Color(0xFFDBEAFE),
                  ),
                  AnggotaKas(
                    id: 'a2',
                    nama: 'Eyyin Cumil',
                    noWa: '6281234567891',
                    tagihan: 20167,
                    status: StatusBayar.belum,
                    avatarColor: Color(0xFFFCE7F3),
                  ),
                  AnggotaKas(
                    id: 'a3',
                    nama: 'Rismayanti',
                    noWa: '6281234567892',
                    tagihan: 20167,
                    status: StatusBayar.belum,
                    avatarColor: Color(0xFFFCE7F3),
                  ),
                  AnggotaKas(
                    id: 'a4',
                    nama: 'Ronaldo',
                    noWa: '6281234567893',
                    tagihan: 20167,
                    status: StatusBayar.menunggu,
                    avatarColor: Color(0xFFDBEAFE),
                  ),
                ],
                daftarTagihan: [
                  TagihanKas(
                    id: 't1',
                    judul: 'Belanja dapur',
                    tanggal: '12 Nov 2026',
                    sumberDana: 'Kas grup',
                    items: [
                      ItemBelanja(id: 'i1', nama: 'Indomie 3pcs', harga: 9000),
                      ItemBelanja(id: 'i2', nama: 'Telur 1kg', harga: 28000),
                      ItemBelanja(
                          id: 'i3', nama: 'Minyak goreng', harga: 18000),
                    ],
                    subtotal: 55000,
                    pajak: 5500,
                    total: 60500,
                    porsiPerOrang: 20167,
                  ),
                ],
                daftarKonfirmasi: [
                  KonfirmasiItem(
                    id: 'k1',
                    anggotaId: 'a4',
                    namaAnggota: 'Ronaldo',
                    judulTagihan: 'Belanja dapur',
                    nominal: 20167,
                    namaFileBukti: 'bukti_transfer_ronaldo.jpg',
                    buktiPath: '',
                    waktuUnggah: '12 Nov 2026, 20:14',
                  ),
                ],
                daftarRiwayatPembayaran: [
                  RiwayatPembayaranItem(
                    id: 'rp1',
                    namaAnggota: 'Ir. Fadhil S.T M.kom',
                    judulTagihan: 'Iuran Kas Bulanan',
                    nominal: 100000,
                    waktu: '01 Nov 2026, 09:30',
                    status: 'Lunas',
                    buktiPath: '',
                  ),
                ],
              ),
              const GrupKas(
                id: 'g2',
                namaGrup: 'Kas Kelas TI-B',
                kodeUndangan: 'TIB2-9M3K',
                bendahara: 'Rismayanti',
                saldo: 350000,
                pemasukan: 500000,
                pengeluaran: 150000,
                anggota: [
                  AnggotaKas(
                    id: 'b1',
                    nama: 'Rismayanti',
                    noWa: '6281234567892',
                    tagihan: 0,
                    status: StatusBayar.lunas,
                    avatarColor: Color(0xFFFCE7F3),
                  ),
                  AnggotaKas(
                    id: 'b2',
                    nama: 'Farel',
                    noWa: '6281234567894',
                    tagihan: 25000,
                    status: StatusBayar.belum,
                    avatarColor: Color(0xFFDBEAFE),
                  ),
                ],
                daftarTagihan: [],
                daftarKonfirmasi: [],
                daftarRiwayatPembayaran: [],
              ),
            ],
          ),
        );

  static const List<Color> _palette = [
    Color(0xFFDBEAFE),
    Color(0xFFFCE7F3),
    Color(0xFFFEF3C7),
    Color(0xFFE0E7FF),
  ];

  GrupKas get grupAktif => value.grupAktif;
  List<GrupKas> get daftarGrup => value.daftarGrup;

  void _updateGrupAktif(GrupKas updated) {
    final listBaru =
        value.daftarGrup.map((g) => g.id == updated.id ? updated : g).toList();
    value = KasRootState(aktifGrupId: updated.id, daftarGrup: listBaru);
  }

  String _formatNomorWa(String raw) {
    final bersih = raw.replaceAll(RegExp(r'[^0-9]'), '');
    if (bersih.startsWith('0')) {
      return '62${bersih.substring(1)}';
    }
    if (!bersih.startsWith('62') && bersih.isNotEmpty) {
      return '62$bersih';
    }
    return bersih;
  }

  String _waktuSekarangLengkap() {
    final now = DateTime.now();
    const bulan = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'Mei',
      'Jun',
      'Jul',
      'Agu',
      'Sep',
      'Okt',
      'Nov',
      'Des'
    ];
    final jam =
        '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';
    return '${now.day} ${bulan[now.month - 1]} ${now.year}, $jam';
  }

  String _tanggalSekarang() {
    final now = DateTime.now();
    const bulan = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'Mei',
      'Jun',
      'Jul',
      'Agu',
      'Sep',
      'Okt',
      'Nov',
      'Des'
    ];
    return '${now.day} ${bulan[now.month - 1]} ${now.year}';
  }

  // ==================== GRUP & UNDANGAN ====================

  GrupKas buatGrupBaru(String namaGrup, String kodeUndangan) {
    final namaUser = profilNotifier.value.nama.isEmpty
        ? 'Bendahara Utama'
        : profilNotifier.value.nama;
    final waUser = profilNotifier.value.noWa.isEmpty
        ? '6281200000000'
        : _formatNomorWa(profilNotifier.value.noWa);

    final grupBaru = GrupKas(
      id: 'g_${DateTime.now().millisecondsSinceEpoch}',
      namaGrup: namaGrup.trim(),
      kodeUndangan: kodeUndangan.trim().toUpperCase(),
      bendahara: namaUser,
      saldo: 0,
      pemasukan: 0,
      pengeluaran: 0,
      anggota: [
        AnggotaKas(
          id: 'a_${DateTime.now().millisecondsSinceEpoch}',
          nama: namaUser,
          noWa: waUser,
          tagihan: 0,
          status: StatusBayar.lunas,
          avatarColor: const Color(0xFFDBEAFE),
        ),
      ],
      daftarTagihan: const [],
      daftarKonfirmasi: const [],
      daftarRiwayatPembayaran: const [],
    );

    value = KasRootState(
      aktifGrupId: grupBaru.id,
      daftarGrup: [grupBaru, ...value.daftarGrup],
    );
    return grupBaru;
  }

  GrupKas? cariGrupByKode(String kode) {
    final target = kode.trim().toUpperCase();
    if (target.isEmpty) return null;
    for (final g in value.daftarGrup) {
      if (g.kodeUndangan.toUpperCase() == target) {
        return g;
      }
    }
    return null;
  }

  bool gabungGrup(String kode) {
    final ditemukan = cariGrupByKode(kode);
    if (ditemukan == null) return false;

    final namaUser = profilNotifier.value.nama.isEmpty
        ? 'Anggota Baru'
        : profilNotifier.value.nama;
    final waUser = _formatNomorWa(profilNotifier.value.noWa);

    final sudahAda = ditemukan.anggota.any(
      (a) => a.nama.toLowerCase() == namaUser.toLowerCase(),
    );

    final daftarAnggotaBaru = List<AnggotaKas>.from(ditemukan.anggota);
    if (!sudahAda) {
      daftarAnggotaBaru.add(
        AnggotaKas(
          id: 'a_${DateTime.now().millisecondsSinceEpoch}',
          nama: namaUser,
          noWa: waUser,
          tagihan: 0,
          status: StatusBayar.lunas,
          avatarColor: _palette[daftarAnggotaBaru.length % _palette.length],
        ),
      );
    }

    final grupTerupdate = ditemukan.copyWith(anggota: daftarAnggotaBaru);
    _updateGrupAktif(grupTerupdate);
    return true;
  }

  void pilihGrupAktif(String grupId) {
    value = KasRootState(
      aktifGrupId: grupId,
      daftarGrup: value.daftarGrup,
    );
  }

  // ==================== CREATE ====================

  void tambahAnggota({required String nama, required String noWa}) {
    final g = grupAktif;
    final baru = AnggotaKas(
      id: 'a_${DateTime.now().millisecondsSinceEpoch}',
      nama: nama.trim(),
      noWa: _formatNomorWa(noWa),
      tagihan: 0,
      status: StatusBayar.lunas,
      avatarColor: _palette[g.anggota.length % _palette.length],
    );
    _updateGrupAktif(g.copyWith(anggota: [...g.anggota, baru]));
  }

  void tambahTagihan({
    required String judul,
    required String sumberDana,
    required List<ItemBelanja> items,
    required List<String> idAnggotaDitagih,
  }) {
    final g = grupAktif;
    final subtotal = items.fold<int>(0, (sum, item) => sum + item.harga);
    final pajak = (subtotal * 0.1).round();
    final total = subtotal + pajak;

    final targetIds = idAnggotaDitagih.isEmpty
        ? g.anggota.map((e) => e.id).toList()
        : idAnggotaDitagih;

    final porsi = targetIds.isEmpty ? total : (total / targetIds.length).ceil();

    final tagihanBaru = TagihanKas(
      id: 't_${DateTime.now().millisecondsSinceEpoch}',
      judul: judul.trim().isEmpty ? 'Pengeluaran Baru' : judul.trim(),
      tanggal: _tanggalSekarang(),
      sumberDana: sumberDana,
      items: List<ItemBelanja>.from(items),
      subtotal: subtotal,
      pajak: pajak,
      total: total,
      porsiPerOrang: porsi,
    );

    final anggotaTerupdate = g.anggota.map((anggota) {
      if (targetIds.contains(anggota.id)) {
        return anggota.copyWith(
          tagihan: anggota.tagihan + porsi,
          status: StatusBayar.belum,
        );
      }
      return anggota;
    }).toList();

    final kurangiKas = sumberDana == 'Kas grup';

    _updateGrupAktif(
      g.copyWith(
        saldo: kurangiKas ? g.saldo - total : g.saldo,
        pengeluaran: g.pengeluaran + total,
        anggota: anggotaTerupdate,
        daftarTagihan: [tagihanBaru, ...g.daftarTagihan],
      ),
    );
  }

  // ==================== UPDATE ====================

  void ajukanPembayaran({
    required String anggotaId,
    required String namaFileBukti,
    required String buktiPath,
  }) {
    final g = grupAktif;
    final target = g.anggota.firstWhere((a) => a.id == anggotaId);
    final judulAktif =
        g.daftarTagihan.isNotEmpty ? g.daftarTagihan.first.judul : 'Iuran Kas';

    final konfirmasiBaru = KonfirmasiItem(
      id: 'k_${DateTime.now().millisecondsSinceEpoch}',
      anggotaId: target.id,
      namaAnggota: target.nama,
      judulTagihan: judulAktif,
      nominal: target.tagihan > 0 ? target.tagihan : 20167,
      namaFileBukti: namaFileBukti,
      buktiPath: buktiPath,
      waktuUnggah: _waktuSekarangLengkap(),
    );

    final anggotaTerupdate = g.anggota.map((a) {
      if (a.id == anggotaId) {
        return a.copyWith(status: StatusBayar.menunggu);
      }
      return a;
    }).toList();

    final konfirmasiBersih =
        g.daftarKonfirmasi.where((k) => k.anggotaId != anggotaId).toList();

    _updateGrupAktif(
      g.copyWith(
        anggota: anggotaTerupdate,
        daftarKonfirmasi: [konfirmasiBaru, ...konfirmasiBersih],
      ),
    );
  }

  void verifikasiPembayaran(String konfirmasiId, {required bool diterima}) {
    final g = grupAktif;
    final item = g.daftarKonfirmasi.firstWhere((k) => k.id == konfirmasiId);

    final anggotaTerupdate = g.anggota.map((a) {
      if (a.id == item.anggotaId) {
        return a.copyWith(
          status: diterima ? StatusBayar.lunas : StatusBayar.belum,
          tagihan: diterima ? 0 : a.tagihan,
        );
      }
      return a;
    }).toList();

    final sisaKonfirmasi =
        g.daftarKonfirmasi.where((k) => k.id != konfirmasiId).toList();

    final riwayatBaru = RiwayatPembayaranItem(
      id: 'rp_${DateTime.now().millisecondsSinceEpoch}',
      namaAnggota: item.namaAnggota,
      judulTagihan: item.judulTagihan,
      nominal: item.nominal,
      waktu: _waktuSekarangLengkap(),
      status: diterima ? 'Lunas' : 'Ditolak',
      buktiPath: item.buktiPath,
    );

    _updateGrupAktif(
      g.copyWith(
        saldo: diterima ? g.saldo + item.nominal : g.saldo,
        pemasukan: diterima ? g.pemasukan + item.nominal : g.pemasukan,
        anggota: anggotaTerupdate,
        daftarKonfirmasi: sisaKonfirmasi,
        daftarRiwayatPembayaran: [riwayatBaru, ...g.daftarRiwayatPembayaran],
      ),
    );
  }

  // ==================== DELETE ====================

  void hapusTagihan(String tagihanId) {
    final g = grupAktif;
    final target = g.daftarTagihan.firstWhere((t) => t.id == tagihanId);
    final kembalikanKas = target.sumberDana == 'Kas grup';

    _updateGrupAktif(
      g.copyWith(
        saldo: kembalikanKas ? g.saldo + target.total : g.saldo,
        pengeluaran: max(0, g.pengeluaran - target.total),
        daftarTagihan: g.daftarTagihan.where((t) => t.id != tagihanId).toList(),
      ),
    );
  }

  void hapusAnggota(String anggotaId) {
    final g = grupAktif;
    _updateGrupAktif(
      g.copyWith(
        anggota: g.anggota.where((a) => a.id != anggotaId).toList(),
        daftarKonfirmasi:
            g.daftarKonfirmasi.where((k) => k.anggotaId != anggotaId).toList(),
      ),
    );
  }

  // ==================== WHATSAPP LAUNCHER ====================

  Future<bool> _bukaUrlWhatsApp(Uri uri) async {
    try {
      final dibukaExternal = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );
      if (dibukaExternal) return true;
    } catch (_) {}

    try {
      return await launchUrl(uri, mode: LaunchMode.platformDefault);
    } catch (_) {
      return false;
    }
  }

  Future<bool> kirimTagihanWhatsApp(AnggotaKas anggota) async {
    final g = grupAktif;
    final profil = profilNotifier.value;
    final bank = profil.bank.isEmpty ? 'BCA' : profil.bank;
    final rekening =
        profil.noRekening.isEmpty ? '8820 1122 33' : profil.noRekening;
    final penerima = profil.nama.isEmpty ? g.bendahara : profil.nama;
    final judulTagihan =
        g.daftarTagihan.isNotEmpty ? g.daftarTagihan.first.judul : 'Iuran Kas';
    final nominalText =
        formatRupiah(anggota.tagihan > 0 ? anggota.tagihan : 20167);

    final pesan = 'Halo ${anggota.nama} 👋,\n'
        'Pengingat tagihan *${g.namaGrup}* untuk *$judulTagihan* sebesar *$nominalText*.\n\n'
        'Silakan transfer ke:\n'
        '$bank $rekening a.n. $penerima\n\n'
        'Jika sudah transfer, mohon unggah bukti bayar di aplikasi *KasMate*. Terima kasih!';

    final nomorTujuan = _formatNomorWa(anggota.noWa);
    final url = Uri.parse(
      'https://wa.me/$nomorTujuan?text=${Uri.encodeComponent(pesan)}',
    );
    return _bukaUrlWhatsApp(url);
  }

  Future<bool> bagikanUndanganGrupWhatsApp([GrupKas? targetGrup]) async {
    final g = targetGrup ?? grupAktif;
    final pesan = 'Halo teman-teman! 👋\n'
        'Yuk gabung ke grup kas *${g.namaGrup}* di aplikasi *KasMate*.\n\n'
        '🔑 Kode Undangan: *${g.kodeUndangan}*\n'
        '🔗 Link Undangan: ${g.linkUndangan}\n\n'
        'Buka aplikasi KasMate -> pilih *Gabung ke grup* -> masukkan kode *${g.kodeUndangan}*.';

    final url = Uri.parse('https://wa.me/?text=${Uri.encodeComponent(pesan)}');
    return _bukaUrlWhatsApp(url);
  }

  // ==================== EKSPOR LAPORAN ====================

  String generateLaporanCsv() {
    final g = grupAktif;
    final sb = StringBuffer();
    sb.writeln('LAPORAN KEUANGAN KASMATE');
    sb.writeln('Nama Grup,${g.namaGrup}');
    sb.writeln('Kode Undangan,${g.kodeUndangan}');
    sb.writeln('Bendahara,${g.bendahara}');
    sb.writeln('Saldo Kas,${g.saldo}');
    sb.writeln('Total Pemasukan,${g.pemasukan}');
    sb.writeln('Total Pengeluaran,${g.pengeluaran}');
    sb.writeln('');
    sb.writeln('STATUS ANGGOTA');
    sb.writeln('Nama Anggota,No WhatsApp,Sisa Tagihan,Status');
    for (final a in g.anggota) {
      final st = a.status == StatusBayar.lunas
          ? 'Lunas'
          : a.status == StatusBayar.menunggu
              ? 'Menunggu'
              : 'Belum Bayar';
      sb.writeln('${a.nama},${a.noWa},${a.tagihan},$st');
    }
    sb.writeln('');
    sb.writeln('RIWAYAT PENGELUARAN');
    sb.writeln('Judul,Tanggal,Sumber Dana,Total');
    for (final t in g.daftarTagihan) {
      sb.writeln('${t.judul},${t.tanggal},${t.sumberDana},${t.total}');
    }
    sb.writeln('');
    sb.writeln('RIWAYAT PEMBAYARAN');
    sb.writeln('Nama Pembayar,Tagihan,Nominal,Waktu,Status');
    for (final r in g.daftarRiwayatPembayaran) {
      sb.writeln(
          '${r.namaAnggota},${r.judulTagihan},${r.nominal},"${r.waktu}",${r.status}');
    }
    return sb.toString();
  }
}

final KasStore kasStore = KasStore();
