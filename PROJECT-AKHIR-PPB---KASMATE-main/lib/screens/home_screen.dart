import 'package:flutter/material.dart';
import '../widgets/saldo_card.dart';
import '../widgets/permintaan_konfirmasi_tile.dart';
import 'detail_tagihan_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          // 1. TOP CURVED BLUE HEADER (Header Melengkung Biru)
          Container(
            padding: const EdgeInsets.fromLTRB(20, 50, 20, 30),
            decoration: const BoxDecoration(
              color: Color(0xFF0D1B2A), // Biru tua sesuai desain
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(32),
                bottomRight: Radius.circular(32),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.sort, color: Colors.white),
                      onPressed: () {},
                    ),
                    const CircleAvatar(
                      radius: 20,
                      backgroundColor: Colors.white24,
                      child: Icon(Icons.person, color: Colors.white),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const Text(
                  'Dashboard',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text(
                  'KasMate Finance Manager',
                  style: TextStyle(color: Colors.white70, fontSize: 13),
                ),
                const SizedBox(height: 20),
                // Card Saldo diletakkan di dalam Header
                const SaldoCard(saldo: 1500000, totalTagihan: 150000),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // 2. GRID MENU (2 Kolom Kartu Putih Melengkung)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              children: [
                _buildMenuCard(
                  context,
                  title: 'Detail Tagihan',
                  icon: Icons.receipt_long,
                  color: Colors.blue.shade100,
                  iconColor: Colors.blue.shade700,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const DetailTagihanScreen(),
                      ),
                    );
                  },
                ),
                _buildMenuCard(
                  context,
                  title: 'Konfirmasi',
                  icon: Icons.assignment_turned_in,
                  color: Colors.purple.shade100,
                  iconColor: Colors.purple.shade700,
                  onTap: () {},
                ),
                _buildMenuCard(
                  context,
                  title: 'Anggota Kas',
                  icon: Icons.group,
                  color: Colors.orange.shade100,
                  iconColor: Colors.orange.shade700,
                  onTap: () {},
                ),
                _buildMenuCard(
                  context,
                  title: 'Laporan Struk',
                  icon: Icons.analytics,
                  color: Colors.green.shade100,
                  iconColor: Colors.green.shade700,
                  onTap: () {},
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // 3. DAFTAR PERMINTAAN KONFIRMASI
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Permintaan Konfirmasi',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                PermintaanKonfirmasiTile(
                  nama: 'Siti',
                  nominal: 50000,
                  onKonfirmasi: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Pembayaran dikonfirmasi!')),
                    );
                  },
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Widget Pembantu untuk Kartu Grid
  Widget _buildMenuCard(
    BuildContext context, {
    required String title,
    required IconData icon,
    required Color color,
    required Color iconColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
              child: Icon(icon, color: iconColor, size: 28),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}