import 'package:flutter/material.dart';
import '../data/kas_store.dart';
import 'buat_grup_screen.dart';
import 'gabung_grup_screen.dart';
import 'buat_tagihan_screen.dart';
import 'bayar_tagihan_screen.dart';
import 'konfirmasi_pembayaran_screen.dart';
import 'riwayat_screen.dart';
import 'login_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static const Color _primaryGreen = Color(0xFF074E3B);

  void _bukaDialogTambahAnggota(BuildContext context) {
    final namaCtrl = TextEditingController();
    final waCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.white,
        title: const Text(
          'Tambah anggota grup',
          style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: namaCtrl,
              decoration: const InputDecoration(
                labelText: 'Nama anggota',
                hintText: 'Contoh: Budi Santoso',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: waCtrl,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                labelText: 'Nomor WhatsApp',
                hintText: '0812xxxxxxxx',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              if (namaCtrl.text.trim().isEmpty) return;
              kasStore.tambahAnggota(
                nama: namaCtrl.text,
                noWa: waCtrl.text.isEmpty ? '081234567890' : waCtrl.text,
              );
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('${namaCtrl.text.trim()} ditambahkan ke grup'),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: _primaryGreen,
              foregroundColor: Colors.white,
            ),
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
  }

  void _bukaSheetTagihWhatsApp(BuildContext context, GrupKas state) {
    final belumLunas =
        state.anggota.where((a) => a.status != StatusBayar.lunas).toList();

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Kirim pengingat via WhatsApp',
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 4),
            const Text(
              'Pilih anggota yang belum melunasi tagihan',
              style: TextStyle(fontSize: 13, color: Color(0xFF6B7280)),
            ),
            const SizedBox(height: 16),
            if (belumLunas.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: Center(
                  child: Text('Semua anggota sudah melunasi tagihan! 🎉'),
                ),
              )
            else
              ...belumLunas.map(
                (anggota) => ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: CircleAvatar(
                    backgroundColor: anggota.avatarColor,
                    child: Text(
                      anggota.nama[0].toUpperCase(),
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF111827),
                      ),
                    ),
                  ),
                  title: Text(
                    anggota.nama,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  subtitle: Text(
                    'Tagihan: ${formatRupiah(anggota.tagihan > 0 ? anggota.tagihan : 20167)}',
                  ),
                  trailing: ElevatedButton.icon(
                    onPressed: () async {
                      Navigator.pop(ctx);
                      final berhasil =
                          await kasStore.kirimTagihanWhatsApp(anggota);
                      if (!berhasil && context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Gagal membuka WhatsApp/Browser. Cek koneksi atau aplikasi browser di perangkat.',
                            ),
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF15803D),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    icon: const Icon(Icons.send_rounded, size: 16),
                    label: const Text('Tagih WA'),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<KasRootState>(
      valueListenable: kasStore,
      builder: (context, rootState, _) {
        final state = rootState.grupAktif;

        return Scaffold(
          backgroundColor: const Color(0xFFFAFAFA),
          drawer: Drawer(
            backgroundColor: Colors.white,
            child: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'KASMATE',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            color: _primaryGreen,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Kode aktif: ${state.kodeUndangan}',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFF6B7280),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Divider(height: 1, color: Color(0xFFE5E7EB)),
                  const Padding(
                    padding: EdgeInsets.fromLTRB(16, 12, 16, 4),
                    child: Text(
                      'DAFTAR GRUP SAYA',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF6B7280),
                      ),
                    ),
                  ),
                  ...rootState.daftarGrup.map((g) {
                    final aktif = g.id == state.id;
                    return ListTile(
                      dense: true,
                      leading: Icon(
                        aktif
                            ? Icons.radio_button_checked
                            : Icons.radio_button_unchecked,
                        color: aktif ? _primaryGreen : const Color(0xFF9CA3AF),
                        size: 20,
                      ),
                      title: Text(
                        g.namaGrup,
                        style: TextStyle(
                          fontWeight: aktif ? FontWeight.w700 : FontWeight.w500,
                        ),
                      ),
                      subtitle: Text('Kode: ${g.kodeUndangan}'),
                      onTap: () {
                        kasStore.pilihGrupAktif(g.id);
                        Navigator.pop(context);
                      },
                    );
                  }),
                  const Divider(height: 1, color: Color(0xFFE5E7EB)),
                  ListTile(
                    leading:
                        const Icon(Icons.share_outlined, color: _primaryGreen),
                    title: const Text('Bagikan link grup ke WA'),
                    onTap: () {
                      Navigator.pop(context);
                      kasStore.bagikanUndanganGrupWhatsApp();
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.add_circle_outline),
                    title: const Text('Buat grup baru'),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const BuatGrupScreen(),
                        ),
                      );
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.group_add_outlined),
                    title: const Text('Gabung ke grup'),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const GabungGrupScreen(),
                        ),
                      );
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.verified_outlined),
                    title: Text(
                      'Konfirmasi pembayaran (${state.daftarKonfirmasi.length})',
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const KonfirmasiPembayaranScreen(),
                        ),
                      );
                    },
                  ),
                  const Spacer(),
                  const Divider(height: 1, color: Color(0xFFE5E7EB)),
                  ListTile(
                    leading: const Icon(
                      Icons.logout,
                      color: Color(0xFFB91C1C),
                    ),
                    title: const Text(
                      'Keluar akun (Logout)',
                      style: TextStyle(color: Color(0xFFB91C1C)),
                    ),
                    onTap: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (_) => const LoginScreen()),
                        (route) => false,
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          appBar: AppBar(
            backgroundColor: const Color(0xFFFAFAFA),
            elevation: 0,
            scrolledUnderElevation: 0,
            centerTitle: true,
            iconTheme: const IconThemeData(color: Color(0xFF111827)),
            title: Text(
              state.namaGrup,
              style: const TextStyle(
                color: Color(0xFF111827),
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
            actions: [
              IconButton(
                tooltip: 'Bagikan undangan grup ke WA',
                icon: const Icon(Icons.share_outlined, size: 21),
                onPressed: () => kasStore.bagikanUndanganGrupWhatsApp(),
              ),
              IconButton(
                tooltip: 'Riwayat transaksi',
                icon: const Icon(Icons.history_rounded, size: 22),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const RiwayatScreen()),
                  );
                },
              ),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                // Kartu Saldo Kas Grup
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: _primaryGreen,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Saldo kas grup',
                            style: TextStyle(
                              color: Color.fromRGBO(255, 255, 255, 0.8),
                              fontSize: 13,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: const Color.fromRGBO(255, 255, 255, 0.14),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              state.kodeUndangan,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        formatRupiah(state.saldo),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 32,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 18),
                      Row(
                        children: [
                          Expanded(
                            child: _buildSummaryBox(
                              label: 'Pemasukan',
                              amount: formatRupiah(state.pemasukan),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildSummaryBox(
                              label: 'Pengeluaran',
                              amount: formatRupiah(state.pengeluaran),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 22),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Text(
                          'Status pembayaran',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF111827),
                          ),
                        ),
                        const SizedBox(width: 6),
                        InkWell(
                          onTap: () => _bukaDialogTambahAnggota(context),
                          borderRadius: BorderRadius.circular(20),
                          child: const Padding(
                            padding: EdgeInsets.all(4),
                            child: Icon(
                              Icons.person_add_alt_1_outlined,
                              size: 18,
                              color: _primaryGreen,
                            ),
                          ),
                        ),
                      ],
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const BayarTagihanScreen(),
                          ),
                        );
                      },
                      child: const Text(
                        'Bayar tagihan',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF2563EB),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: ListView.separated(
                    itemCount: state.anggota.length,
                    separatorBuilder: (_, __) =>
                        const Divider(color: Color(0xFFE5E7EB), height: 1),
                    itemBuilder: (context, index) {
                      final item = state.anggota[index];
                      return _buildMemberRow(context, item);
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8, bottom: 16),
                  child: Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const BuatTagihanScreen(),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _primaryGreen,
                            foregroundColor: Colors.white,
                            minimumSize: const Size(double.infinity, 50),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          icon: const Icon(Icons.add, size: 20),
                          label: const Text(
                            'Buat tagihan',
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () =>
                              _bukaSheetTagihWhatsApp(context, state),
                          style: OutlinedButton.styleFrom(
                            minimumSize: const Size(double.infinity, 50),
                            backgroundColor: Colors.white,
                            foregroundColor: const Color(0xFF111827),
                            side: const BorderSide(color: Color(0xFFE5E7EB)),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          icon: const Icon(Icons.chat_bubble_outline, size: 18),
                          label: const Text(
                            'Tagih WA',
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSummaryBox({required String label, required String amount}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: const Color.fromRGBO(255, 255, 255, 0.09),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Color.fromRGBO(255, 255, 255, 0.75),
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            amount,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMemberRow(BuildContext context, AnggotaKas anggota) {
    final bool isLunas = anggota.status == StatusBayar.lunas;
    final bool isMenunggu = anggota.status == StatusBayar.menunggu;

    final Color badgeBg = isLunas
        ? const Color(0xFFDCFCE7)
        : isMenunggu
            ? const Color(0xFFFEF3C7)
            : const Color(0xFFFEE2E2);
    final Color badgeText = isLunas
        ? const Color(0xFF15803D)
        : isMenunggu
            ? const Color(0xFFB45309)
            : const Color(0xFFB91C1C);
    final String labelStatus = isLunas
        ? 'Lunas'
        : isMenunggu
            ? 'Menunggu'
            : 'Belum bayar';

    return InkWell(
      onLongPress: () {
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('Hapus anggota?'),
            content: Text('Keluarkan ${anggota.nama} dari grup ini?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text('Batal'),
              ),
              TextButton(
                onPressed: () {
                  kasStore.hapusAnggota(anggota.id);
                  Navigator.pop(ctx);
                },
                child: const Text(
                  'Hapus',
                  style: TextStyle(color: Color(0xFFB91C1C)),
                ),
              ),
            ],
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            CircleAvatar(radius: 18, backgroundColor: anggota.avatarColor),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    anggota.nama,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF111827),
                    ),
                  ),
                  if (!isLunas && anggota.tagihan > 0)
                    Text(
                      formatRupiah(anggota.tagihan),
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF6B7280),
                      ),
                    ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
              decoration: BoxDecoration(
                color: badgeBg,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                labelStatus,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: badgeText,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
