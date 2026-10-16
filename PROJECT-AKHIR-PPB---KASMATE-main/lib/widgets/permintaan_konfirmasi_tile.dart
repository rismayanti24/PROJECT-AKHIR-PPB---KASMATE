import 'package:flutter/material.dart';
import '../utils/format.dart';

class PermintaanKonfirmasiTile extends StatelessWidget {
  final String nama;
  final int nominal;
  final VoidCallback onKonfirmasi;

  const PermintaanKonfirmasiTile({
    super.key,
    required this.nama,
    required this.nominal,
    required this.onKonfirmasi,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: CircleAvatar(
        backgroundColor: Colors.lightBlue.shade100,
        child: Text(
          nama.isNotEmpty ? nama[0].toUpperCase() : '?',
          style: TextStyle(
            color: Colors.lightBlue.shade900,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      title: Text(
        nama,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Text('Mengklaim sudah bayar ${formatRupiah(nominal)}'),
      trailing: ElevatedButton(
        onPressed: onKonfirmasi,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.lightBlue,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16),
        ),
        child: const Text('Konfirmasi'),
      ),
    );
  }
}
