import 'package:flutter/material.dart';
import '../data/kas_store.dart';

class RiwayatScreen extends StatelessWidget {
  final int initialTab;
  const RiwayatScreen({super.key, this.initialTab = 0});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<KasRootState>(
      valueListenable: kasStore,
      builder: (context, rootState, _) {
        final state = rootState.grupAktif;

        return DefaultTabController(
          length: 2,
          initialIndex: initialTab,
          child: Scaffold(
            backgroundColor: const Color(0xFFFAFAFA),
            appBar: AppBar(
              backgroundColor: const Color(0xFFFAFAFA),
              elevation: 0,
              iconTheme: const IconThemeData(color: Color(0xFF111827)),
              title: const Text(
                'Riwayat transaksi',
                style: TextStyle(
                  color: Color(0xFF111827),
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
              bottom: const TabBar(
                labelColor: Color(0xFF074E3B),
                unselectedLabelColor: Color(0xFF6B7280),
                indicatorColor: Color(0xFF074E3B),
                tabs: [
                  Tab(text: 'Pembayaran'),
                  Tab(text: 'Pengeluaran'),
                ],
              ),
            ),
            body: TabBarView(
              children: [
                state.daftarRiwayatPembayaran.isEmpty
                    ? const Center(
                        child: Text(
                          'Belum ada riwayat pembayaran terverifikasi.',
                          style: TextStyle(color: Color(0xFF6B7280)),
                        ),
                      )
                    : ListView.separated(
                        padding: const EdgeInsets.all(20),
                        itemCount: state.daftarRiwayatPembayaran.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 10),
                        itemBuilder: (context, index) {
                          final item = state.daftarRiwayatPembayaran[index];
                          final isLunas = item.status == 'Lunas';

                          return Container(
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                color: const Color(0xFFE5E7EB),
                              ),
                            ),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  backgroundColor: isLunas
                                      ? const Color(0xFFDCFCE7)
                                      : const Color(0xFFFEE2E2),
                                  child: Icon(
                                    isLunas
                                        ? Icons.check_rounded
                                        : Icons.close_rounded,
                                    color: isLunas
                                        ? const Color(0xFF15803D)
                                        : const Color(0xFFB91C1C),
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
                                          fontWeight: FontWeight.w700,
                                          fontSize: 14,
                                        ),
                                      ),
                                      Text(
                                        '${item.judulTagihan} • ${item.waktu}',
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: Color(0xFF6B7280),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      formatRupiah(item.nominal),
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 14,
                                      ),
                                    ),
                                    Text(
                                      item.status,
                                      style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w600,
                                        color: isLunas
                                            ? const Color(0xFF15803D)
                                            : const Color(0xFFB91C1C),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                state.daftarTagihan.isEmpty
                    ? const Center(
                        child: Text(
                          'Belum ada catatan pengeluaran.',
                          style: TextStyle(color: Color(0xFF6B7280)),
                        ),
                      )
                    : ListView.separated(
                        padding: const EdgeInsets.all(20),
                        itemCount: state.daftarTagihan.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 10),
                        itemBuilder: (context, index) {
                          final t = state.daftarTagihan[index];
                          return Container(
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                color: const Color(0xFFE5E7EB),
                              ),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        t.judul,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 14,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        '${t.tanggal} • ${t.sumberDana} • ${t.items.length} item',
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: Color(0xFF6B7280),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Text(
                                  formatRupiah(t.total),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 14,
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(
                                    Icons.delete_outline,
                                    color: Color(0xFFB91C1C),
                                  ),
                                  onPressed: () {
                                    kasStore.hapusTagihan(t.id);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          'Pengeluaran "${t.judul}" dihapus',
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          );
                        },
                      ),
              ],
            ),
          ),
        );
      },
    );
  }
}
