import 'package:flutter/material.dart';
import '../data/kas_store.dart';
import '../data/profil_store.dart';
import '../models/pengguna.dart';
import 'gabung_grup_screen.dart';
import 'riwayat_screen.dart';
import 'export_laporan_screen.dart';
import 'login_screen.dart';

class ProfilScreen extends StatelessWidget {
  const ProfilScreen({super.key});

  void _bukaFormEditProfil(BuildContext context) {
    final profil = profilNotifier.value;
    final namaCtrl = TextEditingController(
      text: profil.nama.isEmpty ? 'Ir. Fadhil S.T M.kom' : profil.nama,
    );
    final waCtrl = TextEditingController(text: profil.noWa);
    final bankCtrl = TextEditingController(
      text: profil.bank.isEmpty ? 'BCA' : profil.bank,
    );
    final rekCtrl = TextEditingController(
      text: profil.noRekening.isEmpty ? '8820 1122 33' : profil.noRekening,
    );

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Padding(
        padding: EdgeInsets.fromLTRB(
          20,
          20,
          20,
          MediaQuery.of(ctx).viewInsets.bottom + 20,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Edit profil & rekening bendahara',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: namaCtrl,
              decoration: const InputDecoration(
                labelText: 'Nama lengkap',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: waCtrl,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                labelText: 'No WhatsApp',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: bankCtrl,
              decoration: const InputDecoration(
                labelText: 'Bank',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: rekCtrl,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'No Rekening',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                simpanProfil(
                  Pengguna(
                    id: profil.id,
                    nama: namaCtrl.text.trim(),
                    noWa: waCtrl.text.trim(),
                    bank: bankCtrl.text.trim(),
                    noRekening: rekCtrl.text.trim(),
                  ),
                );
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Profil berhasil disimpan')),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF074E3B),
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 48),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('Simpan'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Pengguna>(
      valueListenable: profilNotifier,
      builder: (context, profil, _) {
        return ValueListenableBuilder<KasRootState>(
          valueListenable: kasStore,
          builder: (context, rootState, _) {
            final state = rootState.grupAktif;
            final namaTampil =
                profil.nama.isEmpty ? 'Ir. Fadhil S.T M.kom' : profil.nama;

            return Scaffold(
              backgroundColor: const Color(0xFFFAFAFA),
              body: SafeArea(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 24),
                      Center(
                        child: Column(
                          children: [
                            CircleAvatar(
                              radius: 36,
                              backgroundColor: const Color(0xFFDBEAFE),
                              child: Text(
                                namaTampil[0].toUpperCase(),
                                style: const TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF1D4ED8),
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              namaTampil,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF111827),
                              ),
                            ),
                            const SizedBox(height: 6),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  state.namaGrup,
                                  style: const TextStyle(
                                    fontSize: 13,
                                    color: Color(0xFF6B7280),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 3,
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFDCFCE7),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: const Text(
                                    'Bendahara',
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF15803D),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 28),
                      const Text(
                        'Riwayat & Laporan',
                        style: TextStyle(
                          fontSize: 13,
                          color: Color(0xFF6B7280),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: const Color(0xFFE5E7EB)),
                        ),
                        child: Column(
                          children: [
                            _buildMenuTile(
                              title:
                                  'Riwayat pembayaran (${state.daftarRiwayatPembayaran.length})',
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        const RiwayatScreen(initialTab: 0),
                                  ),
                                );
                              },
                            ),
                            const Divider(
                              color: Color(0xFFE5E7EB),
                              height: 1,
                            ),
                            _buildMenuTile(
                              title:
                                  'Riwayat pengeluaran (${state.daftarTagihan.length})',
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        const RiwayatScreen(initialTab: 1),
                                  ),
                                );
                              },
                            ),
                            const Divider(
                              color: Color(0xFFE5E7EB),
                              height: 1,
                            ),
                            _buildMenuTile(
                              title: 'Export laporan (.CSV)',
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const ExportLaporanScreen(),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'Akun & Grup',
                        style: TextStyle(
                          fontSize: 13,
                          color: Color(0xFF6B7280),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: const Color(0xFFE5E7EB)),
                        ),
                        child: Column(
                          children: [
                            _buildMenuTile(
                              title: 'Edit profil & rekening',
                              onTap: () => _bukaFormEditProfil(context),
                            ),
                            const Divider(
                              color: Color(0xFFE5E7EB),
                              height: 1,
                            ),
                            _buildMenuTile(
                              title: 'Gabung grup lain',
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const GabungGrupScreen(),
                                  ),
                                );
                              },
                            ),
                            const Divider(
                              color: Color(0xFFE5E7EB),
                              height: 1,
                            ),
                            _buildMenuTile(
                              title: 'Logout',
                              isDestructive: true,
                              onTap: () {
                                Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const LoginScreen(),
                                  ),
                                  (route) => false,
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildMenuTile({
    required String title,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color:
              isDestructive ? const Color(0xFFB91C1C) : const Color(0xFF111827),
        ),
      ),
      trailing: const Icon(
        Icons.chevron_right_rounded,
        color: Color(0xFF9CA3AF),
        size: 20,
      ),
    );
  }
}
