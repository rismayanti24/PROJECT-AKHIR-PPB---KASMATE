import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../data/kas_store.dart';

class KonfirmasiPembayaranScreen extends StatelessWidget {
  final bool showBackButton;
  const KonfirmasiPembayaranScreen({super.key, this.showBackButton = true});

  void _lihatBuktiFull(BuildContext context, KonfirmasiItem item) {
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Bukti Transfer - ${item.namaAnggota}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 12),
              if (item.buktiPath.isNotEmpty)
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: kIsWeb
                      ? Image.network(item.buktiPath, fit: BoxFit.contain)
                      : Image.file(File(item.buktiPath), fit: BoxFit.contain),
                )
              else
                Container(
                  height: 180,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF3F4F6),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.receipt_long_outlined,
                        size: 40,
                        color: Color(0xFF6B7280),
                      ),
                      const SizedBox(height: 8),
                      Text(item.namaFileBukti),
                    ],
                  ),
                ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text('Tutup'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<KasRootState>(
      valueListenable: kasStore,
      builder: (context, rootState, _) {
        final antrean = rootState.grupAktif.daftarKonfirmasi;

        return Scaffold(
          backgroundColor: const Color(0xFFFAFAFA),
          appBar: AppBar(
            backgroundColor: const Color(0xFFFAFAFA),
            elevation: 0,
            scrolledUnderElevation: 0,
            automaticallyImplyLeading: showBackButton,
            iconTheme: const IconThemeData(color: Color(0xFF111827)),
            title: const Text(
              'Konfirmasi pembayaran',
              style: TextStyle(
                color: Color(0xFF111827),
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          body: SafeArea(
            child: antrean.isEmpty
                ? const Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.verified_outlined,
                          size: 48,
                          color: Color(0xFF9CA3AF),
                        ),
                        SizedBox(height: 12),
                        Text(
                          'Tidak ada pembayaran yang menunggu konfirmasi',
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFF6B7280),
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 8,
                    ),
                    itemCount: antrean.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 14),
                    itemBuilder: (context, index) {
                      final item = antrean[index];
                      return Container(
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: const Color(0xFFE5E7EB)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                CircleAvatar(
                                  radius: 20,
                                  backgroundColor: const Color(0xFFDBEAFE),
                                  child: Text(
                                    item.namaAnggota[0].toUpperCase(),
                                    style: const TextStyle(
                                      color: Color(0xFF1D4ED8),
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item.namaAnggota,
                                        style: const TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w700,
                                          color: Color(0xFF111827),
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        '${formatRupiah(item.nominal)} • ${item.judulTagihan}',
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: Color(0xFF6B7280),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 14),
                            // Preview Bukti Transfer Asli (Bisa diklik untuk zoom)
                            GestureDetector(
                              onTap: () => _lihatBuktiFull(context, item),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: item.buktiPath.isNotEmpty
                                    ? Stack(
                                        alignment: Alignment.bottomRight,
                                        children: [
                                          kIsWeb
                                              ? Image.network(
                                                  item.buktiPath,
                                                  width: double.infinity,
                                                  height: 165,
                                                  fit: BoxFit.cover,
                                                )
                                              : Image.file(
                                                  File(item.buktiPath),
                                                  width: double.infinity,
                                                  height: 165,
                                                  fit: BoxFit.cover,
                                                ),
                                          Container(
                                            margin: const EdgeInsets.all(8),
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 10,
                                              vertical: 4,
                                            ),
                                            decoration: BoxDecoration(
                                              color: Colors.black54,
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),
                                            child: const Text(
                                              'Ketuk untuk perbesar',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 11,
                                              ),
                                            ),
                                          ),
                                        ],
                                      )
                                    : Container(
                                        width: double.infinity,
                                        height: 140,
                                        color: const Color(0xFFF3F4F6),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            const Icon(
                                              Icons.receipt_outlined,
                                              size: 32,
                                              color: Color(0xFF9CA3AF),
                                            ),
                                            const SizedBox(height: 8),
                                            Text(
                                              item.namaFileBukti,
                                              style: const TextStyle(
                                                fontSize: 12,
                                                color: Color(0xFF6B7280),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                              ),
                            ),
                            const SizedBox(height: 14),
                            _buildMetaRow(
                              'Nominal diunggah',
                              formatRupiah(item.nominal),
                            ),
                            const SizedBox(height: 8),
                            _buildMetaRow('Waktu unggah', item.waktuUnggah),
                            const SizedBox(height: 18),
                            Row(
                              children: [
                                Expanded(
                                  child: OutlinedButton(
                                    onPressed: () {
                                      kasStore.verifikasiPembayaran(
                                        item.id,
                                        diterima: false,
                                      );
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            'Pembayaran ${item.namaAnggota} ditolak & dicatat di riwayat',
                                          ),
                                        ),
                                      );
                                    },
                                    style: OutlinedButton.styleFrom(
                                      minimumSize:
                                          const Size(double.infinity, 46),
                                      foregroundColor: const Color(0xFFB91C1C),
                                      side: const BorderSide(
                                        color: Color(0xFFFECACA),
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                    child: const Text(
                                      'Tolak',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: () {
                                      kasStore.verifikasiPembayaran(
                                        item.id,
                                        diterima: true,
                                      );
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            '${item.namaAnggota} dikonfirmasi LUNAS! Saldo kas bertambah.',
                                          ),
                                        ),
                                      );
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFF074E3B),
                                      foregroundColor: Colors.white,
                                      minimumSize:
                                          const Size(double.infinity, 46),
                                      elevation: 0,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                    child: const Text(
                                      'Konfirmasi lunas',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        );
      },
    );
  }

  Widget _buildMetaRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 13, color: Color(0xFF6B7280)),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Color(0xFF111827),
          ),
        ),
      ],
    );
  }
}
