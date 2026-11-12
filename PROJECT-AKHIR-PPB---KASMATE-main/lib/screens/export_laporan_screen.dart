import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
import '../data/kas_store.dart';

class ExportLaporanScreen extends StatelessWidget {
  const ExportLaporanScreen({super.key});

  Future<void> _eksporDanBagikanCsv(BuildContext context) async {
    final g = kasStore.grupAktif;
    final csvContent = kasStore.generateLaporanCsv();
    final fileName =
        'Laporan_${g.namaGrup.replaceAll(' ', '_')}_${g.kodeUndangan}.csv';

    if (kIsWeb) {
      final xFile = XFile.fromData(
        utf8.encode(csvContent),
        mimeType: 'text/csv',
        name: fileName,
      );
      await Share.shareXFiles([xFile], text: 'Laporan Keuangan ${g.namaGrup}');
      return;
    }

    final dir = Directory.systemTemp;
    final file = File('${dir.path}/$fileName');
    await file.writeAsString(csvContent);

    await Share.shareXFiles(
      [XFile(file.path, mimeType: 'text/csv')],
      text: 'Laporan Keuangan KasMate - ${g.namaGrup}',
    );
  }

  @override
  Widget build(BuildContext context) {
    final g = kasStore.grupAktif;

    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFAFAFA),
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0xFF111827)),
        title: const Text(
          'Export laporan keuangan',
          style: TextStyle(
            color: Color(0xFF111827),
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFE5E7EB)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Ringkasan Laporan • ${g.namaGrup}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Kode Grup: ${g.kodeUndangan} • Bendahara: ${g.bendahara}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF6B7280),
                      ),
                    ),
                    const Divider(height: 24, color: Color(0xFFE5E7EB)),
                    _row('Saldo kas saat ini', formatRupiah(g.saldo)),
                    const SizedBox(height: 8),
                    _row('Total pemasukan', formatRupiah(g.pemasukan)),
                    const SizedBox(height: 8),
                    _row('Total pengeluaran', formatRupiah(g.pengeluaran)),
                    const SizedBox(height: 8),
                    _row('Jumlah anggota', '${g.anggota.length} orang'),
                    const SizedBox(height: 8),
                    _row(
                      'Transaksi pengeluaran',
                      '${g.daftarTagihan.length} catatan',
                    ),
                    const SizedBox(height: 8),
                    _row(
                      'Pembayaran tercatat',
                      '${g.daftarRiwayatPembayaran.length} transaksi',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'File laporan format .CSV (bisa langsung dibuka di Excel, Google Sheets, atau dikirim ke grup WhatsApp).',
                style: TextStyle(fontSize: 13, color: Color(0xFF6B7280)),
              ),
              const Spacer(),
              ElevatedButton.icon(
                onPressed: () => _eksporDanBagikanCsv(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF074E3B),
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 50),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                icon: const Icon(Icons.file_download_outlined),
                label: const Text(
                  'Export & Bagikan File (.CSV)',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                ),
              ),
              const SizedBox(height: 10),
              OutlinedButton.icon(
                onPressed: () {
                  Clipboard.setData(
                    ClipboardData(text: kasStore.generateLaporanCsv()),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Isi data laporan disalin ke clipboard'),
                    ),
                  );
                },
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 48),
                  foregroundColor: const Color(0xFF111827),
                  side: const BorderSide(color: Color(0xFFE5E7EB)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                icon: const Icon(Icons.copy_outlined, size: 18),
                label: const Text('Salin data laporan'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _row(String k, String v) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(k, style: const TextStyle(fontSize: 13, color: Color(0xFF6B7280))),
        Text(
          v,
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
        ),
      ],
    );
  }
}
