import 'package:flutter/material.dart';
import '../widgets/detail_tagihan.dart';
import '../widgets/item_struk_card.dart';
import '../widgets/tagih_button.dart';
import 'bayar_tagihan_screen.dart';

class DetailTagihanScreen extends StatelessWidget {
  const DetailTagihanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> daftarPembagian = [
      {'nama': 'Budi', 'nominal': 50000, 'status': 'lunas'},
      {'nama': 'Siti', 'nominal': 50000, 'status': 'menunggu'},
      {'nama': 'Andi', 'nominal': 50000, 'status': 'belum'},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Tagihan'),
        backgroundColor: Colors.lightBlue,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DetailTagihan(
              judul: 'Makan Malam Tim',
              total: 150000,
              tanggal: '08 Okt 2026',
              jatuhTempo: '15 Okt 2026',
              daftarPembagian: daftarPembagian,
              status: 'menunggu',
            ),
            const SizedBox(height: 24),
            const Text(
              'Rincian Struk',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            const ItemStrukCard(namaBarang: 'Makan Siang Bersama', harga: 100000),
            const ItemStrukCard(namaBarang: 'Minuman & Snack', harga: 50000),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const BayarTagihanScreen(),
                    ),
                  );
                },
                child: const Text('Lihat Instruksi Pembayaran Saya'),
              ),
            ),
            const SizedBox(height: 16),
            TagihButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Membuka WhatsApp...')),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}