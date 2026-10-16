import 'package:flutter/material.dart';
import '../widgets/tagihan_kartu.dart';

class BayarTagihanScreen extends StatelessWidget {
  const BayarTagihanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pembayaran Tagihan'),
        backgroundColor: Colors.lightBlue,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TagihanKartu(
              jumlah: 50000,
              namaPenerima: 'Budi Santoso',
              bank: 'BCA',
              noRekening: '1234567890',
              onBayar: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Konfirmasi pembayaran dikirim!')),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}