import 'package:flutter/material.dart';
import '../widgets/status_badge.dart';
import '../widgets/member_tile.dart';
import '../widgets/saldo_card.dart';
import '../widgets/item_struk_card.dart';
import '../widgets/tagih_button.dart';
import '../widgets/tagihan_kartu.dart';
import '../widgets/permintaan_konfirmasi_tile.dart';
import '../widgets/detail_tagihan.dart';

class WidgetPreviewScreen extends StatelessWidget {
  const WidgetPreviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Widget Preview'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildSectionTitle('1. StatusBadge'),
          const Wrap(
            spacing: 8,
            children: [
              StatusBadge(status: 'belum'),
              StatusBadge(status: 'menunggu'),
              StatusBadge(status: 'lunas'),
            ],
          ),
          
          _buildSectionTitle('2. MemberTile'),
          const MemberTile(nama: 'Andi', nominal: 100000, status: 'belum'),
          const MemberTile(nama: 'Budi', nominal: 85000, status: 'lunas'),
          
          _buildSectionTitle('3. SaldoCard'),
          const SaldoCard(saldo: 750000, totalTagihan: 325000),
          
          _buildSectionTitle('4. ItemStrukCard'),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Column(
              children: [
                ItemStrukCard(namaBarang: 'Beras', harga: 75000),
                ItemStrukCard(namaBarang: 'Minyak', harga: 35000),
              ],
            ),
          ),
          
          _buildSectionTitle('5. TagihButton'),
          TagihButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Membuka WhatsApp...')),
              );
            },
          ),
          
          _buildSectionTitle('6. TagihanKartu'),
          TagihanKartu(
            jumlah: 100000,
            namaPenerima: 'Andi',
            bank: 'BCA',
            noRekening: '1234567890',
            onBayar: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Proses bayar...')),
              );
            },
          ),
          
          _buildSectionTitle('7. PermintaanKonfirmasiTile'),
          PermintaanKonfirmasiTile(
            nama: 'Budi',
            nominal: 87500,
            onKonfirmasi: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Terkonfirmasi!')),
              );
            },
          ),
          
          _buildSectionTitle('8. DetailTagihan'),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const DetailTagihan(
              judul: 'Belanja Dapur',
              total: 260000,
              tanggal: '15 Okt 2024',
              jatuhTempo: '20 Okt 2024',
              status: 'belum',
              daftarPembagian: [
                {'nama': 'Andi', 'nominal': 65000, 'status': 'belum'},
                {'nama': 'Budi', 'nominal': 65000, 'status': 'menunggu'},
                {'nama': 'Dewi', 'nominal': 65000, 'status': 'lunas'},
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 24, bottom: 12),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      ),
    );
  }
}
